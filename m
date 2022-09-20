Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361AF5BE74A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiITNkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiITNkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:40:22 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA73A1B5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:40:21 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id k10so3855841lfm.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=21pk5H4jYUlx5JvPYhaCjIYqI3pxgaX4JVPWxEDvarQ=;
        b=NzWHouXhdDR2Ds7ws68ZieobcerZ3gID6uO0G8Tx9Ifhcm5pLRVx6I2PZNBxYDJ9LP
         logXMRCLsGGQQhcaBNlLFLyXFqvleqIibZko+T4x8ipwXpmG9/meUFTgCTEqbieQFZRC
         F/qWhoDhbSMdxl78Ge8ga1puTPJ15bCXijni7WR00BwMdJerT9cg/rR064WlxeTXaVbR
         j48GaR2fXYkJYTOjWTKNfh0W64jpJ2w7VIjZUYazOhvHYN+ito6mQa3zS97Wa+s6+F7f
         opam/NhN6dXEtxeE6KZ88uLJyAcRdoGVVuwVwTg6+PWU/yWG9+fDV+izGH2Ba586SI8j
         X/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=21pk5H4jYUlx5JvPYhaCjIYqI3pxgaX4JVPWxEDvarQ=;
        b=pMSNX6ePEJSILn/6FvGMHvxdXFhJxfsNPszhj2wArz3ytOMd26gQ2bOguT5XDvmZ1Q
         llXc5FI9YI3uqFVeeCuCtH8UK32FbdtzicF316LWQmaRG+8x951jycJJzOon+MVaCIdk
         ha4f4g/wBRMfzxJKIgtDjQtNYUFlX2aL2N/ZmvvqPpPs7zZqoydoSP4GgPeZWMaeWBZm
         PfWsh/AipnYP61KdwCOKqlKFBddOP0F5dtyDM+Ob0xe2iZMmrb6guBRNGSaRr7K+o5eg
         t0M/eOTt77rHfbPLh73RpsKm70U/oC1wlOS1LnpiMJ5kd0bhDFuN28LavccdQJSik+gx
         T8fw==
X-Gm-Message-State: ACrzQf2Gfhf0pcj4fTHuruU50lc1Uuk0RrqyEfxsVmM41rL4UV1pJ2mD
        UkpxtMMM7WGVspAsiL/pGU8=
X-Google-Smtp-Source: AMsMyM6+HNTKHrWAj2w+IiQWtXqQohDVGMH996bd49kotXuTD1QZXdapqnsF810K/mkefOnBN5DxCA==
X-Received: by 2002:a05:6512:3d28:b0:49f:4b31:909b with SMTP id d40-20020a0565123d2800b0049f4b31909bmr7779599lfv.669.1663681219273;
        Tue, 20 Sep 2022 06:40:19 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id d1-20020a193841000000b0049f54a976e3sm326341lfj.58.2022.09.20.06.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 06:40:18 -0700 (PDT)
Message-ID: <78c06b1a-7bf6-08e9-8413-efbe8412b19d@gmail.com>
Date:   Tue, 20 Sep 2022 15:40:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220920131053.24kwiy4hxdovlkxo@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-20 15:10, Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 02:26:22PM +0200, Mattias Forsblad wrote:
>> This whole shebang was a suggestion from Andrew. I had a solution with
>> mv88e6xxx_rmu_available in mv88e6xxx_get_ethtool_stats which he wasn't fond of.
>> The mv88e6xxx_bus_ops is declared const and how am I to change the get_rmon
>> member? I'm not really sure on how to solve this in a better way?
>> Suggestions any? Maybe I've misunderstood his suggestion.
> 
> Can you point me to the beginning of that exact suggestion? I've removed
> everything older than v10 from my inbox, since the flow of patches was
> preventing me from seeing other emails.

https://lore.kernel.org/netdev/Yxkc6Zav7XoKRLBt@lunn.ch/

/Mattias

