Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813B34D3FF0
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbiCJDzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbiCJDze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:55:34 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996BCE5419
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 19:54:33 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id b188so4725120oia.13
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 19:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=re08GUZ27p5QzyqsqUAYvT03aNARI14+k37iXae59+g=;
        b=NIvr+RQ6ry3IVbKrWYOvmm9Q0ck49+0Bcbf8EIqRTFsRKFrssWimxEHzbKwvWV1C3+
         UG3AkzzQr6Cxx5BkW6Oab4QE+BX6FxH1sTURAJVWIX+LyPyZ9POMSI2zBuXd5PZlFj8A
         smg3UUSYOq9ri9cROnqbO9yLcB6s6nG8ltkHb+hpuRTdHc+B1Lf7i95BYn8FUqqPA/Jf
         +Audsi4yIVVoGrXx32wy7EZ+zoMCgNTWwLdGsDKEowtqxVuBUPkQJOfM+tvEG4o4PT+P
         1lGVreIBWzrNZU/srllJevvUHy1Uc/PqGWWgDglofahk3ChnUqbVxF5425UMcPiAWid3
         kMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=re08GUZ27p5QzyqsqUAYvT03aNARI14+k37iXae59+g=;
        b=G/owD5BA08sV5NqPDPPLSmKCLozUsTnjwn7Lph7MQt9NlG8iDC9/zweBQIcheW4d/Q
         oTbNTnRZJ8hA5qH1eeLHwh/fwxs61z3bsdpo6fbhSOzOoPVM33jpK1wA/YKg8WTBiFPs
         FFDfeID6tuoYoUQt86tf4AG8uJcAQAh9FhaAdfNFUBg8JM1GJcRuOZ4D9pJv34WqRxaX
         kijq+AlKDAS0/ijx5tffMyF98prpzgfehALaceU6g/iK0W+jeVroGvGGZlN9ZOPTaQXO
         YBuibwvLcvgHL07C64xe+1jNcN45zbY4N7mYblb+xL8wL9vGZyUhy2tQe3mSTk7WFDMv
         pwvw==
X-Gm-Message-State: AOAM5310+TKRttIeDqqKfC3vQDv6+BzMvDkggsYqpjE42zWDD4IfL88z
        Y0DHoHh/ib4w/K49TB8cbNpP+8xd245+qA==
X-Google-Smtp-Source: ABdhPJzBzK8niKzH9yxHo0x0EsZYHCvtgnfML9VBFVZy5H/1iGBwchyxMxHphs3IC70KQZWJqsfFTA==
X-Received: by 2002:aca:bb44:0:b0:2d9:c2a7:9d8e with SMTP id l65-20020acabb44000000b002d9c2a79d8emr1945599oif.278.1646884472973;
        Wed, 09 Mar 2022 19:54:32 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id u12-20020a056808114c00b002d72b6e5676sm2027611oiu.29.2022.03.09.19.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:54:32 -0800 (PST)
Message-ID: <4c4f21f3-75b5-5099-7ee8-28e3c4d6b465@gmail.com>
Date:   Wed, 9 Mar 2022 20:54:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: vrf and multicast problem
Content-Language: en-US
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <1e7b1aec-401d-9e70-564a-4ce96e11e1be@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <1e7b1aec-401d-9e70-564a-4ce96e11e1be@candelatech.com>
Content-Type: text/plain; charset=UTF-8
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

On 3/9/22 3:31 PM, Ben Greear wrote:
> [resend, sorry...sent to wrong mailing list the first time]
> 
> Hello,
> 
> We recently found a somewhat weird problem, and before I go digging into
> the kernel source, I wanted to see if someone had an answer already...
> 
> I am binding (SO_BINDTODEVICE) a socket to an Ethernet port that is in a
> VRF with a second
> interface.  When I try to send mcast traffic out that eth port, nothing is
> seen on the wire.
> 
> But, if I set up a similar situation with a single network port in
> a vrf and send multicast, then it does appear to work as I expected.
> 
> I am not actually trying to do any mcast routing here, I simply want to
> send
> out mcast frames from a port that resides inside a vrf.
> 
> Any idea what might be the issue?
> 

multicast with VRF works. I am not aware of any known issues
