Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A676928A9
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjBJUtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbjBJUtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:49:49 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF8D7F809
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:49:47 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-52ec329dc01so64637627b3.10
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZferHKUerucCytQgVnNov06/kD1HvUXwj8PtXjF4MJA=;
        b=AnYqYIQL/bXcy4M0QuLYXuL7+bOtk/3BAgEbEbO2DcESSyXTVxsekGAmgF6JS1qlHU
         2PZMWmiwPSJJnnRr0A2zUEYq9bzjeNYh/kfc5bYeJYRXmiS4aotlZHSM2bPb1Ygw3fAB
         wHJYAhLzic2xG6DnoTs+JIZBLbR1OMiFNaoFVL81i8LEGe4rdo4eNmu5PsksPUaRQ59c
         DP9ZZ+lPjxcNN7ZocQTuPoCblfNgjxqDGJlwymVBhcMzhZaRBGdSco+KI2CQmtMkQyqb
         CVdabyyAPKzYVM+2BFky5TmIQDUaczr0vQ++hJGbu9aBAvnkJ0SL3eV1eXR23ufrS89n
         J+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZferHKUerucCytQgVnNov06/kD1HvUXwj8PtXjF4MJA=;
        b=wUoL5quMvEiZqkZ/sFcPqZu4/xAfKjKumH9DU+fgGFCD1RioWSjdVNCYjQAAnVcruB
         lrqh0qSdxfU3K+hcm+CjW33n69r8v4kzwZ7O9zx9kzDULIUoifrIIDogdeMpslFNK1SG
         7Zp28U9jY9B8xZd4D9OiTREx/6c6CKNoFyxgCOsXKmxyaej4I2opcEU3efx9uYiYDyvV
         J1q9OyXhOc1004PiEq1Ar+VSYnWsSR0AatNhXe33Qw/rzT2D91j8HgPHi0pTwmTOG4d+
         za0GTOkFbEK9zD2nN8AIyno8Y0x2HisIHoGXVCNbw8y0aMZWoyiVkL6Yt085d8F6WnRz
         8ddA==
X-Gm-Message-State: AO0yUKUQBNmJcJWi8U7IPlRZcKDo0Vjt+gkmUu7EKEDtk6os71nA5vv9
        nYdAJ+tqKr2x/tjBplXXy1w3TV4MbZB8LEDekso=
X-Google-Smtp-Source: AK7set8F2OhXgmZoOaxu4oD1mqHt1Q7Knu+hAC9dxGJwA+zae5pJkOJ0lfVE291RW3ooxgwBbAxd5erNpEI/WgzNvoo=
X-Received: by 2002:a81:4f57:0:b0:52e:de55:4f27 with SMTP id
 d84-20020a814f57000000b0052ede554f27mr260408ywb.294.1676062186980; Fri, 10
 Feb 2023 12:49:46 -0800 (PST)
MIME-Version: 1.0
Sender: lolorachida@gmail.com
Received: by 2002:a05:7010:4da2:b0:31c:ed82:deec with HTTP; Fri, 10 Feb 2023
 12:49:45 -0800 (PST)
From:   =?UTF-8?Q?ELIZABETH_=C3=81LVAREZ_GARC=C3=8DA?= 
        <elizabethalvarez7garcia@gmail.com>
Date:   Fri, 10 Feb 2023 20:49:45 +0000
X-Google-Sender-Auth: bhnqJa5mRWBCDDEudCeUbMtmWTo
Message-ID: <CAPDHN6rTZ6u2W+2YFOfTZLnYMt=7g4mB-H3MT13kgvme9FkwJA@mail.gmail.com>
Subject: Congratulations!!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Congratulations!!!
Your email ID was picked among the Coca-Cola 10 lucky Winners, please
contact the agent for more details and to claim your prize.

Contact person NAME: Mr Write John
Whatsapp / Mobile Number: +1 (518) 299-8332
Email Address: Coke-Agent-john@programmer.net

Thank You
ELIZABETH =C3=81LVAREZ GARC=C3=8DA
Public Relation Officer
