Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA8B6D28BD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 21:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjCaTlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 15:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjCaTlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 15:41:20 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896972031B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 12:41:19 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j11so30270699lfg.13
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 12:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680291678;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TnELEkkU0k3B8aha6G73Plasv6HbiFbmUBX3+pFRiNs=;
        b=Ja82MXzLAJKyZncquX03HtqcPUw0yMFkNh8rc6zlbmFET7L+xDcehd+/66vlQdF/GR
         eXcz/HiggzpQEysxEcAoS9gEkDF3yjzNbVANda6D9HAbRb53CRYZ0aR/gjDiBCpVs5r3
         eZQr9MxqORnkSwRE2vMybOHB8hXrbxdLTypmW1krHfQHTlKPsRsRvYkPRtbc9CdwI5Nv
         fh93PxS7di7VniTAmFzQX8WPB1XS+8t7BdUWEN7b5gH8yr1l7z49zd/ElFgZwASxshcC
         w1M38CMngtVgS0Xb/N+JbsgUNNc+BJQXuZnf9UZIcACbbDzbE3bbz4jMODt9UDegvttd
         DqvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680291678;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TnELEkkU0k3B8aha6G73Plasv6HbiFbmUBX3+pFRiNs=;
        b=SSujAWP3ahDV7B8XY1G7w4FcLFQ8N099qzH1Z1OdN7LDCRa6YLAUyrQF1xADkzgB9l
         vPZGO1WtV2pD1GAPJC3jg5zMhFu8PpOTNnwtI5+XnsZCHBndibuQcx822GjdTfJibRu4
         lF+ouH2lwn4vTqxo09wnJA3meDrPz50YTAbGfclQNAFaDGcDjPWRmmAzU6B+z6NB04Rh
         AOfc23Rm85N+Am8pT3wJoCgTrb2uenyUNRC1NshDEmIliV2AALgzALkFyaLM02SO5FTf
         BmpD0KvVxmIdaSdDeq3Z93/t3FvwDxt2l+WCN66p2zGHGDgMeRlP3KxVu0ks5AGoGLLE
         Im7Q==
X-Gm-Message-State: AAQBX9c1sWGhMe8AnwGPIKSZ5as9SO4WzhLXLYudhqK2wZJDHuMQ+z1r
        nG538m1GTOlP8ADCWsJPAr/nOkz8vp23wvyHb9Q=
X-Google-Smtp-Source: AKy350ajE23rwmuo3sirW96HA/vaCQonIgOsJEAqbCFd9fKciJ+Gq4pavXGVFTaDC+/hKGORTOMfBJcmD50PXtm5400=
X-Received: by 2002:ac2:4434:0:b0:4dc:807a:d140 with SMTP id
 w20-20020ac24434000000b004dc807ad140mr8303586lfl.10.1680291677720; Fri, 31
 Mar 2023 12:41:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9a:714c:0:b0:24f:3288:af6b with HTTP; Fri, 31 Mar 2023
 12:41:17 -0700 (PDT)
Reply-To: lisajon1237@gmail.com
From:   Lisa Johnson <02mshelby@gmail.com>
Date:   Fri, 31 Mar 2023 20:41:17 +0100
Message-ID: <CAC0cRmMmKY8QeNbOEPJQ4m20GxuAxEiQBdz5bRyp0mTyCoykEA@mail.gmail.com>
Subject: Kindly Respond
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

My name is Lisa Johnson. I sent you a letter a month ago, did you
receive my previous message ? I have a
very important project I would love to discuss with you, Please get
back to me as soon as you read my message, So that I can give you the
full details of the project. I have
prayed about this, and I am doing it with all my heart.

I await your response.

Best regards,
Lisa
---------------------------------------------------------------------------=
-------------------------------------------
Hei rakkaani,

Nimeni on Lisa Johnson. L=C3=A4hetin sinulle kirjeen kuukausi sitten,
saitko edellisen viestini? minulla on
eritt=C3=A4in t=C3=A4rke=C3=A4 projekti, josta haluaisin keskustella kanssa=
si, ota
takaisin minulle heti, kun olet lukenut viestini, jotta voin antaa
sinulle t=C3=A4ydelliset tiedot projektista. minulla on
rukoilin t=C3=A4st=C3=A4, ja teen sen koko syd=C3=A4mest=C3=A4ni.

Odotan vastaustasi.

Parhain terveisin,
Lisa
