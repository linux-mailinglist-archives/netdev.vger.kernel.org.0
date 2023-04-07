Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7406DAA0C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjDGI1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjDGI1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:27:00 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688B96EAB
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:26:59 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r187so48381867ybr.6
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 01:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680856018;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VE9lhMv8xxm6PsQwvddcO9kn8/ov1U8E2CsrpaRaJ50=;
        b=YwT8P7m1ixk+cIKHvZNmIx2E4r27EI5Mt1DUn5UTDIximjJx3QRF4ISeUZevBoDPgF
         5AyT0cQS2jmxH3M77i6/BYHSb1zHEA4Lm5VPbwcY4a1kW5E5EnimhxA5qNwsYUIBuMdE
         +WBaPejzxxD5r/Bfd34+tsTdTNPwNrMSB3yDK4ZLCR0IOzbiAJW62mKu6HFDIkrS4t9f
         8QdYkD/0Xu7iZYAFg6/9qIH8u3bUq4VoI0i3HZyVDCmDbKbFZjPksCkOj/B8cRe8Ocib
         MAylFk8QTv3vfWXfzZhJoBx5twNiXob5ZxKAv7+BGu3ESv4IcfCHXc0fT3bqfzWdEKuc
         T3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680856018;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VE9lhMv8xxm6PsQwvddcO9kn8/ov1U8E2CsrpaRaJ50=;
        b=3p+HJ+SwE6dH4gn/OptCqWtnZNE+X1RSp0uUKuD3Z2x9udTuYQ+ZOOdi3K816P30eX
         6KZZiXYp0KcICMdQ07dw9O9exnSlJQ3PHoLz+0yI4Ixl2rGxryx9YaJnNyuQSUF3LuYE
         2Qp5dCnb/xm4aln3neu/pQMSsoRk2FuFADopaT+W58IEEGLzOZbV0Xaz6nVm3jtAlIgW
         DlgqYmRmtfnh018fQj10ghlevlN/jY6psCBO/AbkLG0ngVDYSZRo4lpwwEKnUDNeY4oY
         +ISWRjqPyiZW2aP18ACQ+ZYcU+dK/a7UAWRQU0vpc69R8kLmN011+hcfMD+QO4VKNjCq
         TIQw==
X-Gm-Message-State: AAQBX9fp2CyCOn9DAZWPmHxnKn0RhbT374Kcr9v31D5++zrkkHWGEsPy
        m3Mcq7QniwtochdLYt76bMnu5etKtnhNYgQsvjU=
X-Google-Smtp-Source: AKy350aMiNngZ8Ik2gYUoYQ6nDjvG4fM9K76zwApUddTqg11fDdl2WzGm3Q+3af8MCYtauVboBbtO5kbH1jaxCDc/pA=
X-Received: by 2002:a25:d4c8:0:b0:b8a:7b2d:6555 with SMTP id
 m191-20020a25d4c8000000b00b8a7b2d6555mr1385113ybf.9.1680856018200; Fri, 07
 Apr 2023 01:26:58 -0700 (PDT)
MIME-Version: 1.0
Sender: 4444km8888@gmail.com
Received: by 2002:a05:7000:b28a:b0:494:42fb:1641 with HTTP; Fri, 7 Apr 2023
 01:26:57 -0700 (PDT)
From:   "Mr. Daniel Kafando" <daniekafando001@gmail.com>
Date:   Fri, 7 Apr 2023 08:26:57 +0000
X-Google-Sender-Auth: AD-HModsgGibDxwZGa5ZUt1kn3I
Message-ID: <CABEaB2BN8JP5KiRnRTK7ghMs1vByn+Sr95UCw8XbancK19vWZw@mail.gmail.com>
Subject: Am expecting your response
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        LOTS_OF_MONEY,MONEY_FRAUD_3,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b31 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [4444km8888[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [4444km8888[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.4 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Goodday Friend, I am Mr.Daniel kafand, and I work with UNITED BANK OF
AFRICA. Please Can you use ATM Visa card to withdraw money at ATM cash
machine in your country? I want to transfer money to you from my
country; it=E2=80=99s part of money taken by some old politician that was
forced out of power.

I acted as the Bank Officer to most of the politicians and when I
discovered that they were using me to succeed in their greedy act;  I
also cleaned some of their banking records from the Bank files and no
one cared to ask me because the money was too much for them to
control,  They laundered over $7billion Dollars during the process.
Before I send this message to you, I have already diverted $4.2million
Dollars, I will change the account details to yours, and apply for a
visa card with your details in our bank, they will send the visa card
to you and you will be withdrawing money with it and always send my
own percentage of the money,

Whatever amount you withdraw daily, you will send 50% to me and you
will take 50%, the visa card and the bank account will be on your
name, I will be waiting to hear from you for further information as
soon as possible.

Best Regards.
Mr.Daniel kafand.
