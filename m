Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D853ECB97
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 00:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhHOWDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 18:03:36 -0400
Received: from aibo.runbox.com ([91.220.196.211]:38764 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230077AbhHOWDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 18:03:35 -0400
X-Greylist: delayed 2224 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Aug 2021 18:03:35 EDT
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <post@jbechtel.de>)
        id 1mFNdm-0006nR-Pr
        for netdev@vger.kernel.org; Sun, 15 Aug 2021 23:25:58 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (535840)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1mFNdj-0005xT-5w
        for netdev@vger.kernel.org; Sun, 15 Aug 2021 23:25:55 +0200
Date:   Sun, 15 Aug 2021 23:17:38 +0200
From:   Jonas Bechtel <post@jbechtel.de>
To:     netdev@vger.kernel.org
Subject: ss command not showing raw sockets? (regression)
Message-ID: <20210815231738.7b42bad4@mmluhan>
X-Mailer: Claws Mail ~3.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi there,

I've got following installation:
* ping 32 bit version
* Linux 4.4.0 x86_64 (yes, somewhat ancient)
* iproute2  4.9.0 or 4.20.0 or 5.10.0

With one ping command active, there are two raw sockets on my system: one for IPv4 and one for IPv6 (just one of those is used).

My problem is that

ss -awp

shows 
* two raw sockets (4.9.0)
* any raw socket = bug (4.20.0)
* any raw socket = bug (5.10.0)


So is this a bug or is this wont-fix (then, if it is related to kernel version, package maintainers may be interested)?


Best regards
 Jonas Bechtel





