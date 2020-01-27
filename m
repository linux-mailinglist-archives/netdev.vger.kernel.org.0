Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CC914A533
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgA0NgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:36:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39432 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgA0Nf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:35:59 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FDE415729971;
        Mon, 27 Jan 2020 05:35:58 -0800 (PST)
Date:   Mon, 27 Jan 2020 14:35:56 +0100 (CET)
Message-Id: <20200127.143556.336328166951372844.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     ariel.elior@marvell.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/13] qed*: Utilize FW 8.42.2.0
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127132619.27144-1-michal.kalderon@marvell.com>
References: <20200127132619.27144-1-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 05:35:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Mon, 27 Jan 2020 15:26:06 +0200

> This FW contains several fixes and features, main ones listed below.
> We have taken into consideration past comments on previous FW versions
> that were uploaded and tried to separate this one to smaller patches to
> ease review.
> 
> - RoCE
> 	- SRIOV support
> 	- Fixes in following flows:
> 		- latency optimization flow for inline WQEs
> 		- iwarp OOO packed DDPs flow
> 		- tx-dif workaround calculations flow
> 		- XRC-SRQ exceed cache num
> 
> - iSCSI
> 	- Fixes:
> 		- iSCSI TCP out-of-order handling.
> 		- iscsi retransmit flow
> 
> - Fcoe
> 	- Fixes:
> 		- upload + cleanup flows
> 
> - Debug
> 	- Better handling of extracting data during traffic
> 	- ILT Dump -> dumping host memory used by chip
> 	- MDUMP -> collect debug data on system crash and extract after
> 	  reboot
> 
> Patches prefixed with FW 8.42.2.0 are required to work with binary
> 8.42.2.0 FW where as the rest are FW related but do not require the
> binary.
 ...

Series applied.
