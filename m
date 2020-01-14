Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FA313A785
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgANKjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:39:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:45466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgANKjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 05:39:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 767A4AD55;
        Tue, 14 Jan 2020 10:39:46 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Wen Huang <huangwenabc@gmail.com>,
        Nicolai Stange <nstange@suse.de>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 0/2] libertas: fix rates overflow code path in lbs_ibss_join_existing()
Date:   Tue, 14 Jan 2020 11:39:01 +0100
Message-Id: <20200114103903.2336-1-nstange@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <87woa04t2v.fsf@suse.de>
References: <87woa04t2v.fsf@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

these two patches here attempt to cleanup two related issues ([1])
introduced with commit e5e884b42639 ("libertas: Fix two buffer overflows
at parsing bss descriptor"), currently queued at the  wireless-drivers
tree.

Feel free to squash this into one commit.

I don't own the hardware and did some compile-testing on x86_64 only.

Thanks,

Nicolai

[1] https://lkml.kernel.org/r/87woa04t2v.fsf@suse.de


Nicolai Stange (2):
  libertas: don't exit from lbs_ibss_join_existing() with RCU read lock
    held
  libertas: make lbs_ibss_join_existing() return error code on rates
    overflow

 drivers/net/wireless/marvell/libertas/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.16.4

