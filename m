Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3DC12F1DE
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgABXl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:41:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgABXl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:41:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 364EB1570788F;
        Thu,  2 Jan 2020 15:41:57 -0800 (PST)
Date:   Thu, 02 Jan 2020 15:41:56 -0800 (PST)
Message-Id: <20200102.154156.1391004203938658034.davem@davemloft.net>
To:     niu_xilei@163.com
Cc:     petrm@mellanox.com, sbrivio@redhat.com, edumazet@google.com,
        roopa@cumulusnetworks.com, ap420073@gmail.com,
        jiaolitao@raisecom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vxlan: Fix alignment and code style of vxlan.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191230095222.21328-1-niu_xilei@163.com>
References: <20191230095222.21328-1-niu_xilei@163.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 15:41:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niu Xilei <niu_xilei@163.com>
Date: Mon, 30 Dec 2019 17:52:22 +0800

> Fixed Coding function and style issues
> 
> Signed-off-by: Niu Xilei <niu_xilei@163.com>

Applied to net-next, thanks.
