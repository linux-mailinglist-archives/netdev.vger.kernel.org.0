Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB77C581AB6
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiGZUIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiGZUI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:08:27 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC3A32472
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:08:27 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id v5-20020a4aa505000000b00435b0bb4227so2871875ook.12
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=EyUGrfXD8vVWp0wY98433bdQgm7afGutXPQDX571auhanceaKu7Jeo1I8s7uigU0zf
         +m+REpN0auVQuB5Qfj6oJI6WraQmMc11LeqgS5tcNkr7+0E2BnUYDurrYXu0gzE8MCOX
         X5iwSifyhRNE2eJaaAshubFrjGaMBAuo6BgUHecgjNeJsymWP1w+75Kd0mREx30UD/7M
         XVftmybgWv1Q8O1AZc0qCtNkhGahTZCNTd5oGUKTu3tH3qm916pdeSpVq0mgPFHbrBuv
         l/QJVxFsT6St9s5NP6Oug3bUppPCcH/IAt63IPhA1LK327whLY/9p6K9Ury0A4F1R3dO
         DPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=r8N3WOZKWuP6ut7TRKiiNL2kU1M6Umc205bNL4MhY2zTWpK1p7hOozEdznpqW35nfM
         K2FDUR6tMYUQTuZc+qIRvU8ianoRlaAkCuTJ8a6t2tasO6nB2iMWMS323JVCvKq4mGGK
         DE45De3w9hDi+Gq1PBnYDPRgHyGsfMJuxLARxY0nSoXTdOPLP8JfCx0l4sFJs9Yr9WA0
         TwBtDV8F6xL43ekuUszSPfq+et1Zkbh3it1UJXm9zENNhRUm5ymYhOrNtaVokdtAIY5z
         E7wpREgvWo3/rbfVLN1ql/RdBxwDiEMRC+1iiuY5E8l7N2IxtdDi4ifSNyVipG2uM1C6
         43zA==
X-Gm-Message-State: AJIora+AVJ+EMRs3eCHpu6HvdEF6AOsga/OYSsliHhwr4l4EeMu9WT+4
        IT4y226yBU3KtwaO5nyKH2YnHeTG75ADXQAsO4c=
X-Google-Smtp-Source: AGRyM1srkLVZamBYQ9z4dfBPtWe+g4lxI0ahqFma0atLYfcyWySszs+mqLzn3RoBBGHF95WMUO1NhxybA+voIH3ySfI=
X-Received: by 2002:a05:6820:514:b0:435:9b97:b818 with SMTP id
 m20-20020a056820051400b004359b97b818mr6486270ooj.32.1658866106386; Tue, 26
 Jul 2022 13:08:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6830:1e3a:0:0:0:0 with HTTP; Tue, 26 Jul 2022 13:08:25
 -0700 (PDT)
Reply-To: demirkol.m.sadik@gmail.com
From:   "Demirkol M. Sadik " <demirkol.n.co.chambers@gmail.com>
Date:   Tue, 26 Jul 2022 21:08:25 +0100
Message-ID: <CANvkXmEMEkC+3sSacrk7SCgxMVcKLeP=D0uDW_2WiT+DN6CKFg@mail.gmail.com>
Subject: Hello. Attention please! I was wondering if you got a chance to
 review my previous email. Thank you.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


