Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D9F663FF3
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbjAJMJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjAJMJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:09:12 -0500
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA46B3FC85
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:06:19 -0800 (PST)
Received: by mail-ua1-x942.google.com with SMTP id t8so2790030uaj.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HyQfDA5JQKapTqk95xlLXJ5aD/AVTOh+bnm0DaoViy4=;
        b=WWyKBynUI+n0bhArL5PEhvrCYslbNDwAkxs22w6O7T7L6nNsDdVzOLhH77PAFEQvuH
         VBezsuFWdVPxtjHl2F9TDC0e/4amE79S7FPGErK/PuyZyVfEnLarshdSEVvwddSFCJ4Q
         +cNnpI5xm7NxCMXSLQ/am0zADkOQtBvcA7uvtiWv4zLOPTlAjo6hSs26RShKLP1IL7cV
         IH+UJbXgv7xOLk1CNMjQWahxdhqPcF7tOj2Nqoz9v4IUmxIqfKEITKRQwiMUvoIVh/Ft
         VwDyREU+JDkaYfj6jXd/ky55mpAtdmwJoy9G7oy/F7OL/GJHzhrcwgELusg4Nj0T4iqC
         LtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HyQfDA5JQKapTqk95xlLXJ5aD/AVTOh+bnm0DaoViy4=;
        b=6LUxtq0teBLt1N/85YRD7Osp7ootuz5FRuKhTBV1oDXhj5BM4K/zet91207RpR8SQw
         pKceDMq4wnO9LypjpGnGvoUTRmeDrWKrw0izOCw3nIn4BGFtWDtf4E/09BZayPBxUakl
         DKQed6Am2fVtcq4W90Qy8cLkau0r6EMtU0RZavIxRv4IwIa3268AaILg5RVUEePs+Eyn
         hHpvCUnqLhSGCKkYQOGIRAgDNf23kXRRnI/cBH3SFO0/DrV7NtZgVdqky+s1Lo4RVYGg
         q6SJ4Y2CiHxYZdVrSIixLcVX7vCX+36BFsLP6llMMxiguBEdXByZ7ae6i28j3U+qQ3FS
         X46Q==
X-Gm-Message-State: AFqh2kpM26kkiK6PEDYt65BtMKD1c3Q1qPwU5wCwx01nURw5GssUEFTj
        e1/3sZUzmXYybT+CvSDZcGfPzBY8dInxF1+3zqM=
X-Google-Smtp-Source: AMrXdXvCRSo6L5zpra41weUM0koUTHxEt0IXMlQ51CSSKeroV1fNbHU/J8ezJr6Ch9fdEe5sTDBtaE3l6XiJA/A3D7w=
X-Received: by 2002:ab0:279a:0:b0:415:65dc:4733 with SMTP id
 t26-20020ab0279a000000b0041565dc4733mr8381974uap.87.1673352378108; Tue, 10
 Jan 2023 04:06:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:2054:0:b0:3b9:95f2:e1c1 with HTTP; Tue, 10 Jan 2023
 04:06:17 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <tetw3333@gmail.com>
Date:   Tue, 10 Jan 2023 04:06:17 -0800
Message-ID: <CAFDfDBJHwDHo6+6nbSBCC7TOqFJ+KOEfcrpoXfhxoOFA7er9VQ@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:942 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [tetw3333[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tetw3333[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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
How are you doing.My name is DR. AVA SMITH from United States.
I am a French and American national (dual) living in the U.S and
sometimes in the U.K for the Purpose of Work.
I hope you consider my friend request and consider me worthy to be your friend.
I will share some of my pics and more details about my self when i get
your response
With love
Dr. Ava
