Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F2E642DFA
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiLEQy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiLEQyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:54:07 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B727F22B18
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:52:09 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id h12so19491287wrv.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 08:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=Nz/XnD4mcDMeaNKvgn5SepSfnKJynYd26drKZSYqboxpk0mcd5h0M5MWDmG0I6FZpn
         IDHA769G80+cd5u+Zmqekp0R+NXf5LmZJoCZp0XK9jx9VuYwYzIBi9xIOcbsDhGcj1Pd
         krbFHXqclLN1r+Mayn+BE8R1gjyDOEq1MV+zAzEOuiJb2YIVnc0t4nb3usZ8uGjTI8dK
         sTtdgIyfCKkSC/izZUcu4RvsFWLjjxaW6/ss6MJiX4bftw8G0RLiZM/3FaLSeqdFHXvz
         CxmS2PE0me5rnl9OcIWiGt6PsXvvY6NLNJhtRhi6ylB7pXoTTttlwIidjvVJzd7lc8L1
         jryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=zm8mYPUIfDdQtIPChQmk/qFmuNBP+Zdq2mJF4b7mH3Yxx6ka9UFMxf403nZRs5Lsk1
         EWuGFvjeIsjreio4AqlZF8iZ3pKTH1ArJtQ5upq39tQnhG+ZDE2ZKC5fN4p6y+6Obdfr
         ySI0Sq866epICHOohmltdqRMODViof/ZqtlJn5Xwo7n9qKDbnLiTb7/lSrh4v3OHsl5n
         SGx3KIB8UzPxxiqF8pTYvO49Zz80qh3gAn/Ug+Xo+g2xFdFaxoZ+XSflRebUo0N5JU+E
         XtYvLkWqSvUCAfVPJTfib5B2pn4OUWUW6w20Pvhk0zjls/ffpej4qklFNUyzJwC+qilh
         YbPg==
X-Gm-Message-State: ANoB5pmpQIjL05AN+QuG8346CkDDrt5wX3OTt848ZMGMtm6UTwu5P+ZY
        Nfrc8epgZFVekzSoGj9wi9ukVgWbsSAtDlZIGkM=
X-Google-Smtp-Source: AA0mqf57ZviGMAUJa40HplUSZdKC7mbF+XXAbJoRnDUf2Qz4Yf5RFaBHZJg+SjGtVoQZHDYW2qXNUWKAlwL9001hH0I=
X-Received: by 2002:adf:ecd2:0:b0:236:6fd9:9efa with SMTP id
 s18-20020adfecd2000000b002366fd99efamr48509119wro.101.1670259128223; Mon, 05
 Dec 2022 08:52:08 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6000:5c1:0:0:0:0 with HTTP; Mon, 5 Dec 2022 08:52:07
 -0800 (PST)
Reply-To: phmanu14@hotmail.com
From:   Philip Manul <zagbamdjala@gmail.com>
Date:   Mon, 5 Dec 2022 08:52:07 -0800
Message-ID: <CAPCnorG-XD6nj_eG31hfg5pq-C-zHrVQ38=pSaWUBnnuXUV5yA@mail.gmail.com>
Subject: REP:
To:     in <in@proposal.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Guten tag,
Mein Name ist Philip Manul. Ich bin von Beruf Rechtsanwalt. Ich habe
einen verstorbenen Kunden, der zuf=C3=A4llig denselben Namen mit Ihnen
teilt. Ich habe alle Papierdokumente in meinem Besitz. Ihr Verwandter,
mein verstorbener Kunde, hat hier in meinem Land einen nicht
beanspruchten Fonds zur=C3=BCckgelassen. Ich warte auf Ihre Antwort zum
Verfahren.
Philip Manul.
