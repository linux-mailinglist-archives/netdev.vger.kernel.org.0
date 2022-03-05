Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0274CE3AD
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 09:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiCEIu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 03:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCEIuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 03:50:55 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D96C6C1E8
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 00:50:05 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id x17so672731ljd.4
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 00:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Qa5rECKJvlN1nk7iVriL5WpIcIm5alEZ4N0q0BCHVmc=;
        b=GdUqEVGwHt+anTeaib4qLm/X/bCI69ZZcsxP1CnEeFgmmC1a1E4DNTzN7rLeUSagtu
         iZl44jqq9tJ/5k3SP8zDqv2fNJIf1tVh4ThMM8MDQUs56gGa1HYMqItho/pH7s4jewb6
         BNaRhKVykHYk2gnEyraJnk+pwU37LNlskSlbxJbntdExhkmy0BLQ8ZlcqTUaGAoZrg/w
         DuOup4pAIkxhcubHpLI5wQixaC2q9W/NErZXNKLONRLq4KP5qWChOACk8ErdH8tfSheL
         0YUeCPK+2vCXQYLNtnF5x2hJcS076fcwaKFcZ+TtHLHZ0iv3HlR3tyQrHW6q6z2Z2iA/
         qa5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=Qa5rECKJvlN1nk7iVriL5WpIcIm5alEZ4N0q0BCHVmc=;
        b=Y0K1yfIrrnYNo4JRA/6gC/hQUxvQtqApCCjNAM6rO3ZSPZpsvgZhx/vm1q6Ye4DIFt
         zGOmUpFSK0h/85V1pEqeUeHdFG8nsVvQrhK1XIROEnQV0eNuIIy4xFtpM2fi5cKH52SO
         5PfPa349vT9RxqHB34JtsPZKNqF5zdAgEodqSXY2Nab/+/UoCAKZ6WZ/8uFG8AEFZked
         6adNaD2teocQsEbyKN06CZSfZ+iqxg0ikn6uIMEB8cXq6mejhWF61fn/8nZN3FhL4fvA
         g1odOz1X61/7469wQ2HmGewJRe5EZgsn1iLBLAHbYKXyx9A/LruwMdd3U4e4z4sshsmU
         ODzA==
X-Gm-Message-State: AOAM532X3QKSmTjeLckwmjyJvPJRLNVn/iTOmilYpTrbwdtK+1Imxne5
        SWYZ8CXn+whUCGAho2Bt1xraTxDxvlLJqelcPic=
X-Google-Smtp-Source: ABdhPJxvhuDnKd6rKf7/HV4vA5MEMUUWgEIV8FrBYmdi8VmIuIH3YyzTw8UHF16bzW3Ca1steYH5fTB7+zYBUCor1qw=
X-Received: by 2002:a2e:9d83:0:b0:246:2c6:79df with SMTP id
 c3-20020a2e9d83000000b0024602c679dfmr1529696ljj.280.1646470202382; Sat, 05
 Mar 2022 00:50:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac2:4c45:0:0:0:0:0 with HTTP; Sat, 5 Mar 2022 00:50:01 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   Orlando Moris <aliroulatifa@gmail.com>
Date:   Sat, 5 Mar 2022 08:50:01 +0000
Message-ID: <CAGEh6rp8rxE0rNadxZL-PjOg71BVe66nLZLEZA5JJBQoFip_EA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tere! Teavitage, et see teie postkasti saabunud e-kiri ei ole viga,
vaid see oli spetsiaalselt teile adresseeritud. Mul on (7 500 000 $)
pakkumine, mille j=C3=A4ttis mu varalahkunud klient insener Carlos, kes
kannab teiega sama nime, kes t=C3=B6=C3=B6tas ja elas siin Lome Togos. Minu
hiline klient ja perekond sattusid auto=C3=B5nnetusse, mis v=C3=B5ttis neil=
t elu
. V=C3=B5tan teiega =C3=BChendust kui lahkunu l=C3=A4hisugulasega, et saaks=
ite n=C3=B5uete
alusel raha k=C3=A4tte. Teie kiire reageerimise korral teavitan teid selle
viisist
selle lepingu t=C3=A4itmine., v=C3=B5tke minuga sellel e-kirjal =C3=BChendu=
st
(orlandomoris56@gmail.com )
