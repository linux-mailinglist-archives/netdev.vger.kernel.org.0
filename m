Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2724661476
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjAHKI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjAHKI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:08:57 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27068D120
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 02:08:56 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4c7d35b37e2so21661847b3.2
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 02:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FocuR5aXn3z28LzYD0rCmA/t4By4lcIW0G986gs+i74=;
        b=jAE2O+9zxU5fSWPNlrWFBHx3sIS9fk3eC/u4uLmjUTpzix2UrNInJcBiKlIb2L59/t
         mhKWaadkxSonkjazNMlwg7y3I7wzJk/QE2olotT9Wnt7v8EkL2OJ0yX69HArXv7fT2T9
         XSuKomfDB2R7cSbitt7J32krXAgIjvCwiqB75uyBjSb8mRHvsPGbrUYFu6UrzduGwmU4
         g3cqTY3vQG/ttIKDwkGLExGjUgZ30qnhbETJR2b7Z+1jSSOUwTGmH3qRcfSP/RVaAa5b
         r1STCgf37FTOLovZFMsKv2J3t1VYW1IDvIerWBjQ3ukJYGQROfpli3uzxx+p61TPUkuK
         YiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FocuR5aXn3z28LzYD0rCmA/t4By4lcIW0G986gs+i74=;
        b=DWOLmcuVpO29/bJZE7MRozv0R4cAlV+11wTYA/iYU4ecFeMOTrP+rs1QWI65XOjG5L
         V8Vxbg/5+7zppVSwHoXCd4hqYSI4VKYqZBRFL827Z3nNCAmOYBGppRjmL9oq/GqZyfTB
         BmF8g9wNRQ+etJeGlc2lcyp3fYSJDUP6EYrQok1y5dcS//0o50S0OLGS2MMrQolniEqi
         +blbodp0ahSDtRtE31VoJsbKnnjAQTNl8YPDf1+BuqMQ8ame/5rAUmX+OkaSMiLOgxwn
         45tBF2wAfLP4RmmDCUtZ0Gz8UAIjwPgDW07IR9uorR53+KfE4Sp5xu9P5xiro9XYVffz
         qeMA==
X-Gm-Message-State: AFqh2krJ5IpFa9FnoB6aVfUSzsLdn+HIKgqXDVxG30ghUGewTvHUgrhs
        8qyY8NF9N3Z+5A8+TM3sWetGinQwdNeL9aHlZyo=
X-Google-Smtp-Source: AMrXdXuHJ5h5627pUY3puxfXumgmRiIwfKP/XPxwMoJMhvhkFnLHrFsNL9+qm5K2Sw6y1nzmTUQwtBdE2LLTlsc9/do=
X-Received: by 2002:a05:690c:854:b0:496:14db:e4b4 with SMTP id
 bz20-20020a05690c085400b0049614dbe4b4mr4350392ywb.377.1673172535368; Sun, 08
 Jan 2023 02:08:55 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:53c4:b0:320:5e79:1f2b with HTTP; Sun, 8 Jan 2023
 02:08:54 -0800 (PST)
Reply-To: khalil588577@gmail.com
From:   Abdul Latif <anthoniushermanus1966@gmail.com>
Date:   Sun, 8 Jan 2023 10:08:54 +0000
Message-ID: <CACiMciYmhfo+pEU9DUFt4Lwk3tJohtdsgmLS3OcNJUG0O4GygA@mail.gmail.com>
Subject: GET BACK TO ME
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1130 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [anthoniushermanus1966[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [anthoniushermanus1966[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [khalil588577[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mr.Abdul Latif i have something to discuss with you
