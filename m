Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBD065E1BF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 01:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbjAEAlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 19:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbjAEAjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 19:39:07 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA3FCF7
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 16:39:03 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id df17so21003053qvb.3
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 16:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y6exoao3P9DQTx94Z+U4h6spplMgDSe4humG8QLTgJk=;
        b=LR84OLP79Rv94AgbZ0vYzZddMUAs/Tu3PfocFmm7C159WM4clDX0DqImdmNhp6Ur9x
         FhvKGrzLEVReiUZ0xIMoptnznWwi1na2HCyofmdDnhpfz4wXzIHIrJbqpGF9FEUrXdWl
         y7ZnuRoSkHq2hNo0Jt54733xWsZ03vAlgQ9jb5PKNj1iZTu/ZsBIBKPh0Xcipb7Anzm4
         h47+HPSFLmSEsA+iRCwRTKq3Ot7+YaHCx8honYhgFlhQgffRtl7h4i/XgYZc2RPg4kD5
         RGn2YP9CKYF7Re5cMipY+LSFSGkayCkHCsouzG9L/KwD6tDJ6l5u/+w5S2UbvBEPDw4b
         tyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y6exoao3P9DQTx94Z+U4h6spplMgDSe4humG8QLTgJk=;
        b=YqIiGDb7KY+n7OzNfwmOcyW+XErV1X90nFKv8VV96Gpttw+vzJH2n8do0N341bvcBY
         kHgudKsWtyqHjgY/FBNVFy/WzWNn5RvjDv+Ukr2rjW2YFA6Pt/5/vZRKn2B345VvTqt8
         sm3Bgaen6Vftm2V5N6+jrs/6uLPFIwJPy9Hge6B4KIhMT0AR230jmMIPZ5kWxssZMXL8
         prsaFF4JQpGnV2DSX374srbX172r/QuCuPcjvEfh3iXun+XBWlK4cML2RvhY1ZqoYAwo
         LrI0hrV9vGn+RWfMmM3aCkSjg0nqDEftXBrHbVUTNAQv5Xl9HqFGZjPnDq3CJnIYAz8Y
         shgw==
X-Gm-Message-State: AFqh2konzSwQ6hnda1oSCSbAhNm15Sgi8G8Gr6JeP4KoQvS2/OI2v/J/
        OzjSB83slr1Yr/7Z+VesO3RB9Ezj3recGH2/SQ==
X-Google-Smtp-Source: AMrXdXsMLxih0cy2/7LYs/haUXfIZJSTgnVmFG2c0cumQbqc2H/R94VQ5EA9YRxAY4G1hA43/cMo26/GfvzAS2Bc+5Y=
X-Received: by 2002:ad4:4f32:0:b0:4ef:3185:f6a3 with SMTP id
 fc18-20020ad44f32000000b004ef3185f6a3mr2209549qvb.26.1672879142582; Wed, 04
 Jan 2023 16:39:02 -0800 (PST)
MIME-Version: 1.0
Sender: lw716547@gmail.com
Received: by 2002:a05:6214:4b99:b0:4c7:6264:66a7 with HTTP; Wed, 4 Jan 2023
 16:39:01 -0800 (PST)
From:   "Mr. Daniel Kafando" <daniekafando001@gmail.com>
Date:   Thu, 5 Jan 2023 00:39:01 +0000
X-Google-Sender-Auth: 9TZv6SdyOfGPGvE-aaJuKdbBT0A
Message-ID: <CAM4b7K=FcVsDCVXV0QDa4XJmzV9wxv-S9ywQOq_eHdemqAqCHw@mail.gmail.com>
Subject: Am expecting your response
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_3,NA_DOLLARS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_MONEY_PERCENT,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:f42 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6896]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lw716547[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lw716547[at]gmail.com]
        *  0.0 NA_DOLLARS BODY: Talks about a million North American dollars
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  1.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.5 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Goodday Friend, I am Mr.Daniel kafando.and I work with UNITED BANK OF
AFRICA. Can you use ATM Visa card to withdraw money at ATM cash
machine in your country? I want to transfer money to you from my
country; it=E2=80=99s part of money taken by some old politician that was
forced out of power.

I will change the account details to yours, and apply for a visa card
with your details in our bank, they will send the visa card to you and
you will be withdrawing money with it and always send my own
percentage of the money, and the money we are talking about is
$4.2Million us dollars.

Whatever amount you withdraw daily, you will send 50% to me and you
will take 50%, the visa card and the bank account will be on your
name,I expect your response. promptly so that I will give you further
details.
Mr.Daniel kafando.
