Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AF8632D7A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiKUT4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiKUT4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:56:37 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E0E1057D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:56:36 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h24so7972539qta.9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GeUeakz4BxJAXBjYryjNoxv1NuWJ41C/tLlOWTExDyI=;
        b=M+Ea0G3yRcz3lWmnVKa/End50pPyPGRl4C4HBpCcdnCUCfQ7GLgB9+c9dO1BYSkFRS
         DBQZHWLNkzJgq04U2EUmdcLjizfgN3EtXWPi0kOvhv1Zatb6tFh0K+Rx2k1rsMbiGHdV
         RjPYFptJIQQkeU3fvqejd/38Ofi079UofSNolbB3GGAoZMBVZFfGMoQ+F75Ulp2ZoSBp
         mKSERMIxPOMDlpNuOpbjRetpgS3ger7lODCh8w095oHEHyijkFe/xsas98F+rL2rZxEI
         NQpk6nCgHkQAZ0rYCd0WGVHFuouUkex25+6O9l5+7WRShwxxb2PEYO11FDHaxO5QwZyg
         kbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GeUeakz4BxJAXBjYryjNoxv1NuWJ41C/tLlOWTExDyI=;
        b=7rsiF5z6hDly05I0uZOg2BUXIZ00L1mgnsulwAppsq5M9WeqTG6poeQ66WNJskeA4m
         4vfIXzY82CG1L4/0QZmI78apDuIme4ovprFp/isr9TY3EnWdfnzjIsEfm5aRnOom9iuz
         J9K27irg3kkkJJgV72UylJFqvUrQvlIpvxfIPKtMzv5V98d9qYP75t6ptfbJpWj6Mk26
         pESicLusBf8Nvz7LuDczT3jjMtaAizZPMdANOI5JGH3NEn6wrw0ZunHY5z6v61WQjzTQ
         c5n13Ca5zkzb0f/ey7HFTYBzEQN+u76kvxFx8YvIoRm1cUItE8kNRSRS62i6d7vvEtFv
         N5yA==
X-Gm-Message-State: ANoB5pmcSvadAdLGSdrzrFhvAwXlZj3KghmejjVD9iqvD6t7d7Z3wegs
        hbFDzIAeGCXfqXdAXtbkKk+bhjKHIJ8=
X-Google-Smtp-Source: AA0mqf4+HbrIfTkjbfgdnHYzGNG4c+plSZtvPB16ZNjZE1v7GETZmbOpBO6/5wMK4qoeJnAiLJie8A==
X-Received: by 2002:a05:622a:5c09:b0:3a6:2155:bac3 with SMTP id gd9-20020a05622a5c0900b003a62155bac3mr17279458qtb.356.1669060595746;
        Mon, 21 Nov 2022 11:56:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y11-20020a37f60b000000b006ce1bfbd603sm8522807qkj.124.2022.11.21.11.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:56:35 -0800 (PST)
Message-ID: <36728eea-4485-69a6-d4f3-643efd3a8f40@gmail.com>
Date:   Mon, 21 Nov 2022 11:56:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 02/17] net: dsa: modularize DSA_TAG_PROTO_NONE
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 05:55, Vladimir Oltean wrote:
> There is no reason that I can see why the no-op tagging protocol should
> be registered manually, so make it a module and make all drivers which
> have any sort of reference to DSA_TAG_PROTO_NONE select it.
> 
> Note that I don't know if ksz_get_tag_protocol() really needs this,
> or if it's just the logic which is poorly written. All switches seem to
> have their own tagging protocol, and DSA_TAG_PROTO_NONE is just a
> fallback that never gets used.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

