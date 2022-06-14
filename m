Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D537454BD0C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344708AbiFNVxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiFNVxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:53:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E561902D
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:53:10 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h5so12993995wrb.0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=kLf57Tpjp3cAr7DQ8FxGnPCa1UEL1ZCvBKa8SNzGeS8=;
        b=nX6F2X4bN/cvar8C/8d38hStYgllTGLjfPTjvOJywyQ3OocphhDt/9pLOYH68ikvLU
         8f13tgZexrNSyO5cqdDLPwvjZYcTmjtZXqBF06eFULCPlUoGfNXfEmNbgp10Qer3q+cX
         guXTUF+Xgy4t0qoenyYAW24PiYjHN21n43iyHcsZ0+jdFbWFh4IIvjqHmMs+hOtZPdfk
         q3RZUXPwm5PxhjEEB2jtkmE7GK3Cd4kRyqNgro5MTzJhGDzByHnwAig7z1M5gdqsiDQl
         hAzudHDas+sSd8dJmpGVu/Ops1vzM2cThNXArkUFcW1i/MaEnBelTPUFkYWg1YOq0hbB
         35vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=kLf57Tpjp3cAr7DQ8FxGnPCa1UEL1ZCvBKa8SNzGeS8=;
        b=x9I/2n7plg0Lde7cdBm4MfX+4JymfimrSRNIlnMhLsVUsCWRDA4RCBDF6Odhir1NEF
         WvfyNm/ijns62jqzIXG1YB16nq9HRielIHSBVKr7DIDadn2+CL6XepNqGBTFeLEdj3o6
         08Er/k5gC/8FtfJZ0WLHqJ7PncztM7Kqko8kgLV5+5Nnb0biBVLSzUg4LBdL9ofpb+i5
         7UzjMqymSii4Gkc5NwW2oODETXvtj6miEtDzUQ/an0RAtcchdte8si6lqmL2Qs/rEeZH
         gQtekL2b0v1BqwA5BToVEanTPY0dz4XC4l6aebl56rC22czyPHYaeEEZFPRE4VrAxYeC
         73Gw==
X-Gm-Message-State: AJIora8bHNdIhByspk9FS4rDiximZkbeB5ylLhW3MrwezKUk68pgrFEC
        /KhUWonutwNwpBNr6ZXFBOswZWlZlfo7Su0uevY=
X-Google-Smtp-Source: AGRyM1uM6dl4yrezmZA/SMbRxxYVgXewgdCBkWFTAs2fZS/cMP9RMcLnngQhn1wGkF2iz7nA15JrcNJAI5z+0qU+344=
X-Received: by 2002:a5d:6192:0:b0:219:aa98:897b with SMTP id
 j18-20020a5d6192000000b00219aa98897bmr6629604wru.341.1655243588762; Tue, 14
 Jun 2022 14:53:08 -0700 (PDT)
MIME-Version: 1.0
Sender: mcinnesdonna05@gmail.com
Received: by 2002:a1c:4d1a:0:0:0:0:0 with HTTP; Tue, 14 Jun 2022 14:53:08
 -0700 (PDT)
From:   Jackie Grayson <jackiegrayson08@gmail.com>
Date:   Tue, 14 Jun 2022 09:53:08 -1200
X-Google-Sender-Auth: mmQbYhC0VHTt0UKP9OMhv8zRlQ0
Message-ID: <CAK+X-7UXnMm4mK0x05wkcAYeh_9+VqGmOUOt3JudbbeRg3RJfg@mail.gmail.com>
Subject: Greethings my beloved
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gooday my dear,

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
Best Regards,
Mrs,Grayson Jackie,
Writting From the hospital,
May God Bless you,
