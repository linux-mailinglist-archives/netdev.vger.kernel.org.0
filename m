Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878344E74E5
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359333AbiCYOPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359331AbiCYOPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:15:33 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEA97EA3B
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:13:59 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id e4so8286324oif.2
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Fql13jBhxxuqBIHz2oTkBhgv87Ze1IOszeli/lbMMYg=;
        b=A1aXJRnOqm64RvCOQHCdT70sPmcjvaGPfobLye0sxGPuvbIxgDyVzZSLO0pQT6LaQG
         RVqrZ0ZqZgku1pvixpS0s12glbE2dbUfQtb1ID3bzhA4GHanvWq6lMv0LvP9U61xztO3
         1qHVpOWznAFVrE4kEIAc//GfVbgdJr6RptkiSTGyKf8aHWc69XPliqquIcwo22qJ/jli
         AaQff7UDppKnLS9QrbTUuB4c9jFZi9kJXq5h2UffdFJkFEiSzAj5hBi22I5zki3Br2GS
         Jzi2IuRyIPXFhjWImLuKHUYCgAIcrVhEJSjepxoXqLghQvEXmtk+RhAgZ+16bTd7xQbJ
         4uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Fql13jBhxxuqBIHz2oTkBhgv87Ze1IOszeli/lbMMYg=;
        b=efC30xt5YDpDBIO5g1xj0nBXAOLsgAJyvgMGNye46UDZHTO6EhpDDfNeGJBT/ksf5j
         HIoHTnMOdVmmxOdntNo6b/XD9p6Au0eJJM/HC001ZmFXXkBg/QueMwODjssi4oAesBZ3
         hIGQTeFP0pHab2E4OLXBJuDVGUukGzGMHhwynabV6SACxQp0r1Sg73qSYkevMUDLKedR
         7LD2JI35fxiqouXXbIL12S9ERw7U0VvGtPKXVjJ8tereehehloJnLOyeKB6CHV+MK8VQ
         IIGhQtUHrt+elUd2NkwjQdbuNB2SNaeqWW3/yVPcgDK4EhfCrP3ZJEggiNls2CSZiDoK
         6PtA==
X-Gm-Message-State: AOAM531U+eEro5xL/EWUFgyUabp14e9tAQkao8H2DyNw8RFbadkVc28u
        XNpjnBcOsp/PVf35qB4qocEq6S4VHyo=
X-Google-Smtp-Source: ABdhPJzV0Z9lo3gQWJZYSmJzo4+myDYCt/9cMBruEC0l+fxIVCKf6mdZ09UCp7WD3PbbKt003aycQg==
X-Received: by 2002:a05:6808:aaf:b0:2ef:b47:2948 with SMTP id r15-20020a0568080aaf00b002ef0b472948mr5379355oij.31.1648217638286;
        Fri, 25 Mar 2022 07:13:58 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id 2-20020a056870124200b000dd9ac0d61esm2662654oao.24.2022.03.25.07.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 07:13:57 -0700 (PDT)
Message-ID: <7b5eb495-a3fe-843f-9020-0268fb681c72@gmail.com>
Date:   Fri, 25 Mar 2022 08:13:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: Matching unbound sockets for VRF
Content-Language: en-US
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        rshearma@vyatta.att-mail.com, mmanning@vyatta.att-mail.com
References: <20220324171930.GA21272@EXT-6P2T573.localdomain>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220324171930.GA21272@EXT-6P2T573.localdomain>
Content-Type: text/plain; charset=UTF-8
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

On 3/24/22 11:19 AM, Stephen Suryaputra wrote:
> Hello,
> 
> After upgrading to a kernel version that has commit 3c82a21f4320c ("net:
> allow binding socket in a VRF when there's an unbound socket") several
> of our applications don't work anymore. We are relying on the previous
> behavior, i.e. when packets arrive on an l3mdev enslaved device, the
> unbound sockets are matched.
> 
> I understand the use case for the commit but given that the previous
> behavior has been there for quite some time since the VRF introduction,
> should there be a configurable option to get the previous behavior? The
> option could be having the default be the behavior achieved by the
> commit.
> 

I thought the behavior was controlled by the l3mdev sysctl knobs.
