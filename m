Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857B36825B6
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjAaHpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjAaHpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:45:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF1236442
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:45:37 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o13so13471920pjg.2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r0MK3YQLxWFdNYh+ayMDurpGXKVCtWhmogus04fQ/FY=;
        b=Pjfj1JIbQTMQKk8Y5slh1CL7bk/TQAeizE7ltp2pX6R1/luDaUpBz6SoLYonT7Bsmh
         VkH+4X3gUOlZ+5RTnf8SIPHQ2ictt1DiTzbHGZTkKTF7K4b9BB6z9sWWoDmDkbqYhfW/
         0nww4hz0fAf/C2AKq8Z8Up/l9ICFPMejln3l3/BoTjviccHuGybUtmm7FyBlVYAVziTc
         9xDwHPPrFWM9MnNdb1mm/eX9U+trB1nZkaWcp3lFB4yeIhKFRVR+xdeUUbEWa7lYuLW5
         Xz1eXqloJavUrMOknwgsTJgK0F7anTKOEzK4FCdKwKyr6wdNZxl5RTxJzJSCVptAvEsL
         AXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0MK3YQLxWFdNYh+ayMDurpGXKVCtWhmogus04fQ/FY=;
        b=MubAiMhtRbNvmWEZplK4CRoYNHAcQ1sjMp5iAB8XBBo53k25E+DdfB184yD9jqnXD3
         yKS9XE253/ULmuqNA6jnB2LBBtd8hdGsJIFRFu8bHR71A3k5Nj5JvVjOMm8ZlQ4h4u5v
         9sLi7PfYEAfdFV1En2q7gEKhnVGgfRJtg9WbTiXJdCjRZUMFAYkijX/6DglChVDRg/c4
         Eu/P3EPN93BtsYHB3mY9APesCGcphIoodhCYzYLQS+TFThraZnOoc30PSw6KNMu2bOtU
         Vu4s9K4LJnicuUJIKWKWklzZJA8fUmiZDnrJ5T3n5VgdqslK/BlhibNLxVyyQ+CNgn5e
         gfwg==
X-Gm-Message-State: AO0yUKXuVhFUBeVWczTzylLs7XzOgZR9MFyHxFUqGbpZx6dx8x/iTXG9
        JkhhZ74pK0O42Q5S3Oliu0itT5sPv/thnwaQWBM=
X-Google-Smtp-Source: AK7set9YhgCusOfoRKONIrvzPN92FGGvDq2gprzrQV/7gKiSLY28CbYy8EZiKTMvy3InUjl77UhmXSEDCJOt8we0gbk=
X-Received: by 2002:a17:90a:64c5:b0:22b:ef05:ea5b with SMTP id
 i5-20020a17090a64c500b0022bef05ea5bmr4420054pjm.50.1675151137028; Mon, 30 Jan
 2023 23:45:37 -0800 (PST)
MIME-Version: 1.0
Sender: samuelakin244@gmail.com
Received: by 2002:a05:6a10:7c8d:b0:407:de16:8c5b with HTTP; Mon, 30 Jan 2023
 23:45:36 -0800 (PST)
From:   "Mr. Daniel Kafando" <daniekafando001@gmail.com>
Date:   Tue, 31 Jan 2023 07:45:36 +0000
X-Google-Sender-Auth: 2nPw5Z0bkCEyMfO2tssvIUhJJD8
Message-ID: <CACYMRtXL4dcRLMfL2kyxdT8rUtEXYUn52+h9z=_VkFd7Ht-+UA@mail.gmail.com>
Subject: Am expecting your response
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_3,NA_DOLLARS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_MONEY_PERCENT,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [samuelakin244[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [samuelakin244[at]gmail.com]
        *  1.5 NA_DOLLARS BODY: Talks about a million North American dollars
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  3.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Goodday Friend,

I am Mr.Daniel kafando. and I work with UNITED BANK OF AFRICA.Can you
use ATM Visa card to withdraw money at ATM cash machine in your
country?  I want to transfer money to you from my country;  it=E2=80=99s pa=
rt
of money taken by some old politician that was forced out of power.I
will change the account details to yours, and apply for a visa card
with your details in our bank, they will send the visa card to you and
you will be withdrawing money with it and always send my own
percentage of the money, and the money we are talking about is
$4.2Million us dollars. Whatever amount you withdraw daily, you will
send 50% to me and you will take 50%, the visa card and the bank
account will be on your name,I expect your response. promptly so that
I will give you further details.

Mr.Daniel kafando.
