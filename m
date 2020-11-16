Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB8C2B4AC7
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgKPQVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731782AbgKPQVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:21:23 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202D4C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:21:23 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605543681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SO3JKoXjbZqHqxsBPTBhrc7HmuDa1K7Ca/aOQ/tWC6E=;
        b=pC8cePBHdSGMOcfZ3JlzTHWj3m65b3eEoK/a7+Wu9Z/jmV2M5csk/t43/mHykz1aHKoISr
        evanXlckFt82HKk8Ash3JjFGq3i1LGRuRBj19qf38kR0rdMcrJTAVPVvkbZwW3cFLdqjX6
        J42hJ7zjub30gVIGroygYhbJMzf54ikj40DZV0N2oSg7sOjsLf6OdPwaNOl0bxZl6WwagS
        TYDuQJWuw9tfikQlbbqoVJ07DRJVynyVi8Vu33K11VD9EqFN3/hrAyauyx4Qt2/jM/Etby
        /qWZLKdjUWBIuEWSPl4he9m1vfz5o/XrUMV3VsucNxWjmQHvksTvdEKq1glidg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605543681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SO3JKoXjbZqHqxsBPTBhrc7HmuDa1K7Ca/aOQ/tWC6E=;
        b=JrNvJmAdn5YBYoQ3IUpdzYoczlHTgTXt11yF4Sv6vC2jcChcwUoSXTQENBVVm4vl+mrCKP
        gMIQoiZN2AU7tvAQ==
To:     linux-atm-general@lists.sourceforge.net
Cc:     Chas Williams <3chas3@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] atm: Replace in_interrupt usage
Date:   Mon, 16 Nov 2020 17:21:13 +0100
Message-Id: <20201116162117.387191-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

this mini series contains the removal of in_interrupt() in drivers/atm
and a tiny bugfix while staring into code.

Sebastian


