Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F4655AB5B
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 17:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiFYPkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 11:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiFYPko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 11:40:44 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B4515A2C
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 08:40:43 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z13so9291379lfj.13
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 08:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=bI751YOuP98wHh1q4rHO/ASQoCAvLeM/hP1e2c0DqAE=;
        b=SkYNZJw4GoZ3tDv7kOU2ZQN6l2TY4n56+yVteETy/z76+J5BoMKPI6hxijuh48gR+8
         0ECizucx/uzETm2am7tQ9WayTg4t9Lh0K193ngwyMSvmCr/0CdAMcl6+9uC0rUml38Ht
         by/Su8tB+dVL2XOmc0ZGzERhk5ic19aNlX6nM0YFuopVleIrJQgtMD3ff/AhT9dlO0e2
         /2Pqps9BhqfQdoRjmFsJ4isPmpnjkAZiANiRdHYNQ+KFIpOynjEk0+T1GLD6S6MBqiO1
         cZQflq0spuOtaPudXEFMdQmGNOrBHwz/UfOvsIhN1DWfjSXR9RQW8T3mGLPlIrd/YMrZ
         XkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=bI751YOuP98wHh1q4rHO/ASQoCAvLeM/hP1e2c0DqAE=;
        b=wMuh+tCDf/IyMG8c2OIMmBwcI8S+hOtTqF9iTCmvIQI58Af3WWH83E/c5Lw8IUq9CA
         pUUQZIzjIoMHSA1vAGMtzH133fuIVasCZKULyqy0ZBjQin344x0L0c7rcdWSeakussBY
         fjLu6FvkxZx3GsICP+j+Vo3AAQakG1gzHnOtmzI+PrhQLxh3qGTcD7ciKDf3Uk8MPusR
         AS+O89EOxPnK1pWpxlbOeLviDBUNcaCYnKz0nrb5sw4aLkYXHGn+itfY4NULsNgWvB20
         te7EKEWN9miRLvWtkiPEO5PIzZQZ2VWSqEmd8sTe8zVBYjtsCSvOcuD1lT77AxIdWO2g
         WNZQ==
X-Gm-Message-State: AJIora8Tive/duqNj7OwSD/+phoHMcDaA3PiDv4gSubnbmjh3Hnyz7CG
        TFdgA5NDnRIAMQ9gv0eFLj75pe3byK1+9jzINCA=
X-Google-Smtp-Source: AGRyM1tfE/NATW2Fswjt1P4LWPJs1+ec+H7R4J+s639rswSr4n7KiM/+FsOEs16fipxyfvIotEVDadEWk5C7AgTym20=
X-Received: by 2002:a05:6512:687:b0:47f:c1e8:522f with SMTP id
 t7-20020a056512068700b0047fc1e8522fmr2754592lfe.122.1656171641456; Sat, 25
 Jun 2022 08:40:41 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsaliceragnvar@gmail.com
Received: by 2002:a05:6512:169e:0:0:0:0 with HTTP; Sat, 25 Jun 2022 08:40:40
 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Sat, 25 Jun 2022 15:40:40 +0000
X-Google-Sender-Auth: HNRzpEmbFBnEUq3fX9WRPgtj2j0
Message-ID: <CAGHGhXDAY2x4aZn4hHjiE9tMyCiMHtasSewTW1WXNwaB+-u_dA@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.6 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12b listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8650]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dinamckenna1894[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.6 URG_BIZ Contains urgent matter
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear.,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina. mckenna howley, a widow. I am
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
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars
).  Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for..

I'm waiting for your immediate reply.

May God Bless you,
Mrs. Dina. Mckenna Howley.
