Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EF44C5EA7
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 21:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiB0UiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 15:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiB0UiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 15:38:02 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA6F1A832
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 12:37:24 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id h126so1737718ybc.1
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 12:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=nx9+QHyk24LCGrPVPNU/GVW+tj79Upc/3BnnE5CxF2s=;
        b=GgBZqE2TR6Hv8mKDFjf8NpVIIo9oGydCXxoM8q0KWahzJpQo7/KF86AWV0MjY/VQDF
         9iCJjnabrTndqeoQ1+3NGYRtPc5I6+KYTLhuYKKbXcgUUsAW5/2CPZaAJyV7Q7DIf133
         LIkTwMcNUf6q8BKCDLVus86fNupCPGEPfGz1dKcbgzz63TuBJ2jUx97o2aE6pEzDV0CQ
         4xUXGWLbX1/bL0q2IPNhJQNni7CAkxVbVrUfi7CTJRsHrryXZkUUPoUO/DyJhj3sr+rB
         zlqJE5aWrviWwlLH8sa/dS7CFXKX+AJjVluXt347JiKnJ5E7dCowv191yFU7ixnlSc1L
         5xKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=nx9+QHyk24LCGrPVPNU/GVW+tj79Upc/3BnnE5CxF2s=;
        b=Wm8WyoG0Wi9lA2W7Aj3QJbCnGEzBeYIMiJTGHaeSbWg7sLa+a2TYMw+PC3IlbgNI67
         pQyHfTqSxQU0jPPW99Dp12OGmwKD1JNMMNQ5Mo5SkxE6rbIskffUG15UaiemB8FDyzDI
         qwbMSdWMo9EO5jDAcb0RuG08p/OHqhES8dri97iMksgwyYd0TkAuwD2f2d+VzAzT0Jv+
         0m/46t1nM59deZ7zy0lyfZ9oeGy7mZ+y/JXXRVvGmxKBjLUsrtW1etPqkmXP9NTT51BC
         HCrKM8cDnfKpZZWuja93h354XF6kGc4F8GQDfuw7MvohPO9e4jY3xozh4+cuGSYNfU+W
         oGLw==
X-Gm-Message-State: AOAM532d/iszMrVWRSh106tSlTuStWPLy5twV5qXlzoT7VCtq+nHDtQz
        9M2brS4iY1wQeulLaxIYhCuZUFQuJ7bF/NXHBfg=
X-Google-Smtp-Source: ABdhPJw/hRQ5VOSxxFcV/ODEbBuNa9ri4uj1esQfUS+aJuiad6g6rf66Xh+i7XFW3em8VPdT4mrwglaf2iJhwbHFbPY=
X-Received: by 2002:a25:9e81:0:b0:624:3b8a:514b with SMTP id
 p1-20020a259e81000000b006243b8a514bmr16039482ybq.266.1645994243574; Sun, 27
 Feb 2022 12:37:23 -0800 (PST)
MIME-Version: 1.0
Sender: ericnony02@gmail.com
Received: by 2002:a26:c509:0:0:0:0:0 with HTTP; Sun, 27 Feb 2022 12:37:23
 -0800 (PST)
From:   "Mr. Priyantha Ranasinghe" <assinmaking48@gmail.com>
Date:   Sun, 27 Feb 2022 12:37:23 -0800
X-Google-Sender-Auth: HRX_zqr0V3iIIh3VabiUhngCzsw
Message-ID: <CAGscK4FzdKpvAw1dD2yNLHYLJ=TVh1F4aWX0+6vLVeDL+nF56g@mail.gmail.com>
Subject: PLEASE CONFIRM DETAILS TO PROCEED.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How are you doing today?

Can you receive the sum of EUR=E2=82=AC5.5 million with 550kg of Raw Pure G=
old
in your country for our mutual benefit? I have contacted you to stand
as the Beneficiary/ Business Partner. The Fund belongs to foreign
deceased Contractor who had no indication of Beneficiary on his
deposit documents.

I will give you further details in this regard once I confirm your readines=
s.

Regards,

Mr. Priyantha Ranasinghe.
