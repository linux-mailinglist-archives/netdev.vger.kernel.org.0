Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619BB615C22
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 07:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiKBGSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 02:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiKBGSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 02:18:04 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD15225C64;
        Tue,  1 Nov 2022 23:18:03 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id cl5so11362498wrb.9;
        Tue, 01 Nov 2022 23:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TyoiXD+lZAYyIq5A3unxJbUvSr0umu7gv7mLSuqlSJ4=;
        b=I/Zy5t0JCiZ7ddN+RFSrntl9sEe/07pscujEFvTKoQS5ZFv6NA456HRmg0+JR/INL0
         FU1VXyFUa6ngvXRo+jE6p49cr0KSvqWOKWyhYGhhQyiLGBIjMlDyk1iOKEwHeCpqBagy
         RuwJYCHHjU90z3O/6B2G4j5MnDLvMcqRqQWjrRrR3b635SBD4AYtnXFeok7Fy+M7yeK7
         pQNFJQUKdpLCs/sZSGlpMa768rhRFlGTKSEPzEaATD0tX8r7m0hVKrxogzILEAXBNzt1
         /BhuNGPuphqSZvj+pZRrc0z3hMHxFtY1epsy3K+df9O/j+HBngCfzZMBXk+b+rLHmrbA
         Kkiw==
X-Gm-Message-State: ACrzQf2tZTi4rMHWSiEXKeaoNcNk5l08D0yy1RkvowyOw0pQxjX6YPHA
        RRBP1IE0yslf/b8vj/bN23k=
X-Google-Smtp-Source: AMsMyM6NJ/87OZvYBlrVbXokU9DQLIfp/f10lKRDGr1BCob0gnkUi2pHO6BeN0qKMkHIYSEF8xWWvw==
X-Received: by 2002:a05:6000:3c3:b0:236:b2ce:593e with SMTP id b3-20020a05600003c300b00236b2ce593emr12638679wrg.580.1667369882322;
        Tue, 01 Nov 2022 23:18:02 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id 7-20020a056000154700b00236644228besm12830609wry.40.2022.11.01.23.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 23:18:01 -0700 (PDT)
Message-ID: <eeac01aa-5c3d-da4f-3acb-0698de23b2b4@kernel.org>
Date:   Wed, 2 Nov 2022 07:18:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] ath11k (gcc13): synchronize
 ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20221031114341.10377-1-jirislaby@kernel.org>
 <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
 <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org> <87bkprgj0b.fsf@kernel.org>
 <503a3b36-2256-a9ce-cffe-5c0ed51f6f62@infradead.org>
 <87tu3ifv8z.fsf@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <87tu3ifv8z.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01. 11. 22, 18:19, Kalle Valo wrote:
> I did assume it will take at least a year or two before people get used
> to the new prefix, but my patchwork script has a check for this and it's
> trivial to fix the subject before I commit the patch. So hopefully the
> switch goes smoothly.

I think so. It will take some turnarounds for you before this starts 
appearing in git log output for every wireless driver. Then, people will 
start picking the prefix up from there ;).

thanks,
-- 
js
suse labs

