Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570653294B5
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 23:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242353AbhCAWOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 17:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbhCAWL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 17:11:58 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6757C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 14:11:17 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id f33so18035756otf.11
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 14:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2XD9wjwGm6oa+wSZU5yD4GERFp1dRcmVow56tY+OI6Q=;
        b=F5kRJUTwt+xOF9SaKvdYo3XUfscipMCH9CRxwvitpb8KR1SG5B8fLQMzulPdJkl+Kb
         hPK1k4vCO669+o4CX1ILD8pLh6ggZSlpFmrWMv7NK7BMbej2jHXMpEhSLmwrj0KHmGkh
         xl2BvhRWikVH9NSrxpZ27I1BPnt5d94Gc9lK7e9rvnk6v5TZJLwhj1XpqPK+FU5VPnwM
         E0fETDiWk8gpqEdRIy+OI3fHD7P1VIjK7ifzlZ85iDtpHM+jXDQAI0EOiZjirBDQSULH
         GOkj8Bz/JDBuCoN/guGVOJ/LX5sluPM2dD+YtYfgxlkZ5mroIir5OZRVmkln08qnIZ0l
         6A6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2XD9wjwGm6oa+wSZU5yD4GERFp1dRcmVow56tY+OI6Q=;
        b=oLMmSB1RcgCFeHeRr0IMAjXQQaZY2xe7S0ArGnXVeQlmwbGYmYYPsmJxwarMMWVWeb
         /E6tId074tBImWBGctwF5PcbCPcG6YL+UZMj4tr7ikOeUKcievCWtlxMqvqH91xv0Gkm
         7V+8odI8wuPQgSWvHYEFvhZVE3ma01zvZy3ZLzxG4t4YRkeT86J2OC8cV7e1jLtn+OLT
         +KgvL4TJY1zmN7QXDvHeif1nDCYGFL/ulfX61JOabW/fxYESIgHkztylOCc0F23v6au0
         iUqgbZto4XxRZSDEYidmPAKgxv4j6MOLwusoy2K50MjXdp4W4SXpvGdpgqLmxyi3jBgK
         0VQQ==
X-Gm-Message-State: AOAM532lZjXrTBpN61v1iyK8NwGyZpA7X81ZEVpavEyj0742/vUMg9ku
        9Jn1df9IgwdAAQsfE5sp+ocdZoQd2VlM01ghAr2Nj0MbvuaXgg==
X-Google-Smtp-Source: ABdhPJyo0UGeBVHSGQ4lgb+6dQ5o2XP+ak5nvPs3Pvo9ok/5H9jRCKJ7A8KVZ6rA907DdWE/zHaDS7N+RAWtT3z4eJQ=
X-Received: by 2002:a9d:7cc4:: with SMTP id r4mr15557146otn.343.1614636677350;
 Mon, 01 Mar 2021 14:11:17 -0800 (PST)
MIME-Version: 1.0
From:   Zbynek Michl <zbynek.michl@gmail.com>
Date:   Mon, 1 Mar 2021 23:11:05 +0100
Message-ID: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
Subject: [regression] Kernel panic on resume from sleep
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Can anybody help me with the following kernel issue?
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983595

Do I understand it correctly that the kernel crashes due to the bug in
the alx driver?

Thank you
Zbynek
