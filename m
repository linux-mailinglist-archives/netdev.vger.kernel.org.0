Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EBB5BF0EC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiITXPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiITXPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:15:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADDB5F98F
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:15:47 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a29so4171253pfk.5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date;
        bh=GKgbEnPuOkhLoyrFIWL4BfDVBHKyqmvpgN5Se2JzfVY=;
        b=h7f/IG2sWm8Quc+bXSVXDFqe9aE0mgTcqH8bPR0X7zJXtfppvUXk/Vu20///U64kmy
         NkIXBcOzfGS4UgJNqV/hrFjCk+B1scuAZC4M1mbvleT2P+LjqMJcKSf2AVux29FwDn5E
         xxVeiK+ayz4Au6wbCUOd/I8P0pEXvqcl8momPyHKhC1V9VvyvcQLUbS1VbZ5XNhzGMGf
         8EvQIvGonWw3uap60FmmOFbUYSiAthl7pLJn15v1cUkCrBCDGcnfqiogEJ9rRnPboyXm
         MqCZS1g6/kRh5UwGCWPJ9HMF1zgZVIfSwdcbFmZ4vjvIUyZJbZd6k1/WZt0MwvW1zkFv
         2sXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GKgbEnPuOkhLoyrFIWL4BfDVBHKyqmvpgN5Se2JzfVY=;
        b=5CpJJKdTvvB6RytAFg5z0+oyPc2y8yInfPxLmwc3WH92RPLfIXJK2eMvlvRyxSG2CF
         JWgQ1KhJcwasEdH2EJBifwqCWB8ldwDsFBHkXceZ1Z4h8q3AlYP3AAEFUptSceoUpzHy
         qht3u0+2RZnZtfL7RauAVSZm6PlTr8RY7LDRkZEdqHeK+J2D3Ti8KAaeE05mvow3Laa9
         7PrjYo1FXJJJlLBRwmRc1+uVBdm74mDWk5CSZaKQSYKtcbhpVMKkAu5e2EOFg/JOGoxP
         D3MTrq1L423snl8p47ycIEVDBX8PBfX+IzNREP6WF3+badmlXMJFmPykVBNCnBbcmK6A
         Lbxw==
X-Gm-Message-State: ACrzQf17XyU/+/Sb92oQFH+EFse9IT/X+wvRqCKYunm0OAKRvp/4GItx
        keKtp+hE/edo9RRYlgj4rVM9J9p4g2uKhH1nWTg=
X-Google-Smtp-Source: AMsMyM5xWl2hmDTMPnYk852Jw9hzn3xxUp8x8mgl3q110PcGtO64n9AynRqPR7hG908OIUOLDiZThKO3HXE+e5n/K9c=
X-Received: by 2002:a63:5246:0:b0:42b:e4a5:7252 with SMTP id
 s6-20020a635246000000b0042be4a57252mr21600188pgl.566.1663715747041; Tue, 20
 Sep 2022 16:15:47 -0700 (PDT)
MIME-Version: 1.0
Sender: kassegninkossi77@gmail.com
Received: by 2002:a05:6a10:4b0e:b0:2f4:2c65:73b7 with HTTP; Tue, 20 Sep 2022
 16:15:46 -0700 (PDT)
From:   Miss marybeth <marybethmonson009@gmail.com>
Date:   Tue, 20 Sep 2022 23:15:46 +0000
X-Google-Sender-Auth: rE1FVY7rR5391gmkP8i93LeQt9s
Message-ID: <CABZ=a7LygjAyy3YgmS-ZNc5yVKmzPtw=vzsEwwwk+ZnXsBD4Rg@mail.gmail.com>
Subject: RE:HELLO DEAR
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hall=C3=A5,

Fick du mitt tidigare meddelande? Jag kontaktade dig tidigare men
meddelandet misslyckades tillbaka, s=C3=A5 jag best=C3=A4mde mig f=C3=B6r a=
tt skriva
igen. Bekr=C3=A4fta om du f=C3=A5r detta s=C3=A5 att jag kan forts=C3=A4tta=
,

v=C3=A4ntar p=C3=A5 ditt svar.

H=C3=A4lsningar,
Fr=C3=B6ken Marybeth
