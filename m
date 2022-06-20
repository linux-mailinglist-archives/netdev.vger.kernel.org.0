Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3FB55222B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 18:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbiFTQWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 12:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiFTQWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 12:22:24 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BD71C133
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 09:22:19 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id l11so19830249ybu.13
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 09:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=AxZOLWWV2zJmAf07Z/UkIXx+4I8hu7YPuvmoKiDADCc=;
        b=GJRf2LZ8Fty75EfiZ2l7zDyYGtMBf6FkEvhPMvGTb9HZrQpaTPL3A3pC9DjXhUCxTS
         JGBybZiecA4S1jePMme9MjGm8r6dtdWutDvjqEjrMZES3DQcqXf5GNEHJ99nmgeoBQ6W
         ySMnPakgEcIHDl2LJWCBtLg6L+NNmabZp4Cix2aQdpw8+dkkyV/lDwJ0jaiKI2V230y1
         fDe303X4rYjPy3b+WLPgK+9FKqeOnbHRfP24DJqpDlGcHrpPEGF07qhZ+KTvyHi5AH3m
         LjjDRzimg0xA4HoOk5EZ9Kw9n/H+CVwmpSaTkBkwD4Kkc6EkTFJKKLp6mOUhGEkAqOAR
         crAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=AxZOLWWV2zJmAf07Z/UkIXx+4I8hu7YPuvmoKiDADCc=;
        b=BYPvJg2zePuXzcqWN3LzkoinMlk3nHcOGtXcEH1kKZmf4fh7jUfGsLDOvp2xBQ3Bph
         I7Ivo7WIQgmXdlnKbXvCbDWjlQHJQ/EIkFhYkoEJJRlfTc6ozswUMjeRDN5B/aNW6v0u
         h1PtOOAJ1bWNrtG9ii/Opr7TocnZxdAofcJQnbiVOe/WOHfmkMEglWkgOipQ2+sDo+p7
         r2UFnoxBlzd8j4fF6+r6h9lPk+pIiFQE7LRFskJalB/N7d6OKBOaXiIJq4RkJUb3rez1
         nquJs8k/mXoH+ZblwQmMQjlAi2pj+kStGur1po0Yf6roZUHEemyJ4AssHF7rLlFMb9UL
         qL+Q==
X-Gm-Message-State: AJIora8U0ZVImk/rN3yrNZOTCM/B978adbMIDygcJllgyuRGQnPEfm4B
        50kO6Gc0VSsaqIuEjT/UJxBru8tVZ1RmpfQS5L8=
X-Google-Smtp-Source: AGRyM1ucpwdHF8ft6vV46lBmEeKKythlFQlDWN8aZ4W4GxAiPkLfdieM7oitjUCTqDfpKEB9Epf1aVycNsfITApVIe4=
X-Received: by 2002:a25:84c1:0:b0:668:cce5:42ce with SMTP id
 x1-20020a2584c1000000b00668cce542cemr14929062ybm.456.1655742138254; Mon, 20
 Jun 2022 09:22:18 -0700 (PDT)
MIME-Version: 1.0
Sender: adonald323@gmail.com
Received: by 2002:a05:7000:c21c:0:0:0:0 with HTTP; Mon, 20 Jun 2022 09:22:17
 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Mon, 20 Jun 2022 16:22:17 +0000
X-Google-Sender-Auth: o4qaguX1YDf5efCiyN9itMfNAuA
Message-ID: <CANHbP4O1NtP6LoL1Mw2FmOrOQXGo898MwZyDK2Xt+oc2OwHSEg@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_60,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2b listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6957]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adonald323[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adonald323[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello My Dear.,

Please do not feel disturbed for contacting =C2=A0you in this regards, It
was based on the critical health condition I found myself. =C2=A0My names
are Mrs. Dina Mckenna Howley. A widow and am suffering from brain
tumor disease and this illness has gotten to a very bad stage, I
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
instruct herein..

However all I need and required from you is your sincerity and ability
to carry out the transaction successfully and fulfill my final wish in
implementing the charitable project as it requires absolute trust and
devotion without any failure and I will be glad to see that the bank
finally release and transfer the fund into your bank account in your
country even before I die here in the hospital, because my present
health condition is very critical at the moment everything needs to be
process rapidly as soon as possible.

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
Mrs. Dina Mckenna Howley..
written from Hospital..
