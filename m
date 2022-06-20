Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADCF552233
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbiFTQ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 12:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbiFTQ0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 12:26:01 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E881D0F6
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 09:26:00 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3177e60d980so84179867b3.12
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 09:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=AxZOLWWV2zJmAf07Z/UkIXx+4I8hu7YPuvmoKiDADCc=;
        b=epKPsnrwEM4zGa1UyifXUYf7dTHBdLRF0sQjo0mBvd6BSuwq6Ab1eA/s4uEWeG3C6C
         dlE+BGDNyBKyxO4/voDqeZHypZf3MenoW86yUGEUsff6qdOGymmtF6JhahLp+lpVHd7/
         IdiaQ0/huVpJst1EV/oPZjpHUPoz3N6J/TRQ8yYUtkPu9EF63CNj2y4iQ+BxX8ge2Oeg
         f3Y9xW3Mg7v4sMRChIdjkDtXmtaEOQYT39b69R4bWHW53WsymTxPOpDgTSF6qYzLAD/k
         sp4kJmBGXy5wpftDrrmI6uwHOovkL1Ee1fSKQtR8u0bWdb4ErwAvIj+vzcfCrjAQPHkd
         3V2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=AxZOLWWV2zJmAf07Z/UkIXx+4I8hu7YPuvmoKiDADCc=;
        b=1LOCYpVpFEldDZBUwQIU3JUvEiQzGOClYFBPqIiyq+W/TD5acBCQsIBmK7IMw6SRW2
         8hVc3oHDpq1bOO3JK3Hv3pq46D3BUCo5dq0CZt7FANVEJL+bcxpvb6Mg+Q/SzmtWdR8E
         ALd0A7RUhhE4HIqJh+KAZG+TD4tiHZe7SPCgc2uRe51BwK+kMoZ6ok1qM1jIMzjBE/Vb
         KWgDT7S/ZZ+rqu3M1qXBMOffdEPhFihLjV5PBxgtLMcLRFuwNaNi2HjJX0xMJYle7ZSm
         UaPfNjErUT5H9cbMaEjwrWDy2OBCxC/B6+DJRa1mMkUhwuETa09fRTx81ZTTt9BFRMZL
         6WtQ==
X-Gm-Message-State: AJIora+XIPxFsygewG2FjO57X9yiUVWu/oLb7dsdkv3UOTbBGM4sx64t
        mQsLRtwrpiZ8Ht6cYrHWoLVdLgxUhRPo1ULsyTA=
X-Google-Smtp-Source: AGRyM1tu1KPR8P9qJuaPX/hArQATHtEwAW3T+RiJAQipWXvI28/6bvWngSnJIhxcqZoHIPbPGcVZBqRnNe2od6422RA=
X-Received: by 2002:a81:4886:0:b0:317:7e90:cb02 with SMTP id
 v128-20020a814886000000b003177e90cb02mr20828656ywa.506.1655742359742; Mon, 20
 Jun 2022 09:25:59 -0700 (PDT)
MIME-Version: 1.0
Sender: adonald323@gmail.com
Received: by 2002:a05:7000:c21c:0:0:0:0 with HTTP; Mon, 20 Jun 2022 09:25:59
 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Mon, 20 Jun 2022 16:25:59 +0000
X-Google-Sender-Auth: vTkF_goGQyOgCyzHjdMWFqteAfk
Message-ID: <CANHbP4MOspG5DEVKY+5vcTpX-C5jYg3FDHHs2S6gpDuoMQZt0g@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1135 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5630]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dinamckenna1894[at]gmail.com]
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
X-Spam-Level: ******
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
