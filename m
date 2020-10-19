Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9597292A1B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgJSPOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbgJSPOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:14:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A337C0613CE;
        Mon, 19 Oct 2020 08:14:35 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dt13so14384995ejb.12;
        Mon, 19 Oct 2020 08:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k5HKd5Dvm+PlmQWNtjdNQ6J81HIZ/9KCp/3Jwtpcssc=;
        b=ddobrC7lYIkh7S1IKtscl3NNuKCvcMX6IEgHPwvFIZFbsHW4OfZYYazaUnaKzPRVIK
         CKU55gIYVcM/9FHaGMvlFxzC1r2huOZ8mjBXjYP2CWqxDyBuXsEVCDxmxIDIPeExSJRY
         OghIyHdkCsSD8KXiWcdXiLtCydIbCHHOJ+Lb6BoSfkNj1gTQ/Q2qLc0SZ1uyUZ5hI9c1
         hRx8Knlort1CVMhBFspVp7+clQ3/KKbWBawK1lA2CaHxeKLV3Oo5OsCSZIrmkPNtN/ju
         vLkN1t2T0QuvTehhSdKZWoUV34OHlS9pT6FncMqh6nWdXKqMLIH4i8YFAtqH5RnZY2R+
         h7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k5HKd5Dvm+PlmQWNtjdNQ6J81HIZ/9KCp/3Jwtpcssc=;
        b=QLJH0N5iYavCDQGU93EjTK0dzExOrh+lnybbOB1lVOS4dLkTFuA4n8HgZeX63jWMWm
         agHjOqbgmO9xNe36NwTzn71EgQwhKBXr+mM+YlzoPrq+GNvpqA+Kkamgspc3T8gJOxQd
         acCZKOflFGKuBc5BAm40FWqDJYu6PlYiG2L6/QM4PRplEb0SzlV5/oUu1vZiziRA8jKv
         WOGSguLAlStCldZZ/Q6irngiNeUw3XZb1dROv5CkcGOLwzufjK5IFDCrfgccHNjibTKN
         mnR3X3x1f+zFWElPJo4hMTP0L4fm6ZXr/UXPUALQUO1lN4u8HxHmCEduQgVQiDbc7YpL
         N2uA==
X-Gm-Message-State: AOAM530/7lwyBuw/68X7PSpiXN+Ri0dI0H0PgXcHsPET/QrL/8BF5X2T
        ziRhWKbFLgdbXiBBHo1mN9U=
X-Google-Smtp-Source: ABdhPJwkNiFb2lN6FLk3b7+NSS9qfzUjlDcr/p+hf7yimWmeWx7m0sBipByrZWa1e5cRwwxLpQM3Ig==
X-Received: by 2002:a17:906:8c6:: with SMTP id o6mr369350eje.304.1603120474210;
        Mon, 19 Oct 2020 08:14:34 -0700 (PDT)
Received: from debian64.daheim (pd9e29b8a.dip0.t-ipconnect.de. [217.226.155.138])
        by smtp.gmail.com with ESMTPSA id a19sm11494812edb.84.2020.10.19.08.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:14:33 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1kUWro-0009z5-4Z; Mon, 19 Oct 2020 17:14:32 +0200
Subject: Re: [PATCH] wireless: remove unneeded break
To:     trix@redhat.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, ath9k-devel@qca.qualcomm.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        chunkeey@googlemail.com, pkshih@realtek.com, sara.sharon@intel.com,
        tova.mussai@intel.com, nathan.errera@intel.com,
        lior2.cohen@intel.com, john@phrozen.org, shaul.triebitz@intel.com,
        shahar.s.matityahu@intel.com, Larry.Finger@lwfinger.net,
        zhengbin13@huawei.com, christophe.jaillet@wanadoo.fr,
        yanaijie@huawei.com, joe@perches.com, saurav.girepunje@gmail.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20201019150507.20574-1-trix@redhat.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <b31478ea-979a-1c9c-65db-32325233a715@gmail.com>
Date:   Mon, 19 Oct 2020 17:14:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201019150507.20574-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/2020 17:05, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A break is not needed if it is preceded by a return or goto
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

> diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
> index 5bd35c147e19..3ca9d26df174 100644
> --- a/drivers/net/wireless/intersil/p54/eeprom.c
> +++ b/drivers/net/wireless/intersil/p54/eeprom.c
> @@ -870,7 +870,6 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
>   			} else {
>   				goto good_eeprom;
>   			}
> -			break;
Won't the compiler (gcc) now complain about a missing fallthrough annotation?
>   		default:
>   			break;
>   		}

Cheers,
Christian
