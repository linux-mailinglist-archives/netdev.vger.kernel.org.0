Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDA244B1E5
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 18:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbhKIRYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 12:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240869AbhKIRYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 12:24:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47ADC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 09:21:33 -0800 (PST)
From:   bage@linutronix.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636478491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qSJk4Yl4CW42n7cOMcLFFLrlmvh+RVk3/Ilg2wE14iY=;
        b=RpcI2xMDF8qOmtzR2yR4M043mXiSgzoRJScAPDZSXJ+IMU6F6sEGn1cwGQLuhjjlEK2Qd+
        ZLsyj5jScx52MVCe0BcyBYpFHUtWRV2GemW9Osa43kHskNyI9zejw/QEpOhUPARlNT90Eu
        QAJb4kAo2A23R3HCwlxXUe1tYnGsclKZ5oogjURM5c4TgrBzfKzqmTqBUHD91rQhH6RgNz
        kDKzyd8tkQZdd2vlZmR/sMzKkER29Im3/i/VYeUmXxE5MPSSEmKfoGNvG5i+U8QF5cdamY
        6aUgC8NfMRrssXMpfvYaIicgnkOU12bsHXGyqIdvhc/xy7CsgFokl6zMZx3Icg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636478491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qSJk4Yl4CW42n7cOMcLFFLrlmvh+RVk3/Ilg2wE14iY=;
        b=D0cSF3BYWah5jn/xOmvjMw/cX0TZyDCxW4GCwWpTJI5v4OVe5EckSxHyqeRXOzWZNtlL5Q
        aBnGlnfry9P3YaCQ==
To:     mkubecek@suse.cz
Cc:     Bastian Germann <bage@linutronix.de>, netdev@vger.kernel.org
Subject: [PATCH ethtool v2 0/1] Fix condition for showing MDI-X status
Date:   Tue,  9 Nov 2021 18:21:24 +0100
Message-Id: <20211109172125.10505-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

Fix a duplicate condition in the filter for showing MDI-X info.
I am not intending to continue on this issue, so I am dropping
the second patch (invalid for the current kernel side handling).

Changelog:
 v2: - Collect the additional tags
     - Drop the 2nd patch with the twisted pair port condition

Bastian Germann (1):
  netlink: settings: Correct duplicate condition

 netlink/settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.30.2

