Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236A9230AF0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgG1NGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729857AbgG1NGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 09:06:02 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B249CC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 06:06:02 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id x9so10584722ybd.4
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 06:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QwACiPoV+5zlVvLdlNuxxis0FG/qkHNw1smV6Kt2VfI=;
        b=IQei591je4Zl5T9WjUUHitlmD2vGjt5SV74xlDL5841bchTBrtfnu50GXQu0Lx03G2
         paxsWhwmNWQx1w535YmPMzi0jvKMv+vKzG8gw24bOuU8Yb/o01RdD7e1cu5+uoRyUVgX
         tkuuAkIfWT5bAvA2uhrF7QXhU+2cgjVpFxJUtTodSst3e1442iape9TXvVzrrDwF5dD0
         Xt2E4eqbco6B5njQ3ZdAnMrCVZ9etsEHwKCuP2V/ipFG9USQnueogEBG4Acun0I53UBt
         npXU5wAhJ5IX4TB3x8+SqgIX+NshwHaCBS2M4y/YRjutELFaOG/gazhV3K6cfvqzaPvU
         Ntsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QwACiPoV+5zlVvLdlNuxxis0FG/qkHNw1smV6Kt2VfI=;
        b=JYWYKTuHVG0lJZPC2wXjHQLf2lrj+/ma0ZZW4v4qMXVV7bcD6kCRJTquedyXAR5bBn
         of/vvAujM5tng2Tx2kQlcQDr2FXn/3F9MfFKP9oJvzbk6IUYBkODCIUUsYmKkndCWsOK
         YqRLkSMmBXsF6IrnI58hZv/SWksjsTR2MHKPYBkm1p6f77O+dRi/no0to80QYMMHzrBr
         NJtRQoWZc+I/zyc5wFleBTWWH0j0wi57UCoGFCpnNjdyXhVjBYvz009oR8SsvdmY1EeJ
         3bWzxTDRwvvJVgKTaUTuAryMbUzJ2wGuQ4sBloA7UXKA6WAur+/NUCYb4Wkj3If8JLlF
         C4UA==
X-Gm-Message-State: AOAM532lxKggjXAO/38DrWKvfm5JR9olX7veDOdlxUY/YUGh2klDOMhZ
        6iWMisfvwClA33J10fhxQ1Dv35+pdp3tJbWvAIDjMHq1ff0=
X-Google-Smtp-Source: ABdhPJwH6wJYIzAgz5Q4OQTAy3+gKeA27Hk6R4ShttXup4jwQuv6z0HT37nZBChnaszm+QTmLmik2H+awZaVyVYcRHM=
X-Received: by 2002:a25:3302:: with SMTP id z2mr39608578ybz.215.1595941561954;
 Tue, 28 Jul 2020 06:06:01 -0700 (PDT)
MIME-Version: 1.0
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 28 Jul 2020 16:05:50 +0300
Message-ID: <CAJ3xEMhk+EQ_avGSBDB5_Gnj09w3goUJKkxzt8innWvFkTeEVA@mail.gmail.com>
Subject: iproute2 DDMMYY versioning - why?
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen,

Taking into account that iproute releases are aligned with the kernel
ones -- is there any real reason for the confusing DDMMYY double
versioning?

I see that even the git tags go after the kernel releases..

Or.

# git remote -v
origin  git://git.kernel.org/pub/scm/network/iproute2/iproute2.git (fetch)
origin  git://git.kernel.org/pub/scm/network/iproute2/iproute2.git (push)

$ git log -p include/SNAPSHOT.h

commit 1bfa3b3f66ef48bdabe0eb2a7c14e69f481dfa25 (tag: v5.7.0)
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Tue Jun 2 20:35:00 2020 -0700

    v5.7.0

diff --git a/include/SNAPSHOT.h b/include/SNAPSHOT.h
index 0d10a9c2..0d211784 100644
--- a/include/SNAPSHOT.h
+++ b/include/SNAPSHOT.h
@@ -1 +1 @@
-static const char SNAPSHOT[] = "200330";
+static const char SNAPSHOT[] = "200602";

commit 29981db0e051cd4c53920c89dddcf3d883343a0f (tag: v5.6.0)
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Mon Mar 30 08:06:08 2020 -0700

    v5.6.0

diff --git a/include/SNAPSHOT.h b/include/SNAPSHOT.h
index c0fa1bb4..0d10a9c2 100644
--- a/include/SNAPSHOT.h
+++ b/include/SNAPSHOT.h
@@ -1 +1 @@
-static const char SNAPSHOT[] = "200127";
+static const char SNAPSHOT[] = "200330";

commit d4df55404aec707bd55c9264c666ddb1bb05d7f1 (tag: v5.5.0)
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Mon Jan 27 05:53:09 2020 -0800

    v5.5.0

diff --git a/include/SNAPSHOT.h b/include/SNAPSHOT.h
index b98ad502..c0fa1bb4 100644
--- a/include/SNAPSHOT.h
+++ b/include/SNAPSHOT.h
@@ -1 +1 @@
-static const char SNAPSHOT[] = "191125";
+static const char SNAPSHOT[] = "200127";

etc
