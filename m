Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AF95811C5
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238700AbiGZLSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiGZLSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:18:06 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E5631232
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:18:05 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id b34so10937088ljr.7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=geCVNY+flwt789c9RdieCurETz/pfYIPVuJSXzc2+N4=;
        b=JgLJoIHl+NK9NYyAoWjepj6PT+eWxDBr9jpfQarPOCel6KomwPBTz6m4W25da1hd0E
         fmLKUnYhiwdRyrycGFjN1K8uOwRGA1ekXuWIALaWbJNEqDoKu83Glc+S5sgAbe8ux8GE
         tYrhKRKs4SZ17ct+4IuUutjBjL7+Ae9Wzq0nmXfoi3ifZdiZLsmJJSSEphNlhukaWq+s
         Dyt79g6HpKMWs4NBdyn4whBsIMD1XvHBcAhfIYfTribo+JLCRFIgxhoysoles8BSQj9v
         6EdN8ymB4dwVHPiX6N4KHgBPE6uHEvEYh8WLUSj4l0CMj4ofosb2XdE3soHC2x48eK8a
         +bJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=geCVNY+flwt789c9RdieCurETz/pfYIPVuJSXzc2+N4=;
        b=fs3bagwhH1xT2yL+kYnFZivZi8h/7qTHzU6RVc6kQis3AFsvOtOmE66Nr8cR7w4Hac
         BYD3IC12M+zbirL+xhvjz5fBNpaQkZ5B3Ovj3kzJ2phfCq6ya8XU5+F2JaTiht7Qm2uo
         uFkX0seigJS9ZLQB00h08peTHWK0ZAp8o2PC+zE2LyWjHlmDcMUTGQr3nvpxkEmJoS+8
         fIWzqacM+BtIIwgQM6yI73uHVF3CNfxllwa7Godr1z2Oh0jGUZWnBna/4+Zz2AzEFikd
         21IzX3ekv+vTYZ9xIfXGyx0FHqc6+4Ld0FAUMJ6pXiLkYFS6H7bQO+CfsOnSHCwDpt5f
         NwiQ==
X-Gm-Message-State: AJIora9/KJgNfWLyWw9gFJhFhF7gRlk4YGmBdwa91C/uGOlXn+4axsQA
        XafhNBtyLpCgapOrNM2sQfRYx8YbDZTktfOJjDQ=
X-Google-Smtp-Source: AGRyM1vz4FhlTogYq8w7C/qsyADg0JDA1YibcqR3FsuYNojSiMWvg0qTL1Y3+AFZtdmgdQtqqRvx6MTUDbSEkX+Cnvc=
X-Received: by 2002:a2e:944a:0:b0:24f:10bd:b7e8 with SMTP id
 o10-20020a2e944a000000b0024f10bdb7e8mr6210583ljh.238.1658834283283; Tue, 26
 Jul 2022 04:18:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:2a1:0:b0:1d7:b824:937f with HTTP; Tue, 26 Jul 2022
 04:18:02 -0700 (PDT)
Reply-To: loebarryson@consultant.com
From:   shahab Ayub <drusmanhassan19@gmail.com>
Date:   Tue, 26 Jul 2022 12:18:02 +0100
Message-ID: <CAMdE0PNqP3T1xsOdKnST0JJ=w+FqPZVZ541q0wq5M=yXMFcFQw@mail.gmail.com>
Subject: Business Proposal From Dubai UAE
To:     shahedhossen2010 <shahedhossen2010@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

I am the Chief Compliance Officer of the United Arab Bank of Dubai. I
invite you to a good business deal. I want us to work together as a
partner and benefit from this good business. I will explain in detail in
my next letter if you are interested in doing business with me.
Have a nice day

I look forward to your prompt reply.

   Shahab Ayub
 shahabayub@consultant.com

Shahab Ayub
Chief Compliance Officer
https://www.uab.ae/en/Discover-Us/Senior-management
Website:
www.uab.ae
Address:
Sh Abdulla Bin Salem Al Qasimi Al Qasimia St , P.O Box 25022 Sharjah
United Arab Emirates ( UAE )
