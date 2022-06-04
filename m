Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125A553D63E
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 11:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiFDJ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 05:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiFDJ0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 05:26:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CFACB
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 02:26:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso13875033pjl.3
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 02:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fyO9OaANfvBBrKAbHvEP8A5701DEFNGjeZ7FhKJ0lcA=;
        b=Dt6/9lhl3NnXAs9oFD9PFfcqxOY5xcpq0mBVZkh0lQfKMikT/HoflX30wCjDsca7R2
         9zUqCknn0AWKmJ15Hp/IBj0PmqLetGC+HAL30hcMIZyWhLcYtZRpujT1ybXIB5TuZTqG
         g3YDdFjsqsebfzJF+4dapRrcHFBHPm+VHgwz5qoTybkmlNn7KyfYoMqmLFyFXGX7+6EH
         /9LT2JDXnluj9C5mEpEaUibhyO4Kj5KYeGVcU34pvyimt8oEaV4gDKRESAbob46sK82/
         oPcneyVnJnla72gCygHYVJOQeuX668RH2klgr03eIXTbkgpz2OoSFD/Rj69R9skyQpvS
         seeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=fyO9OaANfvBBrKAbHvEP8A5701DEFNGjeZ7FhKJ0lcA=;
        b=IQzjw2uXN9ABlBoQQhwAxTVf6dCJEGOnqhgmkAof6hm7wgpYJWz1zbp55wlSQmiwqb
         OiTl5zuR6oc/pWBmgqnN68xBtndEXADBdQ6PIjwTAxDBYw8+sfV5tH/gWdO7BN5hGmAY
         xt+/LKTpHD1coGrJsOKgLxOeNhOkwmH6DCckkxDfktaKYJq+pyDlmZ72tlUeg6VZpqiZ
         Yrkc8PrV/0PkqNgKpvT46k4T1X17ozCpE5NISIO8X4DahRDswQJkl1iOpYJJyK8dYTWg
         dnN0qgFrLpNS+uXFZmCT/JPK7yaS6smUTnVCX4KUTr/HoVZyjnfb86VyhLqKiTtxG6y/
         5KDw==
X-Gm-Message-State: AOAM530VPuIHeIRM/SiMSzEFRxIPd9IMAeRbadjm6bNPu3hr5pkIfhx4
        qexuWaHItEBxuAgJNIFPNIqcvLdTM4KYV9mOnRM=
X-Google-Smtp-Source: ABdhPJzXhY2sspnZ+dgQe0DEGQmExkvbwVGM7H2imjmAaCNjHtYE05atlzi03R9twPB1ioo8mv/NDAgvs7gA4BoVgoY=
X-Received: by 2002:a17:902:bf04:b0:149:c5a5:5323 with SMTP id
 bi4-20020a170902bf0400b00149c5a55323mr14034748plb.97.1654334809884; Sat, 04
 Jun 2022 02:26:49 -0700 (PDT)
MIME-Version: 1.0
Sender: jonahfirst45@gmail.com
Received: by 2002:ac4:8486:0:b0:4d6:fb53:83df with HTTP; Sat, 4 Jun 2022
 02:26:49 -0700 (PDT)
From:   Jackie Grayson <jackiegrayson08@gmail.com>
Date:   Fri, 3 Jun 2022 21:26:49 -1200
X-Google-Sender-Auth: 5EXZWQWkZTvMsy8Hc6fuKRUSobQ
Message-ID: <CADG_itPa7nFcG12n4X+2r0oZs77WHpEmpS+Be1RTpAbcrqHE4g@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.8 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
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
and glory upon my life,I am Mrs,Grayson Jackie,a widow,I am suffering
from a long time brain tumor, It has defiled all forms of medical
treatment, and right now I have about a few months to leave, according
to medical experts.

   The situation has gotten complicated recently with my inability to
hear proper, am communicating with you with the help of the chief
nurse herein the hospital, from all indication my conditions is really
deteriorating and it is quite obvious that, according to my doctors
they have advised me that I may not live too long, Because this
illness has gotten to a very bad stage. I plead that you will not
expose or betray this trust and confidence that I am about to repose
on you for the mutual benefit of the orphans and the less privilege. I
have some funds I inherited from my late husband, the sum of
($11,500,000.00 Dollars).Having known my condition, I decided to
donate this fund to you believing that you will utilize it the way i
am going to instruct herein.

   I need you to assist me and reclaim this money and use it for
Charity works, for orphanages and gives justice and help to the poor,
needy and widows says The Lord." Jeremiah 22:15-16.=E2=80=9C and also build
schools for less privilege that will be named after my late husband if
possible and to promote the word of God and the effort that the house
of God is maintained. I do not want a situation where this money will
be used in an ungodly manner. That's why I'm taking this decision. I'm
not afraid of death, so I know where I'm going. I accept this decision
because I do not have any child who will inherit this money after I
die. Please I want your sincerely and urgent answer to know if you
will be able to execute this project for the glory of God, and I will
give you more information on how the fund will be transferred to your
bank account. May the grace, peace, love and the truth in the Word of
God be with you and all those that you love and care for.
I'm waiting for your immediate reply,
Best Regards.
Mrs,Grayson Jackie,
Writting From the hospital,
May God Bless you,
