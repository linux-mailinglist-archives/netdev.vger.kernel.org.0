Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60DA6306FA
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 01:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbiKSAVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 19:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237919AbiKSAVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 19:21:04 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16757BA697
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:36:57 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id cn2-20020a056830658200b0066c74617e3dso4019888otb.2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hK8gQKj2Jl7lgqDcBBKtTJvHs8EABYLYSyaTEIcYmn8=;
        b=gucqMw6zdttGL7YGH/8VFFsmO13p+jIbO4x5eL3c+cmf4/jxVzILWPhiYPujfkDohm
         0w9mpRCNZ8HSf2dvG4zeekZjFC0cjfx3WUsw40mocxDfIL7dCXgR6r5N5r7OgS6d1qy/
         yIfD3nIxVKHHKKlVFc0YpC3ywwSYeWWL6x63gjSYHBVRSs3BJ1ihStr0Z0ksgBlMTIXc
         1EtM/pqqaeEC8RzweIHsSwa50em+eHim1Hixm+xkr+1Wtpzxh5+Nm2z/llcSjaMItmIb
         z+hUPa8oeORr2ItK8aEhU6r6TfSd9eAPzmE4O8LiRv2uallTu99ZRAixUgCDrk4Rj0NX
         t/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hK8gQKj2Jl7lgqDcBBKtTJvHs8EABYLYSyaTEIcYmn8=;
        b=fItlTJ2D+8kH27R+S089vWP0PdPrRxFk68tymvqMZTqMFKKpE+a17QnT/Nw/1I7Zuu
         Fj58gKvRTYWngpsTJPnTfORYHk5ZPMsEFcCoyiCDlD0dPU4oOq4IrmqZkbvLmvcqziyF
         ULdihSfWy+v4E2VwLQ0wqHEZhckZrMUOi9ZkNemlxeHA/7xtlzrCXA81ZPN8gAMRIQQK
         XE6NxMLg7ivCMlylnKdxO08CxLzLsigrxOKqJT2heHnECNWpNOu+f/xH1Fek9JOWL09d
         Vnie5JBuwAiei7IzxrX+WXeTPq7S9Y+/siG/sX0Fm4L5N9bi3fNw9aZjgmn+Tfu7pybK
         plXQ==
X-Gm-Message-State: ANoB5pnutQnQyPdqmPkHMStldxvD/KTFnAMiNoBeJ7eB+Ak8wiq7V+UI
        pjlKrL7rC96HiAzHFLvTxfoTRedY5ROM7Q7nwq4=
X-Google-Smtp-Source: AA0mqf5MPQOnb33bdpqWOSrKtrxpaGaIUmAZtusUI9ZD1VLYYeccdeusP7kv/eDVu1yJ3GUn5v8pUmRgHBNfokbu+Bo=
X-Received: by 2002:a9d:7d8b:0:b0:66c:63ec:339c with SMTP id
 j11-20020a9d7d8b000000b0066c63ec339cmr4956776otn.332.1668814586407; Fri, 18
 Nov 2022 15:36:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:7f06:0:0:0:0:0 with HTTP; Fri, 18 Nov 2022 15:36:26
 -0800 (PST)
Reply-To: sgtkaylla202@gmail.com
From:   Kayla Manthey <kontajean@gmail.com>
Date:   Fri, 18 Nov 2022 23:36:26 +0000
Message-ID: <CAGJkU199dd6rSeEQzJY4DP3DmVDGuEYE2s_WJmG9s4baR8bHUQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo lieverd, alsjeblieft, heb je mijn vorige bericht ontvangen, bedankt.
