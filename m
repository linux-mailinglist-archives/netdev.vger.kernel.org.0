Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5953B576FFB
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 17:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiGPPvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 11:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiGPPvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 11:51:12 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0480183BE
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 08:51:11 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-31cf1adbf92so71997547b3.4
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 08:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3qF4MeJBnDiw8ry4p0CwZ2aa7S+PVcycR5JZNtbnQ3A=;
        b=HbGz70q5Zf6X51f+l7Xp/sc/aPM1Q7be9PQV+7uk8K9C+H6HXinEYorXyOmjz75PA4
         gSUn6yBILZ0p002S+6jZmbuWVZI86ED/oa0g7ajkf+4uaVJ58efIdGmWNvOf/XZa2FZs
         4kO0qz1ZRGQuNK8UQYCZgiD0UyrIDWIkYsgV9/6irFcOfh4GX7aiq8Nvq2hllxrehGp9
         svmW1ksldIcQJJTJGAgcGRPsomFSZaazyEriDZMiFVlpr1Z9AP331mkp9nqMSVCbBEEp
         Kwq+OKizZx9HnIjfmYtx23PPGzTRbb/NInzibQTHrzPBGGmlQb30Xkq+x+/HPkAsoJdl
         PAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=3qF4MeJBnDiw8ry4p0CwZ2aa7S+PVcycR5JZNtbnQ3A=;
        b=tBXcT0uPw2EcVbim+IqpuhbbO7p9lCSWINFxy/UsAQAFnike3/deZNLaOyTR8306aV
         wzP5Rr3SeJyujXRaCxPTgSKGecEhY1INvCXFSwCXAX4MdmNDs9dPozTSxTVpt0JiHdW6
         K0N0eVDJDMY+4nqm06PIWd2khumi3j4zMxtfnEhZL5Ly9fTFSIgEH/l8WO+/A1qaG5U8
         K3T3wZRSBJHM4MRiSNieo8OvvO20CdN9tnNnmaQJrFWzWL6v4SOTyOAAo8i+NscrOnSg
         6WaBjHZGy//J4MruIbJZS7D+jq04hJ0HhjpoKlm6+u66Ws4NwBmNQya/E+oabrd6wFl0
         ws6g==
X-Gm-Message-State: AJIora/mKvCE8hneS6ZwrOGHedfUHL8g7TYye7CJoBHt3VzghbQgNuS7
        Edyv2T4DPXDpm3oyqpZNxQ2DuAuHVS29CbSoAB0=
X-Google-Smtp-Source: AGRyM1sApUJk/LDCxKrzWhDBNH3uYeFY1Og16E+IAPwjlSgqC9WyIZGhanYqSy0rlok0lzNbds4eR3twkMVWznHnNX4=
X-Received: by 2002:a81:9257:0:b0:31c:f1ae:15e6 with SMTP id
 j84-20020a819257000000b0031cf1ae15e6mr21622964ywg.352.1657986670915; Sat, 16
 Jul 2022 08:51:10 -0700 (PDT)
MIME-Version: 1.0
Sender: drfranksaxxxx2@gmail.com
Received: by 2002:a05:7108:1f90:0:0:0:0 with HTTP; Sat, 16 Jul 2022 08:51:10
 -0700 (PDT)
From:   MRS HANNAH VANDRAD <h.vandrad@gmail.com>
Date:   Sat, 16 Jul 2022 08:51:10 -0700
X-Google-Sender-Auth: VN961RN7_9sghTwpIcFcsRfmjbo
Message-ID: <CAGnkwZ5ROjRJpnDqjRKHnmuYgnSq+TPo5Z9bRCUYEnuu0hKgkQ@mail.gmail.com>
Subject: Greetings My dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.9 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [drfranksaxxxx2[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [drfranksaxxxx2[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings My dear,


   This letter might be a surprise to you, But I believe that you will
be honest to fulfill my final wish. I bring peace and love to you. It
is by the grace of god, I had no choice than to do what is lawful and
right in the sight of God for eternal life and in the sight of man for
witness of god=E2=80=99s mercy and glory upon my life. My dear, I sent this
mail praying it will find you in a good condition, since I myself am in
a very critical health condition in which I sleep every night without
knowing if I may be alive to seethe next day. I am Mrs.Hannah Vandrad,
a widow suffering from a long time illness. I have some funds I
inherited from my late husband, the sum of($11,000,000.00,)
 my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my
stroke sickness. Having known my condition, I decided to donate this
fund to a good person that will utilize it the way I am going to
instruct herein. I need a very honest and God fearing person who can
claim this money and use it for Charity works, for orphanages and gives
justice and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be n=
amed
after my late husband if possible and to promote the word of god and
the effort that the house of god is maintained.

 I do not want a situation where this money will be used in an
ungodly manner. That's why I'm taking this decision. I'm not afraid of
death, so I know where I'm going. I accept this decision because I do
not have any child who will inherit this money after I die. Please I
want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. May the grace, peace,
love and the truth in the Word of god be with you and all those that
you love and  care for.

I am waiting for your reply.

May God Bless you,

 Mrs. Hannah Vandrad.
