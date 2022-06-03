Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD84453C9A7
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 14:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbiFCMCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 08:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241360AbiFCMCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 08:02:07 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E529B114C
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 05:02:06 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id l204so13308713ybf.10
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=PAoz7fLMQWBLCFW77Gt4mb4mt4paG6Gi3HmBwVnVv30=;
        b=ZV0Z94SQA8VGh0CD93CZooSl7Fu+Iwczz0viJVPGh7XPKg8G3/NnPcOyzA4mgv454I
         k8gzSnm/UlvIZdaEmChcfvUT2cb901xEv7f65YYtKLyrcBXutAnUPVArXT0ypuxJbM5b
         M0QJiP/nCXPxBIsZhiVewHqwLJIWEjHrUGW8uF2C79Lr7Nj/+KmHwvcJEHqlkDywpora
         +2P35F+5NDm1BqfZn9bejHXl9Z+UBPEd3cDypdpyRnKJXA+AV8BKS0xD1P+6xn+YcCpl
         WKi76ARU0TRL7qqXVwttzEzU4nR1gmEYFuo7+9/x6vGBPwmBqYp9FFizd3Qi3c5yJfIs
         6kGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=PAoz7fLMQWBLCFW77Gt4mb4mt4paG6Gi3HmBwVnVv30=;
        b=ex4vkJ8Mr3Xt69dM7NmOYd78CDmiHp0RGTOBrWEow6ctPMRlBimqADJN/9QmbrgBNm
         cBH62jX8CmnPwW7p4lnnJVKtKB96rSrh8v4orOGF8C94ySt4U4RFDQMtjraYgr4Q9XE8
         wdFY8Kh/UZ8gvBZ5NkLlxk7EEzzfZ+Paq8iPj1wEmYZB3CUin0MW+wcMt4Yv1R6MrSsv
         QcaN3wocYPlZJtYd8hPQXyUml+JjJiP3ECxcKKiHizSpNFJbbwnnbUEnpgQlUsZLnRYA
         y7BmJZN1hWe1LQADVA/hBGyeWOlLPOd9Hw9Jhj+UP636ZxhwDwbdgGEoinpdlr/vzNUh
         gAbQ==
X-Gm-Message-State: AOAM530167NYNLO5b2GmNoPHR8tnTxk+KhQoPZL0TP1+HBg9Pqb1b4BJ
        pzvgoJinnxOoNJNd+Q7HM6mhtGGIvlRePa3GlA==
X-Google-Smtp-Source: ABdhPJyrUN9kOa7h/LIcnC/q6gGKILQdM7Ml96dhd7XjnKc0UqxjcXUbBF6YF1ob3BUod5Lx9QaukJdJEIvbqcQYumg=
X-Received: by 2002:a05:6902:1506:b0:660:7df7:5928 with SMTP id
 q6-20020a056902150600b006607df75928mr3680183ybu.65.1654257726112; Fri, 03 Jun
 2022 05:02:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:7403:b0:2d6:8983:5632 with HTTP; Fri, 3 Jun 2022
 05:02:05 -0700 (PDT)
Reply-To: attorneyjoel4ever1@gmail.com
From:   Felix Joel <lindaorris300@gmail.com>
Date:   Fri, 3 Jun 2022 12:02:05 +0000
Message-ID: <CAABSo2HKniS1rW3soYRBUQEMTENFanM2mVabiOr3aLrhrdj5CA@mail.gmail.com>
Subject: Vennlig hilsen,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hallo,
V=C3=A6r s=C3=A5 snill, godta mine unnskyldninger. Jeg =C3=B8nsker ikke =C3=
=A5 invadere
personvernet ditt, jeg er Felix Joel, en advokat av yrke. Jeg har
skrevet en tidligere e-post til deg, men uten svar, og i min f=C3=B8rste
e-post nevnte jeg til deg om min avd=C3=B8de klient, som har samme
etternavn som deg. Siden hans d=C3=B8d har jeg mottatt flere brev fra
banken hans hvor han foretok et innskudd f=C3=B8r hans d=C3=B8d, banken har=
 bedt
meg om =C3=A5 gi hans p=C3=A5r=C3=B8rende eller noen av hans slektninger so=
m kan
gj=C3=B8re krav p=C3=A5 hans midler, ellers vil de bli konfiskert og siden =
Jeg
kunne ikke finne noen av hans slektninger. Jeg bestemte meg for =C3=A5
kontakte deg for denne p=C3=A5standen, derfor har du samme etternavn med
ham. kontakt meg snarest for mer informasjon.
Vennlig hilsen,
Barrister Felix Joel.
