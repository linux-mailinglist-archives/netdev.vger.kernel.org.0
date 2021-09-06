Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3039E40189E
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhIFJLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:11:50 -0400
Received: from mail.sysmocom.de ([176.9.212.161]:56264 "EHLO mail.sysmocom.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhIFJLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 05:11:49 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Sep 2021 05:11:49 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.sysmocom.de (Postfix) with ESMTP id 1950219802B9;
        Mon,  6 Sep 2021 09:04:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at sysmocom.de
Received: from mail.sysmocom.de ([127.0.0.1])
        by localhost (mail.sysmocom.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id neVYQfuBHVR3; Mon,  6 Sep 2021 09:04:42 +0000 (UTC)
Received: from [192.168.1.106] (dynamic-095-118-009-140.95.118.pool.telefonica.de [95.118.9.140])
        by mail.sysmocom.de (Postfix) with ESMTPSA id 22CE7198026C;
        Mon,  6 Sep 2021 09:04:42 +0000 (UTC)
From:   Oliver Smith <osmith@sysmocom.de>
To:     netdev@vger.kernel.org
Cc:     Harald Welte <laforge@gnumonks.org>
Subject: Missing include include acpi.h causes build failures
Message-ID: <aa6271d7-7574-041d-ab35-ea98a8a6df79@sysmocom.de>
Date:   Mon, 6 Sep 2021 11:04:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello linux-netdev ML,

can somebody please cherry pick the following patch from
torvalds/linux.git to net-next.git (or rebase on that patch? not sure
about the usual workflow for net-next):

	ea7b4244 ("x86/setup: Explicitly include acpi.h")

Since the 1st of September, this missing include causes the Osmocom CI
job to fail, which runs osmo-ggsn against the GTP tunnel driver in
net-next.git (to catch regressions in both kernel and Osmocom code).

Thanks!

Best regards,
Oliver

-- 
- Oliver Smith <osmith@sysmocom.de>            https://www.sysmocom.de/
=======================================================================
* sysmocom - systems for mobile communications GmbH
* Alt-Moabit 93
* 10559 Berlin, Germany
* Sitz / Registered office: Berlin, HRB 134158 B
* Geschaeftsfuehrer / Managing Director: Harald Welte
