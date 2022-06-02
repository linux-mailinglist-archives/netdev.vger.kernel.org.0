Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B575553B37E
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiFBGUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiFBGUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:20:15 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F281406CC
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 23:20:14 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id c12so2998238qvr.3
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 23:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=o2gvj92MMCJDCXwiQ2IaKQl/GSOzCsdEUW5hfj1w4mY=;
        b=jqjhIMcnN38xe8KD3rtttAeRrRw/1DaGRxpvX9yRMEkHyWsaAJqFmkK+/LK8VX4CJc
         l4NShH9+PbKeD6tUZiOPoPtUM6ujoHC6mao60Fv7+qc3jBj9dY8jaQOEB5Qt28CfLdr9
         n7HUpIRbTt0njGIIhEDtO+qIWeD/hPHt2Y9Yl+OqCHmyRaIOoN7VQMf0EPrcvs+8PjvA
         q9ZbBtcN/F+bZClFDmJy/2k41Wmr+nqK+jIWC2B35E/5gfDvs7phd6xOc7KDmb9if4AQ
         fYnLrzkHwKeffTIQyPZbfYS8JLtf3SRBgpIYKeQAmbb+nNfVGBUoRCdEHPVGulfKG2+A
         q+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=o2gvj92MMCJDCXwiQ2IaKQl/GSOzCsdEUW5hfj1w4mY=;
        b=uqk7+FReipD47hks6Sf172awWMASv5BKm7QjOOFhPrEUaPZKtxqBdDl0kjozX+4Xa7
         K8yF8/8ojOq48MH+uvJcuPfLuwt8PDO8ZA5GlIQMrpfwPLXoLTV3LkbqqLU79CEnwTnq
         Xa+KEeg9A7P7NU4pbWBSFUVFZCkNT5mNOezA/xjEZqbupMCibVxUa2JaPaekbE8shtKU
         Y66D4l7kCRGh9ddq+gbDl29pf+QZr9qjX4t/L9o13gPJF3EJZCYR6r0trpD48ONhHrGV
         3My/hDycpXONqFuSPvH8JHyqkssXev5K0bo7EPRNBXCmnkrpbe2boFLbFMEop+XeGg0e
         7OTA==
X-Gm-Message-State: AOAM533fIuR5vbf8bgQjYTDx4gxQ3SHt1LX8/FbS/dbrlRQOaUY4kdJ9
        jHMQ2qN1RClkd6J6rwOpwyJzROFWAM4z88pNi/E=
X-Google-Smtp-Source: ABdhPJy8qodqezYDDqTKWKOmPYGqCrBU/Iya0rKxrVY0ml2boMJnQ3hKBk6m9YMDYUmsfa2hp1sA7TJ1DRE+YrVBdnw=
X-Received: by 2002:ad4:5d49:0:b0:461:f201:857a with SMTP id
 jk9-20020ad45d49000000b00461f201857amr2327627qvb.36.1654150813336; Wed, 01
 Jun 2022 23:20:13 -0700 (PDT)
MIME-Version: 1.0
Sender: 1joypeters@gmail.com
Received: by 2002:ac8:5f4d:0:0:0:0:0 with HTTP; Wed, 1 Jun 2022 23:20:12 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Wed, 1 Jun 2022 18:20:12 -1200
X-Google-Sender-Auth: _1PlTPfdB2Y1Qjh327hSdI9LCQQ
Message-ID: <CA+F+MbZUb48fcr112cGyeObBDGXq4DW315xkuRVQmxN63z6PYw@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.5 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_95,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:f30 listed in]
        [list.dnswl.org]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9734]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [1joypeters[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Howley Mckenna, a widow. I am
suffering from a long time brain tumor, It has defiled all forms of
medical treatment, and right now I have about a few months to leave,
according to medical experts. The situation has gotten complicated
recently with my inability to hear proper, am communicating with you
with the help of the chief nurse herein the hospital, from all
indication my conditions is really deteriorating and it is quite
obvious that, according to my doctors they have advised me that I may
not live too long, Because this illness has gotten to a very bad
stage. I plead that you will not expose or betray this trust and
confidence that I am about to repose on you for the mutual benefit of
the orphans and the less privilege. I have some funds I inherited from
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars).
Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country  for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die.. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply.

May God Bless you,
Mrs. Dina Howley Mckenna.
