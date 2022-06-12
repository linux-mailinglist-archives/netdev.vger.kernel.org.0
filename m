Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5E9547834
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 03:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiFLBgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 21:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiFLBgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 21:36:43 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AC23D1D8
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 18:36:42 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w20so3875992lfa.11
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 18:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=iluM7QoGSVKWEy/a/nZQFa2BdBD2biDV4LAp8D5uMls=;
        b=ROfngNz5McYno9rKr9GrhnyJkeTCfdJrXTWZAh0T6ayzpdcSVioKfaU6li4m3Va+br
         NBkgDW0Bpf4Jl5N//mSx6tBajAYZSy8iFHwlbdUjb3eRWU2Dzkh9edCCosoaMYz67T8e
         yW/0vbZr/bpVDrhlk2TOTawi0+t9N+DbhUM3F3XcRyEyfZ3/5stzBLRPO1zOe7e8ricL
         6hwn83ro+H0yED3U8JrBkbklGKgQttAblM7AFkW7l3sdPcFR/rppmxdbDtxr0dnxc4Lu
         7Mp7D6EsRbBgA1qFIIpRzJaABngnFND+u9Zk8ewEg6ldx6rNqdRdnPEtXTWTOkpNCHha
         ReUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=iluM7QoGSVKWEy/a/nZQFa2BdBD2biDV4LAp8D5uMls=;
        b=LmP2h5tHzK33qvvTRuR5xnRiEJXH+TufGT1O2zqE55lZMYtL+4GxMuU605AWG8eyng
         cO+4ZH2/uvIvwpAUKZMdhFhyrArESphO/kM6HlrJHv6ok1WgKxerY6+BtruhJnJJdBz4
         SdURhcSIxuWN0pT/503Wwplkeou7LzoPhOrgASmifmdfVXW3h76IPLbUv4ujfOyj5+IJ
         TtuGjSvsxuvoCqJLyp4+mFxpGHfBQrgj5YYNsN5AMktFVx4USCiEFoOxYv1VPiFbzDhO
         tn6oPg6J9Yh3+y5m+P4vfHbXKS0+1nEqQOSEPnmf4CtedDyYWUq9SjqJOXSMT0GRxVcT
         HPrQ==
X-Gm-Message-State: AOAM531hTPS1XfY11c/XzcFcI3o1rHh80UUxmqXa7bvN2iZya0sD11qu
        LawW/z2WJgVGg+HbeDV4xIBsdiS5rBlZQ5xSK0s=
X-Google-Smtp-Source: ABdhPJyjQgskHVHvr+9F/upKQWHVC4T14WmIs4+wRMw4aXLzYjpXEeEbBBoVea28Zcvp+wnsmFiB+lTN90J3IFdoR7s=
X-Received: by 2002:a05:6512:3d88:b0:479:1ad9:c007 with SMTP id
 k8-20020a0565123d8800b004791ad9c007mr26092240lfv.68.1654997800706; Sat, 11
 Jun 2022 18:36:40 -0700 (PDT)
MIME-Version: 1.0
Sender: janetibrahim250@gmail.com
Received: by 2002:a05:6504:a16:0:0:0:0 with HTTP; Sat, 11 Jun 2022 18:36:40
 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Sun, 12 Jun 2022 03:36:40 +0200
X-Google-Sender-Auth: tEd4SqBiqMnD7ZC-04HtMIwWqDE
Message-ID: <CANUF9+raEpfCfF+kGqbyk8rSzHefa=Bcx0kkAOikaEN5D+30sw@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,
        HK_RANDOM_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:130 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8978]
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.5 FROM_LOCAL_NOVOWEL From: localpart has series of non-vowel
        *      letters
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [janetibrahim250[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sdltdkggl3455[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

May the peace of God be with you ,

   This letter might be a surprise to you, But I believe that you will
be honest to fulfill my final wish. I bring peace and love to you. It
is by the grace of god, I had no choice than to do what is lawful and
right in the sight of God for eternal life and in the sight of man for
witness of god=E2=80=99s mercy and glory upon my life. My dear, I sent this
mail praying it will find you in a good condition, since I myself am
in a very critical health condition in which I sleep every night
without knowing if I may be alive to see the next day. I am Mrs.Sophia
Erick, a widow suffering from a long time illness. I have some funds I
inherited from my late husband, the sum of ( Eleven Million Dollars)
my Doctor told me recently that I have serious sickness which is a
cancer problem. What disturbs me most is my stroke sickness. Having
known my condition, I decided to donate this fund to a good person
that will utilize it the way I am going to instruct herein. I need a
very honest and God fearing person who can claim this money and use it
for Charity works, for orphanages and gives justice and help to the
poor, needy and widows says The Lord." Jeremiah 22:15-16.and also
build schools for less privilege that will be named after my late
husband if possible and to promote the word of god and the effort that
the house of god is maintained.

 I do not want a situation where this money will be used in an ungodly
manner. That's why I'm taking this decision. I'm not afraid of death,
so I know where I'm going. I accept this decision because I do not
have any child who will inherit this money after I die. Please I want
your sincere and urgent answer to know if you will be able to execute
this project, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of god be with you and all those that you
love and  care for.

I am waiting for your reply,
Mrs. Sophia Erick.
