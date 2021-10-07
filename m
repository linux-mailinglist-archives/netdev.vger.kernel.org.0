Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAF4259F6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243413AbhJGRxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243411AbhJGRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:53:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EA5C061765
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 10:51:08 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633629067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o9Fa0eJaKfAxzxq6qVesQ2gRZXWktuD2QMHejQW18Yg=;
        b=g9gIJii4bkSEmy3H9NlNrfxV6UH1VSfjIk9y4SDySs/l3wa3W7zwOe5GKRPlD6o+6yjzOF
        rWQqCGWwSP33zFVa71BKNGbcnfSm/2ZMCNuYVLHvaS/6pqI49EBzVcJL6CAYJWSlq982eP
        7GtOGbKhgXDaPGkavMQM+bSuFyzMa4XbtI6LLk9dJlRC/NzHhudLkqVMhuEbDCF25PoC0/
        p/rZQNSR75O1LBW/H3IU/7jw0kjBL1KGJlIrlLBE3lL1osncaUqFZACaTrmfcOV24bQHA/
        BDuL79H3ody52qXksOI2kO03cHYV4GWszy4cnfL9/nsxVtTKr9SkvVTwN4nHtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633629067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o9Fa0eJaKfAxzxq6qVesQ2gRZXWktuD2QMHejQW18Yg=;
        b=llRkT00fITUWNN8tqVdNkKpH4mOvYkMGoQBQt074GfbV7Z6gMPd2bSo+rfzuhSxgUIxET7
        NIWwGp9YlfijkGCQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 0/4] mqprio fixup and simplify code.
Date:   Thu,  7 Oct 2021 19:49:56 +0200
Message-Id: <20211007175000.2334713-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been looking at the statistics code and stumbled upon something
that looked like bug. The following patches is an attempt to simplify
the code so that the else part can be removed. I'm not 100% sure
regarding the qlen usage in 4/4.

Sebastian


