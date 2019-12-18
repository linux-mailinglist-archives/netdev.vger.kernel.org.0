Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537C61253B9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfLRUmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:42:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfLRUmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:42:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AFC4153D64B8;
        Wed, 18 Dec 2019 12:42:45 -0800 (PST)
Date:   Wed, 18 Dec 2019 12:42:44 -0800 (PST)
Message-Id: <20191218.124244.864160487872326152.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 00/15] Multipath TCP part 2: Single subflow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 12:42:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Wed, 18 Dec 2019 11:54:55 -0800

> v1 -> v2: Rebased on latest "Multipath TCP: Prerequisites" v3 series

This really can't proceed in this manner.

Wait until one patch series is fully reviewed and integrated before
trying to build things on top of it, ok?

Nobody is going to review this second series in any reasonable manner
while the prerequisites are not upstream yet.

Thank you.

