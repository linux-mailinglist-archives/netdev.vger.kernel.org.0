Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DDF5A4691
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiH2J5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiH2J5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:57:02 -0400
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A475E328
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:56:57 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-333a4a5d495so181536697b3.10
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=DyKD+UfJO4F2sfdX2Yih2n/4lfRXPJVvHHZHZb+BlgBNqWypfl30F2JpxoD74xFg8l
         PfkdVJuLF7dMn84XaEDYgiePY6F0tvHm2HoF7NXQuP8cK+Zgh9JopbeqrK6wzoN63B00
         89l+GB+2Xrm6eknfF3PAcLmLXNH7bZGxa25oaYVLHz8MkhEtMdbSRbzwg/paIvvnCuww
         AeUtI9zBYYiph1TiVU11lZvBh4ZxjccoF837lgHutrgMKr7NapE3CgWuB1HiGY7uvTdq
         Zi7/8WCHWVCLrRlZsCs/+Hymm6yiQOdBHmFei2DpwufL7ORmnjwwFFCvJj54cxMlCAck
         NPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=FSyZ90Ml0xy/N/EzGT048eu+LvKW5jLFVBaTCEP9LXFgWP2tRxHY5/G87oDJi7SeCx
         8OGFobh+LK4tCF249gEP7tZuWzambeAUATg84sAxCuGcJHB1egaR2v4VKnI7hC/H+R0K
         J0IO1aDh5XCbfH3p5jldUz2cFX5xh3rdqEAbw+7hFtrtEf4RFttGrt1PDLH/dHgobNq4
         O955hPa4xDuSqxAGmJNoDyglB7RO0sosOs2XnluG9QrtrzuiV6kcS2m4HDrGrXERytyK
         H89wQTcaBJhZTKCfZQ24722M1l/jn06e3Nf32yn9Pi2doOx9vszo3o4JbCwEFgCIXoa9
         EK/w==
X-Gm-Message-State: ACgBeo2HG4wK4+iZgchqkSYJCg9eWQ6OBpzohBL4CRJyJgFdQ4PPDJe0
        NCUS4zYgYEoN0B4bc3EPOEebNWFqL6OwSOp/igw=
X-Google-Smtp-Source: AA6agR4L4Ca+MaUangew1YmOhk//oehUGRq99YEdawDbEzh8EjxDGMWxZuBofjoqGi4F8Y9ZT4JO2ylJrr1EP9CaWSQ=
X-Received: by 2002:a81:5409:0:b0:336:2f14:500f with SMTP id
 i9-20020a815409000000b003362f14500fmr9624650ywb.164.1661767016136; Mon, 29
 Aug 2022 02:56:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: issasalif505@gmail.com
Received: by 2002:a05:7010:5925:b0:2ef:6bab:eaf0 with HTTP; Mon, 29 Aug 2022
 02:56:55 -0700 (PDT)
From:   Zahiri Keen <mrzahirikeen1@gmail.com>
Date:   Mon, 29 Aug 2022 11:56:55 +0200
X-Google-Sender-Auth: HCj2aGjhdVyn7XzQzyj9BBP3OUc
Message-ID: <CAO1GMASM2r8ZQFiQs-4j+H2pCN3h79XjfmvPbBWi6YLnJ4bsqw@mail.gmail.com>
Subject: I am waiting to hear from you urgently.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1142 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [issasalif505[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrzahirikeen1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I know this email might come to you as a surprise because is coming
from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri
