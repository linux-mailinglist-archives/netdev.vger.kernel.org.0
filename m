Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B62546804
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiFJOEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiFJOEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:04:38 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A8195BF
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 07:04:36 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id y16so20954948ili.13
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 07:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UhzQ8TCLc8aemqWVBrVPCVsWAXJJAEoAT5VE2jsbIco=;
        b=kkA4w5DdkzVaH4HFt2qLl9iliKMbI4J+ud2iZdWa5MNLdZLmqv8oQN7vsPE2wnecWe
         +zorWBHkkAPqvlzr/fRxgQ6SCgwWLMVF5MELlSr8/TtmS5mwfBChbNL8q286m79LX9wU
         IPULAju7cauN59HSawyj9GTeyUhN/Bw8FcnfB+F/ooFNiTBkOAl5ZAt3O8iQMS/6vGE8
         PvvwYjVXMaL4xXyvyQUO3J0Q2Yew8WrfzuK/Xfy3hzL/pMspZg/eb4BowGt4G3xi+nAJ
         sBJl20p/gUKORMXbi7gr31rO5WbDPiy72f2/I21ard7pChd2SpkiOsiU9RohDo+uTutO
         ibsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=UhzQ8TCLc8aemqWVBrVPCVsWAXJJAEoAT5VE2jsbIco=;
        b=OxNUoOoxGYrJXk4CmIraO4ALtW8XVTi5peQLd/X6S+oe+tIdPSp+F7xPmW6Q87Ll7A
         HhieFn34zuox1dTgSAvAHpaVYWLuJJAlYq/DpgcgxTZP4xqoQQZSJbtKLkcmWNZr2mxT
         8ew8+GL5tqqdf+xTotoP/UCSXx3mtXePibIHY78dk9Y/Gny9aynZSHb1dquyHsMzykPO
         UYNxXm5IRWDxBajAOPcDlsnPttDxnbYVo3AzGbLE3ppdsCrLzUMOYoqy8CMqMgiMDVA9
         G1boTfOqYIt38iz03uIj6ZRlsDGqavSyQgJYmlcy8tc6th4qPWuzn03B0anIn64B0ekK
         gmPA==
X-Gm-Message-State: AOAM533X7cx5dLm14H6IowS26dGJAxFLRsRr4+ruW6Jx0GaoAvh9Ha4F
        cUtzXQTSWPyY+e4vwFL0scEWwoMpAXswtK3kj64=
X-Google-Smtp-Source: ABdhPJxlpUA4dB+PoX5o0gy4wdPDFCXVifhTIpfxBGSrnbctL8Fm/vS9uJxmJbFSPMyVllysh97Je4nc/AlnBQTrzX0=
X-Received: by 2002:a92:cda6:0:b0:2d1:bc06:1d9b with SMTP id
 g6-20020a92cda6000000b002d1bc061d9bmr25833295ild.16.1654869876395; Fri, 10
 Jun 2022 07:04:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:d613:0:0:0:0:0 with HTTP; Fri, 10 Jun 2022 07:04:36
 -0700 (PDT)
Reply-To: howardnewell406@gmail.com
From:   "Howard F. Nwell" <ayoubasadou292@gmail.com>
Date:   Fri, 10 Jun 2022 16:04:36 +0200
Message-ID: <CAC=+3ucq8szoL-SeveCbxX1_Y5LQyEVRjBN889uznmJsce-JEA@mail.gmail.com>
Subject: RE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7050]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:134 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ayoubasadou292[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ayoubasadou292[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [howardnewell406[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Ich habe Ihnen bereits eine E-Mail gesendet, aber noch keine Antwort
von Ihnen erhalten.
Vielen Dank,
Howard Newell

mailen Sie mir; howardnewell406@gmail.com f=C3=BCr weitere Einzelheiten
