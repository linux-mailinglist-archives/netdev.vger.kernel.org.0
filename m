Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2283FF5A9
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfKPVA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:00:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53734 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:00:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 284C714E057CE;
        Sat, 16 Nov 2019 13:00:26 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:00:25 -0800 (PST)
Message-Id: <20191116.130025.1510472536338010405.davem@davemloft.net>
To:     dag.moxnes@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [net] rds: ib: update WR sizes when bringing up connection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573808161-331-1-git-send-email-dag.moxnes@oracle.com>
References: <1573808161-331-1-git-send-email-dag.moxnes@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:00:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dag Moxnes <dag.moxnes@oracle.com>
Date: Fri, 15 Nov 2019 09:56:01 +0100

> Currently WR sizes are updated from rds_ib_sysctl_max_send_wr and
> rds_ib_sysctl_max_recv_wr when a connection is shut down. As a result,
> a connection being down while rds_ib_sysctl_max_send_wr or
> rds_ib_sysctl_max_recv_wr are updated, will not update the sizes when
> it comes back up.
> 
> Move resizing of WRs to rds_ib_setup_qp so that connections will be setup
> with the most current WR sizes.
> 
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>

Applied.
