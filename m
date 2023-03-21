Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55BA6C3991
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCUSwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjCUSw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:52:28 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC3744A9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:52:26 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p34so5168066wms.3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679424745;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1W/swI8vNKaqL4yMLjBXJiDdesolsjKtD0jUAl/Fsiw=;
        b=Yty0l4iEMQDLDVScT+7cqStjZuhiaLjtqyJ4pNshY1Yl+7wFI7RprlZVipVMxpIYsJ
         kQhrijqSC99ajAPFn8Om/hFqBsneumYc8aWXttVatXtZ0jx5DEbH0/FqdkFjr6R3friP
         9yelnqqdkwGizmawv8sK+JqjG3a/i+/2HQ/BHVfzsWwwF/4hy+K1NeaCB3zbxnCmxsPi
         IRy6x31mVOP757FA4GW1oeloSWHC6eOc+WCCDR2MweAY/I6Z2UQgIvcqvnfpIswhJYZC
         LiU5H1X9fwgKMcZuwX5SwhR+F2NGfzp9HjM4njkbVdn3T4R2NthzA+eJEfkNCiVpgsmG
         axwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424745;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1W/swI8vNKaqL4yMLjBXJiDdesolsjKtD0jUAl/Fsiw=;
        b=UfVspJtDeFg62xVCxjB02reDfTIR1jk64T+WERsbBLVI4QW1bYkUQh8JAmDL8PVT+B
         TJRS4ofG3Q5JOrLjkl+IABTEQNjy+ZKGeK2XyyLgBy0I/GJG9Fj7iTGVpK6DF6nml+O0
         XoiEMzcEFbgfADYt+C+25kSt5cTW8c1+/cjwMe3JhzSo/oPVWLaxk0DrPcslUbvmX/gs
         OffsENfM8UFI/HdmTEQPLBrfXIds9f4KOr374Hqrmhkx5z/ydJdUd9PZzhUhSIjTlzW8
         OMm4N+E6y51/ueRTgeRHivMUrz673TBGocn0WGCZttCZ0AJCzmzhWLy5rZpuMXtkQ5Ka
         ROMA==
X-Gm-Message-State: AO0yUKXhnbFnu0xJtL9xcNsXuKa66OwWe2X5+0ub9lvBNDkHH/qLVQTU
        7nAH8H/VyO8moha3S5v0AYU=
X-Google-Smtp-Source: AK7set/tRiG3nKIem8+o61Chg5EBKBttmApT+wxKKZLJBAUPUtPEV4eaT+7jHGOOrCUtB0GBzrwnKQ==
X-Received: by 2002:a05:600c:218f:b0:3e9:f15b:935b with SMTP id e15-20020a05600c218f00b003e9f15b935bmr3003580wme.32.1679424745135;
        Tue, 21 Mar 2023 11:52:25 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id bi6-20020a05600c3d8600b003ede178dc52sm8207895wmb.40.2023.03.21.11.52.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 11:52:24 -0700 (PDT)
Subject: Re: [PATCH net] tools: ynl: add the Python requirements.txt file
To:     Jakub Kicinski <kuba@kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
References: <20230314160758.23719-1-michal.michalik@intel.com>
 <20230315214008.2536a1b4@kernel.org>
 <BN6PR11MB41772BEF5321C0ECEE4B0A2BE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
 <560bd227-e0a9-5c01-29d8-1b71dc42f155@gmail.com>
 <BN6PR11MB41770D6527882D26403EF628E3819@BN6PR11MB4177.namprd11.prod.outlook.com>
 <20230321105203.0dfc7a00@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <46b182e9-bff5-2e5d-e3d6-27eb466657ef@gmail.com>
Date:   Tue, 21 Mar 2023 18:52:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230321105203.0dfc7a00@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 21/03/2023 17:52, Jakub Kicinski wrote:
> Given the "system script" nature of the project (vs "full application")
> I don't find the requirements to be necessary right now.

I'd say it's good to document the dependencies, because otherwise
 getting it to run could be a PITA for the user; poking around I
 don't see a convenient readme that could have a note added like
 "This tool requires the PyYAML and jsonschema libraries".
And if you're going to add a document just for this then it *may
 as well* be in the machine-readable format that pip install can
 consume.

> But I don't know much about Python, so maybe Ed can make a call? :D

I'm not exactly an expert either :D
