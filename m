Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5564C470F
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 15:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiBYOD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 09:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241533AbiBYODv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 09:03:51 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6391AA056
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:03:19 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id h15so7569294edv.7
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Qwa34n1xX547UDRROeteqbZyf3bNGYmzcwY9FotaJnE=;
        b=Xdz6v0R2CfNCrV1tMFKpbzJWVvJSIZyNYMzG7OfaMQLxBApw/F2L2P3Fdl5UzNui2O
         +DToqyVsyxT2HEN/fGLrcb1D3WjtPNhAVSf7UQNAJIWCsV+tJWOkSQ10vHRjCYmFrDiv
         eRKfvD+zsuFrf8N4nwcKi9MhaeU32kLG4jwwPRdBBCKRR1NcPDyPPvOaxsa/bSF4bGbA
         GrSbAuUJBPOokZOvlbTwdW03uOZA4MFThPmtMnktUi9BGJ1hTaGuzH6KUtqPcJPwswu0
         Hz0401J7vFMX8wleYXALZtQ3b6kL4vg5YJgIABVoQYLTSbM1bK2cnJQC7CMrxTxWi031
         /JYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qwa34n1xX547UDRROeteqbZyf3bNGYmzcwY9FotaJnE=;
        b=PYGfGu8H07fx1dH9sSp5uVWFGn1VQEv91ji0cPhmvoujsvMA7OwwwyGms2GGHTvu0M
         nddA7IWA4Q/RgKItx5kyw8OyLh+0oMYJC2hafWH2pHJyg8hDAZ3S3lshhRaJtCXPawa6
         IVenyauXXTmKDuCoVkgh36vOZcvzWfKNZzInxh2vLfGp6ks5DxKIaDQA73FrWOcRpUDW
         jWyQXCbajv8le8pU+SsijrNFpKW9N5Mv2Xveh4QI/t3N7u6z8vIjpXoseDaBl23hJasN
         vfkoI5obCtman87yKsNIx0wEpHD8ysiCFjHYqFSrVhuRkdsXd44TZvWNc4KVvHRlDrEN
         u5bw==
X-Gm-Message-State: AOAM532ODvCS1n9LbPUUz2XSXWyFFOFDYZhbQAyQYtlACkw+ROoOUZzE
        vxx3cn9Tu34YUy8KJbnk82qlQA==
X-Google-Smtp-Source: ABdhPJwZ2+6dirl+7TqqywrZ4TSyEYZzI1JXxX1OmXk62tAXcNh+oKliqHkUM08cnsHa275YSgjbgg==
X-Received: by 2002:a50:ef09:0:b0:412:e8d5:5c9d with SMTP id m9-20020a50ef09000000b00412e8d55c9dmr7253184eds.57.1645797797515;
        Fri, 25 Feb 2022 06:03:17 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id gb25-20020a170907961900b006ce423d43e1sm1033147ejc.13.2022.02.25.06.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 06:03:17 -0800 (PST)
Message-ID: <cc0a9ec0-66b0-9c02-3adb-ea8ed19b6923@blackwall.org>
Date:   Fri, 25 Feb 2022 16:03:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next 1/1] bridge: link: Add command to set port
 in locked mode
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220225114457.2386149-1-schultz.hans+netdev@gmail.com>
 <20220225114457.2386149-2-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220225114457.2386149-2-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/02/2022 13:44, Hans Schultz wrote:
> Add support for setting a bridge port in locked mode to use with 802.1X,
> so that only authorized clients are allowed access through the port.
> 
> Syntax: bridge link set dev DEV locked {on, off}
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  bridge/link.c                | 13 +++++++++++++
>  include/uapi/linux/if_link.h |  1 +
>  2 files changed, 14 insertions(+)
> 

You should add man page documentation and update iplink_bridge_slave.c
with the new option as well.

Cheers,
 Nik


