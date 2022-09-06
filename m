Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAE65AEF1B
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbiIFPlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiIFPlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:41:01 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F025FA598A
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 07:51:43 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id bt10so17807747lfb.1
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 07:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date;
        bh=2AFvyrObCHkvwVcACFedAi4cW+Lxc7JfD/cB4klOo0k=;
        b=gJNvdOCWuDXdQ2R42FYCQW9a+r1zm+Ko/6tcP5co0D5/kn5JQ0WDaNY6lnFP/vi/ey
         fEbJka5a54NkJ6G6WwTsaIRb2TTy3qJpy0+mvnHg9I+Cg3K3bmtWPQDrOzA+4c8W2MJX
         KNawjoi7rWqEqIo+u2EipSIvihmWaSxVNVQfmnw2fmpPtaqJFUU9PbYA5geNfPpHFWam
         kytHWuI+DrvVfdEoi0kKOxDJjuoedKsAoSK8R8cUp8yh3gMZGH94sqzaaQ5vcohMOd3Y
         ek/UFAM3rmChVpzAc/O8XXEv/xNhlkHihPSRdAzYUcr87Rhu1ZrhtvNvHnOsrcuL05ny
         191A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=2AFvyrObCHkvwVcACFedAi4cW+Lxc7JfD/cB4klOo0k=;
        b=CDAOGHZ9A55XRqpgQSyAtljDqD/Z9DH+hmTfgFqNGdO8UO9oxnvmRQ8nZLWGtAPy96
         2fvo54E16tcF8iofNCRykjjm5hWaMjGTHp+kbByzlTwUC21RHZ2liPG93bSh9kCsbs18
         FhdyPOyv+MOPGtgmIBO4fp5lq8JS5ldewhzRX6XJXoF2/r5kbuyqppSpygFHQUiQ+yP3
         noY8MUjD2L/iG5rFyNJPtEjWnhk+b3OYqBoDEnJ2l8P5CnhZUHmuagjuyjL8E5+o4roi
         O58FNcRbTfqd0jMBbQonL/h1hd1R0En3wwXg+ya3GFg0/QDFdkk6KDfXlb4n2I+9IFKP
         YDMQ==
X-Gm-Message-State: ACgBeo09BevSLRFoaYGSfCkbPKagk7CpQDijpaEWBFLeFZqxy3JQXJbG
        fvm/JRHDx7BcL6W5WwAeDEcD3D8kxw0eXhCKphM=
X-Google-Smtp-Source: AA6agR6RIitCv1Zx7hO1TFIVRC4mbyicEgZ32UlYbzmqcnGXV33fCvqignYS7JyB5DwmTRQp+7QlNmZJSnOatpOUNOM=
X-Received: by 2002:a05:6512:228a:b0:492:b0d5:910e with SMTP id
 f10-20020a056512228a00b00492b0d5910emr20416485lfu.616.1662475888312; Tue, 06
 Sep 2022 07:51:28 -0700 (PDT)
MIME-Version: 1.0
Sender: adonald323@gmail.com
Received: by 2002:a2e:b169:0:0:0:0:0 with HTTP; Tue, 6 Sep 2022 07:51:27 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Tue, 6 Sep 2022 14:51:27 +0000
X-Google-Sender-Auth: KItO2Ylbe44Wnq5klKxtKDnQY1w
Message-ID: <CANHbP4P4gT6o2mBrBvOzriVR_HkNu+hsP1JJx_fD2GU2jOVE8A@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.8 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12b listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8977]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adonald323[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dinamckenna1894[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello My Dear,

Please do not feel disturbed for contacting =C2=A0you in this regards, It
was based on the critical health condition I found myself. =C2=A0My names
are Mrs. Dina Mckenna Howley A widow and am suffering from brain tumor
disease and this illness has gotten to a very bad stage, I
 married my husband for Ten years without any child. =C2=A0My husband died
after a brief illness that lasted for few  days.
Since the death of my husband, I decided not to remarry again, When my
late husband was alive he deposited the sum of =C2=A0($ 11,000,000.00,
Eleven Million Dollars) with the Bank. Presently this money is still
in bank. And My  Doctor told me that I don't have much time to live
because my illness has gotten to a very bad stage, Having known my
condition I  decided to entrust over the deposited fund under your
custody to take care of the less-privileged ones therein your country
or position,
which i believe that you will utilize this money the way I am going to
instruct herein.

However all I need and required from you is your sincerity and ability
to carry out the transaction successfully and fulfill my final wish in
implementing the charitable project as it requires absolute trust and
devotion without any failure and I will be glad to see that the bank
finally release and transfer the fund into your bank account in your
country even before I die here in the hospital, because my present
health condition is very critical at the moment everything needs to be
process rapidly as soon as possible..

It will be my pleasure to compensate you as my Investment
Manager/Partner with 35 % percent of the total fund for your effort in
 handling the transaction, 5 % percent for any expenses or processing
charges fee that will involve during this process while 60% of the
fund will be Invested into the charity project there in your country
for the mutual benefit of the orphans and the less privileges ones.
Meanwhile I am waiting for your prompt respond, if only you are
interested for further details of the transaction and execution of
this  humanitarian project for the glory and honor of God the merciful
compassionate.
May God bless you and your family.

Regards,
Mrs. Dina Mckenna Howley.
written from Hospital.
