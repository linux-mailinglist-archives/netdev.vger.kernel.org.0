Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA7A6C6DB6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjCWQfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjCWQex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:34:53 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDA336FD2;
        Thu, 23 Mar 2023 09:33:36 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id bz27so15491665qtb.1;
        Thu, 23 Mar 2023 09:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9E1Pujm25vbd+wCzOHa90qVSx2qCib+x3xrMIOc8Nw=;
        b=CDlsTyn+SvkcnchV7JrbV4yYAEz6+m/OzY+yUiD8+iLFQmemD67LTwWWAdZXpVzkYP
         rDfUP9522BA5PQ+0pnn2viGFziMct9D0Va5lZj8MV0eultvmGbc6IdKWbRdGnmF293by
         vR4o+DH9TNp4PKFQ16zCyJtV8hwWB2ZP8t+wgLtaCLwMrGUTZL99vdg60hpVdMfpp4u6
         khw6hzgj0gzLVhhb/UY91IXhz1yo0Kx2Fm8CZjK2JyaPyBkAldFOtG2gRvnkFzCqB/P4
         OaN160Ep59YkIUHpJVS7Fs9Lm5shmmY0fZVzqjtAM5U8aHKC+YefDepWohfJQGOyG68h
         rRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9E1Pujm25vbd+wCzOHa90qVSx2qCib+x3xrMIOc8Nw=;
        b=j79jS9Uz4vkpSkzb6fuv/5060/XD069fsQHdQ+eeH/TTrO2yAn034ZLJOtsuromhau
         tUugStkjO92FSnRDFmjPmD6OaYa6ArUVTaiOBn+K4O/FCRp1nsyAmhPQyd80C5NdZVwF
         YE5BhfCD3fJxvKbHdV/io+7PgPmbi0ybqQBukNfjDJlIJBy3XEofUe9bxZ1Tp88R+Kuk
         iOKJtO08lu2iaCoWdPit4Qc100l2WzFl8eoCkqAu/SccZ4qnkVK3LCnkQVTOr12fH8bA
         83/lwTy70A/2WK5uPNDBUuKF3eKl3P+VnI6gWqZRoX3k6Al6cKky5HZb5f2jMTFh3fWm
         vNNA==
X-Gm-Message-State: AO0yUKUPR+fdliBxC18Hkpp3Ks0rCMoxNYy3ZEYsVQHZxNOfZ1mA0Euz
        TSq0Bvwg0GC3b944c+YcfMU=
X-Google-Smtp-Source: AK7set9UiTBv9/Svgrn5aQuc43LRC/Ea1ZlXgpL1NC+fGuRb6aJl8oXQOcbmmocMtLN80r/9y+e3qQ==
X-Received: by 2002:a05:622a:13cc:b0:3da:a657:db7b with SMTP id p12-20020a05622a13cc00b003daa657db7bmr13374186qtk.35.1679589212935;
        Thu, 23 Mar 2023 09:33:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ay16-20020a05620a179000b007461e8efacbsm13502365qkb.69.2023.03.23.09.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:33:32 -0700 (PDT)
Message-ID: <3766b93e-6325-5901-2e7b-f66374565781@gmail.com>
Date:   Thu, 23 Mar 2023 09:33:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 8/9] net: dsa: update TX path comments to not
 mention skb_mac_header()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-9-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 16:38, Vladimir Oltean wrote:
> Once commit 6d1ccff62780 ("net: reset mac header in dev_start_xmit()")
> will be reverted, it will no longer be true that skb->data points at
> skb_mac_header(skb) - since the skb->mac_header will not be set - so
> stop saying that, and just say that it points to the MAC header.
> 
> I've reviewed vlan_insert_tag() and it does not *actually* depend on
> skb_mac_header(), so reword that to avoid the confusion.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

  }

-- 
Florian

