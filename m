Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E807146C78
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWPSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:18:13 -0500
Received: from mx4.wp.pl ([212.77.101.11]:44384 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgAWPSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 10:18:13 -0500
Received: (wp-smtpd smtp.wp.pl 1361 invoked from network); 23 Jan 2020 16:18:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1579792690; bh=HVebdqs4jjVJLiwEy7GWNt82L4WsqWx3d6tHegSCug0=;
          h=Subject:To:CC:From;
          b=nZ9u77Zk0CgC8gYFwBOLt5WyALlx2Q0aTTDjGlVjEk6erf8aUgyX/KaO552nYpWTt
           /3JJj7/o9AlfQa46sk3QmN5qVacvyLjVDPTMHIDpAPPP1swYTTu9uu3C8MImWJQUM7
           AZzOKKDuPqQShfv355bUdrZ1ZbT9mBGKw9Y2t1D8=
Received: from unknown (HELO [IPv6:2607:fb90:4a9:9af8:7bb0:36a1:c5f0:bff9]) (kubakici@wp.pl@[172.58.38.244])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <leon@kernel.org>; 23 Jan 2020 16:18:10 +0100
Date:   Thu, 23 Jan 2020 07:17:54 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20200123145442.GP7018@unreal>
References: <20200123130541.30473-1-leon@kernel.org> <20200123064006.2012fb0b@cakuba> <20200123145442.GP7018@unreal>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel version
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
From:   Jakub Kicinski <kubakici@wp.pl>
Message-ID: <035D6EB1-B1CB-4285-97F8-534B10D9C01E@wp.pl>
X-WP-MailID: f9657610267c0eccae14476658ee131e
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AROy]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On January 23, 2020 6:54:42 AM PST, Leon Romanovsky <leon@kernel=2Eorg> wr=
ote:
>> Anyway, you gotta rebase on net-next, the ethtool code got moved
>around
>> :)
>
>I tried it now and It applies cleanly on top of commit
>6d9f6e6790e7 Merge branch
>'net-sched-add-Flow-Queue-PIE-packet-scheduler'

Git is magic=2E
