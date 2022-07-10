Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BC056CD9E
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 09:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiGJHY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 03:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJHY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 03:24:26 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7CB167D2
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 00:24:25 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id k2so2379952vsc.5
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 00:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=elmINmPLqqlVYdbwmb+NAxtQUKMg9HH/1hx0PLh8l0WQOFMv59BhMPxnWk33ER7ePT
         4KCgIx41FGP/r+uzIMcv70SXHlKN1NP/QV+FHqYlU/j2VMw5HAR2oj8Tg2j4/c4C9wzo
         3kBKB7N2nr6V7MasguR2BY4Kaw22i7zd3t40jV6gCNFJJpes/0KKVUVy3+SI2wSbJWhl
         roRedJU4gjgSleVq9SQw4MMWA5jZfBMN0usTNjzCsC8pmKXFAIQduk8YugQMcOh9F0Hi
         RyXmQf5fiLzt9y1FVnxW5+nVQsmdfjiImxZObxWYqeMQxkJL51wrf/pJvNjcLiEiaha6
         fhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=zmWDseaqAbgVcHPi+A9nOYBJVCEo74AKU7WzO1SDqR/9J9LXtti1RsnMpTbna+z0DT
         Xa1m22jWJQ5+t2d/fuT+BEGRFg1i9Y8FDpnF/euwIGcaa+yAsG1jRTX2TT8z/U5lIzx0
         GydtN1y1bEniy3f/Z1S9y6Ze8zjb3en5TUknbDSZvalidH9lIA9dy2EjyxftMKfbouf1
         DCEys1FSv8zfDm+eZ1oT+6Q5W20ALSA7ynDZgGMi7JIx8N61Cn14SlS5QxZjNB2kSY/h
         cYLcu7n05bN0N9RowP0KtKc4kR33GlEYCm/RimBhNiOqqcgfOk7+tEgsJfTDBj6ur+B2
         O1FQ==
X-Gm-Message-State: AJIora8mjOnwIljrBXE8cAcMO2jPn1VgBg2Czp9mHivoPj6Y0UFlEmJe
        ndOHKL6vn6NKUH//Ij3DM9mHlszvbtMOJr0ZYRg=
X-Google-Smtp-Source: AGRyM1uS1qEB6QW10G4T9uatNCm6uFMEl0lCp5qYNxsp1x+JQMOOLBbftDvpwNz2fDFI6aRAPBgTIV0BWhewqV6LRN8=
X-Received: by 2002:a67:f987:0:b0:357:4631:d79d with SMTP id
 b7-20020a67f987000000b003574631d79dmr2356450vsq.1.1657437863681; Sun, 10 Jul
 2022 00:24:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:209a:0:0:0:0:0 with HTTP; Sun, 10 Jul 2022 00:24:22
 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <tracydr873@gmail.com>
Date:   Sun, 10 Jul 2022 00:24:22 -0700
Message-ID: <CAARq6VaG-5P-oP_6dLv5b97u3jg=jPXQhAcJKcAAuiOjsHgoAw@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5008]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tracydr873[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [tracydr873[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
