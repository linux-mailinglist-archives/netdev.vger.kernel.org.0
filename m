Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2956E534708
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 01:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiEYXjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 19:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiEYXjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 19:39:01 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACE2ABF69
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 16:39:00 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id v9so390603oie.5
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 16:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=uMK4uhL7bbIrweYoyqO5hSjV8mXVqG8AbtrOT/hIh/w=;
        b=Vo0BpAu2rolW2tHiZA+x76BexnL0/VQbLZNOiyKak1mwUZ1odJ3uaaebFkJMmyrHhL
         /wDhsjtlOz98/iKJyDAfuxF2tKGNReIbTdtLBvDInzsDEJRIgjmBH4CckiBu9oec1Cdp
         /RtMNryrxBo6L1v9kHiom0URyo1eDJ3gWr+b0y4GCJh/FIpG6yAbC95oa0JWh0M6kfUS
         +5iJIxL/RfpAD6797IQvsoRNhy3eNVEXlqEviLih2uYl/Ao+XIbUxuF1mTKMruQZ/WH1
         noIdT7anebp3ZAmOweIVEFpZm7nPUA81i3zWheT4pE4oxaANa9kQ6ylMPSTqEl15cd8a
         Mv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=uMK4uhL7bbIrweYoyqO5hSjV8mXVqG8AbtrOT/hIh/w=;
        b=kiOuuLccoNaBl9SqNFmaaDEZ7FGHUCSBFXspDOXpwxI1FW7yS6adO83U7o2gT1yw5A
         ot9Tg/1PDrAlW65gI4+NsK/V6lxN3Uv4DunitCEeK2wBS4uNm5EFUJq0yFKUze1iS1o8
         t3alXPfVJefNepJXL+TSuXExc3i1jiRk1NJ7J3zUOONtHIqG9hMsew2YCN+MCteW7tUT
         EJyy9mF9F1JnwykDIPEMXTSWQoUpTY3hMIF2Uvn2UDo5218NFr9VLQTF3VqdKCanQauF
         SPMM1HlWLvGoox1KP9/S5TZEsyNUDR3SF36AyKZgu+yq77KpRLwf7uwQ890CgxtM577q
         9wfA==
X-Gm-Message-State: AOAM530FcAVSfL/wIvHDkotzDrtb1uxfAMldGKfrBii/mi4rPv6jRHlU
        s2QgERf7Ern/7UXI9p/KfmyTPvXo7aqAeSVIsv8=
X-Google-Smtp-Source: ABdhPJwN0I58Xu4+YCknCWJv3aUkPPs4JS3iGsNWkx/5hoEZOfryQBm6/4GNBTk+m69afHLsrgTHCwwDVhFfvQJhrRw=
X-Received: by 2002:a05:6808:f09:b0:328:b61f:1b52 with SMTP id
 m9-20020a0568080f0900b00328b61f1b52mr6344486oiw.150.1653521939862; Wed, 25
 May 2022 16:38:59 -0700 (PDT)
MIME-Version: 1.0
Sender: charityvangal@gmail.com
Received: by 2002:a4a:98b3:0:0:0:0:0 with HTTP; Wed, 25 May 2022 16:38:59
 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Thu, 26 May 2022 11:38:59 +1200
X-Google-Sender-Auth: 6_v9TfDYT_pTUe6NuCu79xj6BSE
Message-ID: <CABTbXjJnbp=4dtkC2754PnV9siN5-PfYS3dBzvdhJQnRQRvQ9A@mail.gmail.com>
Subject: Calvary greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.5 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_60,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:22d listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6651]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dinamckenna1894[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  1.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
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
