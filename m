Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CAE6D0A4C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbjC3Pqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjC3Pqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:46:37 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9EF9EE0;
        Thu, 30 Mar 2023 08:46:13 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-177b78067ffso20163427fac.7;
        Thu, 30 Mar 2023 08:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680191169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=oJBA/37IIjC6kfXilx3ayeeRAXqubi70BYpfspioK0o=;
        b=e4W0o7k7kelgvpOZr2/E8GJHvFZmR4jWQoKaNlO/ScW3aRqbohQBhlFFSLjjBXdQkj
         Z+4LwHXSa5auE17/Hpp+4cMRo/uOoUMIIHjR9iv8GT/OQu1rDVVmeWlJtz+qM6NGPeRb
         FPwJbN/NsmI6zSkW0VxQuPTWQzylzqQgsLOQMj3QCi4nCOSkFxd4RSlVOM8fHmzpohFA
         E4SjNpow7JLhrsxdOk/Fp59HTNAn0hI04FO3plsg0kxdS2p4+E/wIDC2I16oFPshbPOF
         2GWWDcmBF6a2I5kVQcPKACgiouSJtNpHeoCX/awIzarjCOGPxpVjM1wdPiWAWIM7fZ1n
         CboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680191169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJBA/37IIjC6kfXilx3ayeeRAXqubi70BYpfspioK0o=;
        b=LWzWxyopjX5QOIEfUe72Ifr9ZOjkoNPEwJ52AgFE3nwYf4kt+LM+Dm+PMftW9FLRR+
         nkZ5q7ZxwMj/Ca82u0ojdOsKRD9LgL6x63EgaVAebAqPzIEJkzfzs4J9m7nJX9R3hMWE
         fo6XaBnC3dkOk+tPEj3eI0V0XEBMCHlVr99TRnE1WgiwPmkHT/tfFBTYnJZz1oMC6gvt
         nPPHdzoPZth/+yeZN6bVOhXpLQJbspi8D10ecDECwGf3GiWm/welHVFlfgGv9AbD5JRc
         VqfRisfnh4ZBaAqg51D20H4z0KcD7AKvQ9BbE50g57bq/E2O6osFhBDiIHyCLxrEuPCN
         tfKw==
X-Gm-Message-State: AO0yUKWhTdnjCQNuvyLjyQJpYuForC91hjUMBboiaMUfRTcnyQFCTmtL
        P0uT8wRX05v2dFI1hREDGdA=
X-Google-Smtp-Source: AKy350YGYVi0onCiOEL6jfuix4ot7d1BxrNLqI2LpurPhxw4Jz1gz5Er+kGSZMhfmR80lpKgRK1/dA==
X-Received: by 2002:a05:6871:795:b0:17a:d863:4cfc with SMTP id o21-20020a056871079500b0017ad8634cfcmr16832470oap.38.1680191169514;
        Thu, 30 Mar 2023 08:46:09 -0700 (PDT)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id tw16-20020a056871491000b0017ae909afe8sm39016oab.34.2023.03.30.08.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 08:46:09 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <e81e65f7-9a55-5e28-a2fa-516e93d8e45d@lwfinger.net>
Date:   Thu, 30 Mar 2023 10:46:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] b43legacy: Remove the unused function prev_slot()
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20230330021841.67724-1-jiapeng.chong@linux.alibaba.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230330021841.67724-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 21:18, Jiapeng Chong wrote:
> The function prev_slot is defined in the dma.c file, but not called
> elsewhere, so remove this unused function.
> 
> drivers/net/wireless/broadcom/b43legacy/dma.c:130:19: warning: unused function 'prev_slot'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4642
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/net/wireless/broadcom/b43legacy/dma.c | 8 --------
>   1 file changed, 8 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

