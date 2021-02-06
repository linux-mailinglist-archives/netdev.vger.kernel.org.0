Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7489931185B
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBFCfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhBFCcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:32:39 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21822C08EE0C;
        Fri,  5 Feb 2021 16:02:03 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l18so4711515pji.3;
        Fri, 05 Feb 2021 16:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4+TaH7FhFyvXQ+dRkOsL4rRGid5VY07dFOwf2AoTuxQ=;
        b=DBSwGm0kuGQoBkyB/8OjbDLGV/Wgv1u/o0Qr2F5RiLkmH+BFaVn6Myyv1otOoKIoqf
         UMB4hnJ6wcV8VPw5eR0dKs0kWWqpMiqCqaMkC5c4ZGB/0uy4fTRzsp5oEqsBlBw+IZIz
         i2DT348zMS/h7CNuZtZnKDKmgooG8hrNbKYJ14PyxvXTzUYW0u63tqECGebMWErF+QBi
         4HY6KKOebz9TT7+CL5QZf83sKxLheeBknDfbsX38j2VBexaJgO0gIAdFzAPEwsTQtFlm
         roX4dQskjr/RCDceF2tsicpTDb9SeK05m+wi++2mtEbahlar5yNYKCYJnIE7kG52WujF
         hsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4+TaH7FhFyvXQ+dRkOsL4rRGid5VY07dFOwf2AoTuxQ=;
        b=VsRuu+5NssaYYw1f0Xqwjotn9gN81r5V9hBIzSqg6RbPwU6OC55GXEb8A9sGz4KLUT
         6EEucPqrvqWv1SGTxAuTIOXdAW/+3Cwn7kPGHrBF/IpLdThG7sUmEiey47qZxQ2HayDu
         wN9kD6mFzZCAap+/OKaNdV3kTTFXR1XmU98lRWBNOKgWlE48Xkr7njzxdQtfaORxEdre
         zShsCfLtKkwKuafEDnIWz9jQEM96JaT6KHrelMLuzdhKcTG7O7UJqG940u0MELIOv/Q6
         3Jd0OKxnur9RYnoJOo5YU6XE6da2c+NsoBBwDutj+N+Y35O0/LdbUq1PMEsx91q37ij4
         gYrQ==
X-Gm-Message-State: AOAM530KE9/9fupOpzabrzrhO6poLSkBNeuYBLGTFI8UoFGduQWRWDA4
        +6yApzoiS+vfnAcPu3XtKPg=
X-Google-Smtp-Source: ABdhPJx74xSyMB0VDzrMdOyldrSIeLLHt3H/b1DqKFsr/Uo8ZdN6oxK5cD4Xb1rv7eh/syJ5rGHxpg==
X-Received: by 2002:a17:902:e551:b029:de:8dba:84a3 with SMTP id n17-20020a170902e551b02900de8dba84a3mr6242780plf.8.1612569722697;
        Fri, 05 Feb 2021 16:02:02 -0800 (PST)
Received: from amypc-samantha.home ([47.145.126.51])
        by smtp.gmail.com with ESMTPSA id r189sm11771724pgr.10.2021.02.05.16.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 16:02:02 -0800 (PST)
From:   Amy Parker <enbyamy@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, akpm@linux-foundation.org,
        rppt@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amy Parker <enbyamy@gmail.com>
Subject: [PATCH 0/3] drivers/net/ethernet/amd: Follow style guide
Date:   Fri,  5 Feb 2021 16:01:43 -0800
Message-Id: <20210206000146.616465-1-enbyamy@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset updates atarilance.c and sun3lance.c to follow the kernel
style guide. Each patch tackles a different issue in the style guide.

   -Amy IP

Amy Parker (3):
  drivers/net/ethernet/amd: Correct spacing around C keywords
  drivers/net/ethernet/amd: Fix bracket matching and line levels
  drivers/net/ethernet/amd: Break apart one-lined expressions

 drivers/net/ethernet/amd/atarilance.c | 64 ++++++++++++++-------------
 drivers/net/ethernet/amd/sun3lance.c  | 64 +++++++++++++++------------
 2 files changed, 69 insertions(+), 59 deletions(-)

-- 
2.29.2

