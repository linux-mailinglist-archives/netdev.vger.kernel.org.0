Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20E363827A
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 03:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKYCjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 21:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKYCju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 21:39:50 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6658B2613B
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 18:39:49 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id bp15so4847834lfb.13
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 18:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UoolYwyUwc4JS8yzwWBmwVIncGeaYxQWRWN/BDplcso=;
        b=ZUK5pCBuIe2gkJIILmOgrzA+eu3qtXqQdHoSMHa0N4xT3H0ygiR3+cg8az/eeLWzov
         GgYh4PdrS9SagzdQF8zI4SIs2u1anredALlFARZjYy0JyDpIyQWHIwVVL3k+y7+8LLcw
         F6U+UcrydAQet+lN/EItO6MkwfHGSKkHEpEaWt/lSxgmts0LYEeTmhNRe3dlS4j5lLqu
         na1ClljdEZjUDjci0rAndaauhNI5OQKJhlSvTcRWRxso/1cH+4KgigGTuCIKzLMxnpOr
         wnnkPv04tC+olp+9zZRys+7wgb5BfzO+vde9m77yEaNRDDrFgx8glC8QoJcCROdjOjT3
         Zl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UoolYwyUwc4JS8yzwWBmwVIncGeaYxQWRWN/BDplcso=;
        b=lSCrKUZqfWgDwat79ejakicuMifGTRT3ugIUkSH6ryhIwC49eeHQITWpIxFgBfDVpm
         wN+2rJPiiPmCql8lTjJRfnQnt3a76nBpsXwduqO6WdLnAqgklaNBYu5oxGBMI1MBniQH
         BX5Mz+5sedRzujytu+q01HeyF5PzsXKIuvG2bYVMVjRx1bgjw2jb4Ab7LO+1cn8KVlhj
         +kGgqCLutKHvrXCY2Q51N0bHjO+khBzajWeVXTVAjZsNMkXlMIbFtvbhFdXn+uhIiN8V
         5FTi+nGfWf6K1iw2pCGiuwOWHS3boh5JZAfpXgr9e/Hat955onod0c0KbGT7Kk01GwCj
         pD1Q==
X-Gm-Message-State: ANoB5pnSpckQs+MYkCtsnJYCrdXlCo7GtO5AWpDPD1b/2Yw3c0nKf8no
        HWbWxMT9uYhJh2jRTfWZQFJUTTepbbLtH5HQKZo=
X-Google-Smtp-Source: AA0mqf4AZCMdNraIDwr2KXaSLuac49q5kZ63vZ35fj/gDeY9f8juo3Zw9pxXHSlrAAHxIvbwX1xU/LedLirN5PSR8vI=
X-Received: by 2002:ac2:5dd9:0:b0:4b4:e433:477b with SMTP id
 x25-20020ac25dd9000000b004b4e433477bmr4405412lfq.541.1669343987651; Thu, 24
 Nov 2022 18:39:47 -0800 (PST)
MIME-Version: 1.0
Sender: drbatiistsbrsxton1978@gmail.com
Received: by 2002:ab3:7556:0:b0:201:4770:8f74 with HTTP; Thu, 24 Nov 2022
 18:39:47 -0800 (PST)
From:   "Mrs. Rabi Affason Marcus" <affasonrabi@gmail.com>
Date:   Thu, 24 Nov 2022 18:39:47 -0800
X-Google-Sender-Auth: ez_xmp2rGR2vGpOxeyoZ14LW-f0
Message-ID: <CAB6JQiXctOCncjVcVJHRvzFeBr68v=7CT09nsFqvD8TaGARPyA@mail.gmail.com>
Subject: PLEASE RESPONDE FOR MORE INTRODUCTION.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi beloved good evening to you, Please there is something very
important i will like to discuss with you that is very important and
urgent.

Mrs. Rabi Affason Marcus.
