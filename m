Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C110599E0C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349636AbiHSPVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349114AbiHSPVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:21:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CD6FAC62;
        Fri, 19 Aug 2022 08:20:59 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id y13so9373924ejp.13;
        Fri, 19 Aug 2022 08:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=+HU2PDxidvc5+FaOZWTX0HoitIaVmLInXIp8kYbLioA=;
        b=B1PNv3iosZDyUltNx04zouIxVSmCOGdwLmk5mQUCsPniElK0Dg9wnqTCCUfmLNpcvp
         EWqLe+7tND89mop568bYusMgNt/Y9oOgaduKrlBNCkbzWNYawNAnfeIe+pqxusWLv18v
         u/NX0xSZgT7Bl2dHTAa2Z39FJzXgC7+OzuRuAKvoh1JfiU637uWPy2OI/d9ETi7Fgk4e
         kfGy3wY4Jjt4QEz5I/RTHdDmMMmpq8AL28L7tsJoS3knAZjzh0Z4s2DqEo05BLOPK90h
         CCoJIZVP3om302tsZ1eSulGeSPYgN6fBGAXlI/x16dc0vdgN496CK1ErrFZhsBoH2Nq4
         i3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=+HU2PDxidvc5+FaOZWTX0HoitIaVmLInXIp8kYbLioA=;
        b=ZbqmVjmUiIXZxb03mnIrjCfpIm5BHeTGYMXj6yZaj/4eGh+61kpfGg8/qGKbOdSpGf
         +9VHWnN4Mk2x0Yg7KjStR3/eGPANRUvvtHRAM682NSOuLoXAZw5BXYaUJx8Ym7QI7EHF
         e9LyX33vo9sgSl+Y92vov0oxqxgesFBDPy3R5wx+wF4Vww6bx0/TyL6ypv7/Mp6D9Cp+
         aZD5ZsTScrIsThfvwoJNKCRM01yZmNurOb+0Q0b8cJKZufhnWn4Ki1IgN2RaqicM/ZxV
         wu1k2sa4Phv8hOe+uWnShTyKIKPFVCQ+UvHplPf14VU3AS7XS9VaHHJjgkA0mfwUng0V
         vJBA==
X-Gm-Message-State: ACgBeo1iaJSeuDAif0w9R4A70RPFhSx0NvoSRknUrTO8Io1ch6w/rWdB
        X4A8/0FTrYgmFrAUQsKVrZw=
X-Google-Smtp-Source: AA6agR6Bn4ZLfiJKQune26mbp6EwBo9wx/NYlSD2oKPpuEXHvy3PuRqEtlpKZlu6SLbRJZw9zHJJag==
X-Received: by 2002:a17:907:75c2:b0:73d:5842:9d68 with SMTP id jl2-20020a17090775c200b0073d58429d68mr1191787ejc.11.1660922457981;
        Fri, 19 Aug 2022 08:20:57 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id m27-20020a170906161b00b00730560156b0sm2449091ejd.50.2022.08.19.08.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 08:20:57 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Marcin Szycik <marcin.szycik@linux.intel.com>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, simon.horman@corigine.com,
        alexander.duyck@gmail.com, rdunlap@infradead.org
References: <20220815142251.8909-1-ecree@xilinx.com>
 <2c659f31-f2ac-b6a9-c509-5402f61afc78@linux.intel.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <2578c4c4-03c0-1618-e53c-e271ca9c50dd@gmail.com>
Date:   Fri, 19 Aug 2022 16:20:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2c659f31-f2ac-b6a9-c509-5402f61afc78@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2022 10:56, Marcin Szycik wrote:
> On 15-Aug-22 16:22, ecree@xilinx.com wrote:
> 
>> Just as each port of a Linux-controlled
>> +switch has a separate netdev, so each virtual function has one.  When the system
> 
> Maybe I'm misunderstanding something, but this sentence seems a bit confusing. Maybe:
> "Just as each port of a Linux-controlled switch has a separate netdev, each virtual
> function has one."?

Kuba wrote this paragraph and tbh it makes sense to me.
But how about "Just as each port of a Linux-controlled switch has a
 separate netdev, so does each virtual function."?

>> +As a simple example, if ``eth0`` is the master PF's netdevice and ``eth1`` is a
>> +VF representor, the following rules::
>> +
>> +    tc filter add dev eth1 parent ffff: protocol ipv4 flower \
>> +        action mirred egress redirect dev eth0
>> +    tc filter add dev eth0 parent ffff: protocol ipv4 flower \
>> +        action mirred egress mirror dev eth1
> 
> Perhaps eth0/eth1 names could be replaced with more meaningful names, as it's easy
> to confuse them now. How about examples from above (e.g. PF -> eth4, PR -> eth4pf1vf2rep)?
> Or just $PF_NETDEV, $PR_NETDEV.

Yeah, I can replace them with $VARIABLES.

-ed
