Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A465A502C8F
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354981AbiDOPY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346003AbiDOPYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:24:25 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F10C9B57
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:21:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id t11so15823577eju.13
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=OM7czSSBk8DIcjh8XMXqqgwBEfyElgqMFVAC0oDkqWk=;
        b=L/Tjh4iZ0xM2Ogesb0f7cnaPUb/SEnE2F1vLOwORXqTuMZxlPRxuManLbjARGjBZge
         8sdTt4Lnl60c9Vs6KrQ6wD2yUf+uVK28FZmEUzqd+tOJ083TmGH6V+FSyop+JybyGqUq
         wJyR94W83kRK9SmhYrXBVnqWPDg02lI5xTq5/UE6GVc6QyK+cRIsmIHj5FCuqBIyCDWq
         P4GArECO9xO48Ob26dPmDBLz6jcafrURHqA21r71RcI2Im8SOGkv/lAA50c31sy1Hzz0
         sj+PWK33fXkS8c3wD72eFkNi8GozPwobPchP/ugLiOk7zq6THoBMqowSAIHLiBSI9UKw
         ckxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=OM7czSSBk8DIcjh8XMXqqgwBEfyElgqMFVAC0oDkqWk=;
        b=QA4mWLc5h/s9NTJDO5Jdp83pQUWRxTJjk3HBVzvIfJdSssVd4nUhvYqaXhH5ScvKiB
         DNxFDIDDipl8MY906ivUx+zUZQ951VfoWv6H/JdhLWZj4IuFUrNdDRnAuNbKol7F9KCi
         lVzWVUWXyw3OdXhq0LHrjt3IfeaWug9CEqlLSDt58kIYDGPaSqCPHYLe9stEq5MgGEX1
         fo60Xt4DDe0RhhuJgtQtYZwTv4Welyz9ij/EexJSjGmuUFpyWFnnfs8HWGkZ7VIdHra4
         GHwpBaCqAO3DB6zOZBPhmHrUerRxm3jE6vXfcI/eVuunUO+wUi2qkalRLd4HtAsDBbMG
         qmlw==
X-Gm-Message-State: AOAM531UvV8+NzTcshAS/XakX7k5I469AiiRbi1c8hLTwRZerICfLr8g
        FtOHoV2Fep0MMiDHPaJA1uA9xzOxVwJWTtF+YdY=
X-Google-Smtp-Source: ABdhPJzoSC1Ot+oJGzvL9eZG1+UO4dm0TMhBoeu8xaH2k2PZ+vNWLHrl1+VXjUURGQp8lSyK3C+1ZdRq+3e347IR7fo=
X-Received: by 2002:a17:907:86a6:b0:6e8:d649:5e05 with SMTP id
 qa38-20020a17090786a600b006e8d6495e05mr6514539ejc.705.1650036115901; Fri, 15
 Apr 2022 08:21:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7e86:0:0:0:0:0 with HTTP; Fri, 15 Apr 2022 08:21:55
 -0700 (PDT)
Reply-To: robertsodjo63@gmail.com
From:   Roberts kodjo <robertsonkodjo01@gmail.com>
Date:   Fri, 15 Apr 2022 15:21:55 +0000
Message-ID: <CAOpP-mmQvOj4kv3L8ki-p-9uhyst2uYXB4NOLsAY5E2usRuxDg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,MIXED_ES,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:634 listed in]
        [list.dnswl.org]
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3466]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [robertsodjo63[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [robertsonkodjo01[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [robertsonkodjo01[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.9 MIXED_ES Too many es are not es
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hell=C3=B3.
Elhunyt =C3=BCgyfelem =C3=BCgyv=C3=A9dje vagyok, aki olyan fontos =C3=BCgyk=
=C3=A9nt dolgozott,
amelyet meg kell besz=C3=A9lnem =C3=96nnel az elhunyt =C3=BCgyfelem, a hal=
=C3=A1la el=C5=91tt
8,8 milli=C3=B3 USD =C3=A9rt=C3=A9k=C5=B1, nem ig=C3=A9nyelt vagyonnal kapc=
solatban. K=C3=A9rlek =C3=ADrj
vissza =C3=A9s v=C3=A1rj
Tov=C3=A1bbi r=C3=A9szletek az =C3=BCggyel kapcsolatban.

Roberts kodjo,
