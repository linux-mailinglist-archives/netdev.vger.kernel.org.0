Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCD4BEC96
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfIZHdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:33:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44852 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbfIZHdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:33:23 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1F6B128F3870;
        Thu, 26 Sep 2019 00:33:21 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:33:20 +0200 (CEST)
Message-Id: <20190926.093320.1751119335197105399.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org
Subject: Re: [PATCH] openvswitch: change type of UPCALL_PID attribute to
 NLA_UNSPEC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569323512-19195-1-git-send-email-lirongqing@baidu.com>
References: <1569323512-19195-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:33:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Tue, 24 Sep 2019 19:11:52 +0800

> userspace openvswitch patch "(dpif-linux: Implement the API
> functions to allow multiple handler threads read upcall)"
> changes its type from U32 to UNSPEC, but leave the kernel
> unchanged
> 
> and after kernel 6e237d099fac "(netlink: Relax attr validation
> for fixed length types)", this bug is exposed by the below
> warning
> 
> 	[   57.215841] netlink: 'ovs-vswitchd': attribute type 5 has an invalid length.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Applied, and queued up for -stable, thanks.
