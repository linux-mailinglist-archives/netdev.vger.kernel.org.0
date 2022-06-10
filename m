Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4739546A86
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349323AbiFJQff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349778AbiFJQfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:35:12 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553C356FB1
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:34:55 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id l204so47849969ybf.10
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=0XYuJwlWcPhF5wKwZj6AX0M1ehVlcZ8wjqHIDg46ZGY=;
        b=VSyurl9asweuvIHG6B+aUBNEiA8F3h2x0O8IzQ28ezo9IRmQ0GmSotebBIPqY32N55
         T2EJgHrwaCMjXK5h7WBSDuyIiAek/pBqHII5LaQmvJUo+rd8K2pz+BBEn2iOWeQgl+YZ
         NExFEgklrCenUk/Eh5kWzgpDZE/i+Yb9gNpii/EyJrOGuempAj2d4KUidnRTaxlYTxJj
         JPmXbr9elSLdkerq+vikwi6QlLIe49GPlyiAxduZChruOzEflPRUSgLfNGlyv3FJ4v/j
         tp6VblhEK+v5PdsjJCos0kOciiZRnSjqEKlDU7bYTexW0K83+sufkCpmACSVkJTLw/1b
         Mocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=0XYuJwlWcPhF5wKwZj6AX0M1ehVlcZ8wjqHIDg46ZGY=;
        b=njTspQQa/srBWVd6c9PggInsuMUe/Z51ZJlzdE89+wURp/ocbNAeAQGerVnUwnB30q
         gQxtkuITc6J3CvlCiIO8MhEOQDtKmJ4JBue6JZ1soj2kWLG3c194hRqOE7RhZjjtFQoU
         pPkj83wRQLHLGsKPQOrXhgdtCh59jtS53Je+eOPzlFSyR0efOMcIKsnoch2dR/T/uQSg
         iWn0BCVzGrEh1CjxRonDbjUBk2PoHo2plfIBqi2B+q9nWiVISX0iD79+9QrGaFjSBa7i
         Xt6xSEMAt37+rjUyXqrcvMVrZsFwHq8mWeEeKr1DfIKlGtSwcHUQ3XkXSHZdEO7b+LSe
         xcjQ==
X-Gm-Message-State: AOAM533m+In+MVn16WoedR2/lxb3Vnx45ssrXOzD36JTIHw79V+9kzVu
        HotpJ2HLKHq73yLIibb0ZnRh2ndZ7PwuoOhWs/Y=
X-Google-Smtp-Source: ABdhPJy2wmamKFEISdZIBHXOIktyAL6xbdUy6ZjFm1+71zh7Z3gNdtDpRO2Ao4aROqAt0Ke2e5cQdF/gzrM06NpZEeM=
X-Received: by 2002:a25:3bd0:0:b0:664:2ec8:34c0 with SMTP id
 i199-20020a253bd0000000b006642ec834c0mr9713318yba.405.1654878894322; Fri, 10
 Jun 2022 09:34:54 -0700 (PDT)
MIME-Version: 1.0
Sender: adonald323@gmail.com
Received: by 2002:a05:7000:8b10:0:0:0:0 with HTTP; Fri, 10 Jun 2022 09:34:53
 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Fri, 10 Jun 2022 16:34:53 +0000
X-Google-Sender-Auth: UVE92oOY2IleWARACUtLEuZzQv0
Message-ID: <CANHbP4Ndqk9UaO-v-ft8wJdVqjoKBmgA3rVDPas-d08Dq+AM_g@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.2 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_95,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2e listed in]
        [list.dnswl.org]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9579]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adonald323[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adonald323[at]gmail.com]
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
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you.. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Howley. Mckenna, a widow. I am
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
Mrs. Dina Howley. Mckenna.
