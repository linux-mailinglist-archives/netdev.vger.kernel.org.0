Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC66D147271
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgAWUOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:14:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33692 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgAWUOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:14:42 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B046314EA5A19;
        Thu, 23 Jan 2020 12:14:40 -0800 (PST)
Date:   Thu, 23 Jan 2020 21:13:58 +0100 (CET)
Message-Id: <20200123.211358.7836836382214723.davem@davemloft.net>
To:     manishc@marvell.com
Cc:     netdev@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH net 1/1] qlcnic: Fix CPU soft lockup while collecting
 firmware dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122094338.14153-1-manishc@marvell.com>
References: <20200122094338.14153-1-manishc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 12:14:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>
Date: Wed, 22 Jan 2020 01:43:38 -0800

> Driver while collecting firmware dump takes longer time to
> collect/process some of the firmware dump entries/memories.
> Bigger capture masks makes it worse as it results in larger
> amount of data being collected and results in CPU soft lockup.
> Place cond_resched() in some of the driver flows that are
> expectedly time consuming to relinquish the CPU to avoid CPU
> soft lockup panic.
> 
> Signed-off-by: Shahed Shaikh <shshaikh@marvell.com>
> Tested-by: Yonggen Xu <Yonggen.Xu@dell.com>
> Signed-off-by: Manish Chopra <manishc@marvell.com>

Applied.
