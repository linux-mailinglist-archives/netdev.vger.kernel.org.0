Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC44C0633
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbiBWAdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiBWAdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:33:11 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082AC5C376
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:32:45 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id p19so44680666ybc.6
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=ONiN6ApFO7W4V5cuLLgkMrs/Sg8q4dIde+9ps5I8QLj1N1tIBav8WIdWgTyzpk0n9J
         FZVrbY5T3mW3Cdp2wijNgHIZ59wTEdJA4aNvd+Qf6PH73F0nbkqBDbRxnt0Vrh6s1gcJ
         Jz4D6y8ow9+g9NCYjPKdUIjcX5pA97iCf7z6rx24iMlSitVmtOHORz2DbS/wwvtcVoh8
         /F569/3IrF2UghaT7jz1FzQM7mEsLZB3WKwa6xSm9MbzsAMAAwq0Qiap9KqUZGG0Fgr3
         ahU/XgBkFk6eMV76wA0ZNjMwcx8iT6wWePvWJtVE894MJmBFlSjzmmROBFchVk9DGX7H
         2JXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=gT0aDXNc+tVHobiNL5UeiSuEuBBaMP1CoUPbPd+fKInnmLd/L8V4xJGsx00SdCwjsY
         BG70qN2cCcF+MvJw7wtsCrKh9vFTyAy7vWsSBoc3OxszZ7oU15Gki1N2Raihd9dAKK0J
         MeLDSNcgVN/y/TZXL+X+LcjN/ZaUTkEPHsCsWPNMr9jK3V5vSv+Oeu76dnvvBWvYSUZC
         39XbKfqwSN9/OR9+yTUAe3nYeD9DXGY17E/MmCWS72Q0t9wnEq14upu9Uw1LeMixJMkY
         mHVdvChBilOAV1pPh0T0BGJTRi8M0TKLN28ayvQbTuVWX3DfjEfRnlQIStmlblFm4oVP
         jeng==
X-Gm-Message-State: AOAM5328ZNNheeZsH08sb6+w5C5CWEfwdA8W4HrO50lcHkFRuYSA87tW
        duga7nZ4g6cT4RNMOGRm5sU+BlvwQTGHdwYTorxCs6/JgWs=
X-Google-Smtp-Source: ABdhPJzy8Cm6uk29fDIKqElqsL+JHqQSM060naEHuRi20Nlh9vhWbkJEqAXN10wct9X8gHhidvTEr+kxWHGLgNb3Fv0=
X-Received: by 2002:a25:2b0a:0:b0:624:a898:3e2f with SMTP id
 r10-20020a252b0a000000b00624a8983e2fmr9006927ybr.643.1645576364286; Tue, 22
 Feb 2022 16:32:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7108:7048:0:0:0:0 with HTTP; Tue, 22 Feb 2022 16:32:43
 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <arafaeloxford@gmail.com>
Date:   Tue, 22 Feb 2022 16:32:43 -0800
Message-ID: <CAM=40BKQodnEkvHTeV9jguHEr5BqhxmVrOeTv2h20yWc__QnaA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Please with honesty did you receive my message i send to you?
