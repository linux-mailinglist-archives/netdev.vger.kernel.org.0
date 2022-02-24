Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA9E4C24CC
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 08:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiBXH4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 02:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiBXH4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 02:56:52 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6CA235854;
        Wed, 23 Feb 2022 23:56:21 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id r10so619316wrp.3;
        Wed, 23 Feb 2022 23:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=75MxyoNLX+jup+3IZc6uzyBIvH5fg0GcSMBv0gLbqp0=;
        b=H/k93g5NLzzNzoxwKfe8LDJebraiMpZshak6/6jcSf6DsqkHkkV04+FC8w+9g4X5O4
         i67rWmn6FZzAaPLQOfopBkul41ZHkuq00QhdDDMqGX8M3JlCV3a8Y1rd7cCQ36tnAWDm
         2PCOHNQgY19f9sETQeDKCUzMKN8iGa9AmkvQbdtzTRhT1y3hqXhY6Ov+grh4i6snLmy9
         YZ4Zp4zMStYeQQvxHizbceIgiugE+u93IalzdR1zeea2lDN+nvICdisUCtxCH2HFrFXg
         SMijirS44Gbqxa7cfV1p1qlGwE4HtKgVkBegRQXpPSjp1enh1CnANa4XgIpVHZjHSPDg
         itqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=75MxyoNLX+jup+3IZc6uzyBIvH5fg0GcSMBv0gLbqp0=;
        b=oWNpFQrajPUVHYeXxE03RMHqsR7/ZGBNpLl1gLE43eEKk5I2E+zgAj7LHu+4rnYCTZ
         T3JAuC4mdZvgiTFR0IgUDTd8QeBzWQ+Wop4LyL/KcIWCEVmodCg3tsu1Le3kg6fd6K5A
         bevYWXxe+H1H7NZR/0o63JmpWnLu6JB2CZX0YDavF8X7U0NEE+lUR1F/95/TAcr+4mlb
         rHVOfdAnkuL5ilDUqEZzp8ea4F077ToQdvhTaOka6rIRXuAXq7THSvEDcpNkqrexqgnW
         ePHeRyXZfTq7D4/DjjDZ6ZRBCHbhCgANC4lfSnR3UQBYy8J/zPa76H6lKlwVVChWcY3L
         VSGg==
X-Gm-Message-State: AOAM533bSlCSclJrTI78NfawDXPe9A8zN8Q9QIRRUYID8/+2Np6WdL4Y
        kR8mAMeH/ux85lA5lN/6Zk8=
X-Google-Smtp-Source: ABdhPJyx+djfyMcrNLUFaHnhzbfJAxxXHv1T/rgX4SDnFbAEIFbr1U7OG74bMhel4A/hupIb0z20qw==
X-Received: by 2002:a05:6000:18ad:b0:1e8:cbe1:afd with SMTP id b13-20020a05600018ad00b001e8cbe10afdmr1188474wri.352.1645689380036;
        Wed, 23 Feb 2022 23:56:20 -0800 (PST)
Received: from ?IPV6:2a00:23c5:5785:9a01:b013:cd66:72b0:92c8? ([2a00:23c5:5785:9a01:b013:cd66:72b0:92c8])
        by smtp.gmail.com with ESMTPSA id x14sm2352487wru.0.2022.02.23.23.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 23:56:19 -0800 (PST)
Message-ID: <d9969551-77ca-fda7-b30a-da5d9e1dfcd6@gmail.com>
Date:   Thu, 24 Feb 2022 07:56:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 2/2] Revert "xen-netback: Check for hotplug-status
 existence before watching"
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Michael Brown <mcb30@ipxe.org>,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:XEN NETWORK BACKEND DRIVER" 
        <xen-devel@lists.xenproject.org>,
        "open list:XEN NETWORK BACKEND DRIVER" <netdev@vger.kernel.org>
References: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
 <20220222001817.2264967-2-marmarek@invisiblethingslab.com>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20220222001817.2264967-2-marmarek@invisiblethingslab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/02/2022 00:18, Marek Marczykowski-Górecki wrote:
> This reverts commit 2afeec08ab5c86ae21952151f726bfe184f6b23d.
> 
> The reasoning in the commit was wrong - the code expected to setup the
> watch even if 'hotplug-status' didn't exist. In fact, it relied on the
> watch being fired the first time - to check if maybe 'hotplug-status' is
> already set to 'connected'. Not registering a watch for non-existing
> path (which is the case if hotplug script hasn't been executed yet),
> made the backend not waiting for the hotplug script to execute. This in
> turns, made the netfront think the interface is fully operational, while
> in fact it was not (the vif interface on xen-netback side might not be
> configured yet).
> 
> This was a workaround for 'hotplug-status' erroneously being removed.
> But since that is reverted now, the workaround is not necessary either.
> 
> More discussion at
> https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

Reviewed-by: Paul Durrant <paul@xen.org>
