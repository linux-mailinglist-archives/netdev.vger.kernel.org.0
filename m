Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BB9544583
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiFIIRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbiFIIRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:17:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF4F2D3B11
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:17:16 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u8so26964892wrm.13
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 01:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=0XYuJwlWcPhF5wKwZj6AX0M1ehVlcZ8wjqHIDg46ZGY=;
        b=AM0Ouch9SskiVkwlvSo46QPpB1USADN/fWMaPZpBNKvgTSiB4lUfzNF8Nz9rP0asNm
         WHuuWHvL4drWpFZcsaabaLZlpL0I6Dy6eJU1XtzWIncX1ZGpW2iej5fFJdDOiyVjugkI
         zZ74NAe6EZm1GIindkJAQlhw0nxoyxIFcxIMHyWdQVr5HE+IL6NAzcgoxx5SzfnaPz3p
         xaB76vcsoG9RX76Ejddm7wz9ELuRpARZZm2QeQUBu5Trut/c469LNqIIXEIPxMPV15Pn
         AyJcMd3eXE84lWlcOXEV8KZxubFb3iA3YFQC8y1BdldkC2KwXsaJ++HjZ7XkaZziO2hF
         nd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=0XYuJwlWcPhF5wKwZj6AX0M1ehVlcZ8wjqHIDg46ZGY=;
        b=ey0/FP5IPG5UXng/1rwSB+7MWF0fadxVoDKTzOhk9GzJ/R9QrDITTXsK80jYLtylpn
         zWZYT0tN9Ow+2SKB3u5sa2mcE1jdyU/pHOLZ9Ok7R6HEQYBfEWkQD32j6w57AgfkMOyA
         1wXvX0uv+8j/kXyreQelfZWCS3kSyMmyjCm9ed9gUHul8NacTBrIOT3iqfw9uXsDdUyf
         bqLy76X1beffKuAOg+o9t3YL7+tFazWpqVR8jN+b+1G/kOgbx+olVIM7h2w+QUnlMEzg
         jfzOAgHNCe0W71P1kkXi9vyrOVn92Hvl1DKazScqu8GuTIUWrZQxd68wdcowHFgDzgyW
         U3rg==
X-Gm-Message-State: AOAM533N09GuMI6/7pL9hycl1HJW9OV6zoxNclUIqFKX488YgTW/et/A
        jJm/URyjHbOsD23nDINLfixHoKdl+xrDN88WNdvOfDC9dU7I2Q==
X-Google-Smtp-Source: ABdhPJxCLtrvuGGqjK9MUEywc238jy6DsEdFup9DS+6ueF3kvAfOrN9QoTt5lwDxB8btTlDccRQ4V3C5S+pV1YN0Cz8=
X-Received: by 2002:adf:eb82:0:b0:20c:a2eb:5fe6 with SMTP id
 t2-20020adfeb82000000b0020ca2eb5fe6mr36973647wrn.563.1654762634833; Thu, 09
 Jun 2022 01:17:14 -0700 (PDT)
MIME-Version: 1.0
Sender: smithwilson780@gmail.com
Received: by 2002:a7b:c391:0:0:0:0:0 with HTTP; Thu, 9 Jun 2022 01:17:13 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Thu, 9 Jun 2022 08:17:13 +0000
X-Google-Sender-Auth: vhfy8VP3oulQVV2A1tZn2IguKj0
Message-ID: <CADh0myu-YTtmCwB_d4Kh1pxJ5uhkMQVcyg96A3pS7--vhMgYZg@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.2 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:431 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9314]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [smithwilson780[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [smithwilson780[at]gmail.com]
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
