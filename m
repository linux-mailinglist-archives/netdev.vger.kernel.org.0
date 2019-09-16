Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EF2B35D2
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfIPHl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:41:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:52784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728139AbfIPHl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 03:41:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00747B639;
        Mon, 16 Sep 2019 07:41:26 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: macb: inconsistent Rx descriptor chain after OOM
CC:     netdev@vger.kernel.org
X-Yow:  The Korean War must have been fun.
Date:   Mon, 16 Sep 2019 09:41:26 +0200
Message-ID: <mvm4l1chemx.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When there is an OOM situation, the macb driver cannot recover from it:

[245622.872993] macb 10090000.ethernet eth0: Unable to allocate sk_buff
[245622.891438] macb 10090000.ethernet eth0: inconsistent Rx descriptor chain

After that, the interface is dead.  Since this system is using NFS root,
it then stalled as a whole.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
