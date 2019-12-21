Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A0F1287A4
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbfLUFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:46:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:46:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 214DA153D88B3;
        Fri, 20 Dec 2019 21:46:03 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:46:02 -0800 (PST)
Message-Id: <20191220.214602.2012066260506533424.davem@davemloft.net>
To:     manishc@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com
Subject: Re: [PATCH net 1/1] qede: Disable hardware gro when xdp prog is
 installed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191219183516.7017-1-manishc@marvell.com>
References: <20191219183516.7017-1-manishc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:46:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>
Date: Thu, 19 Dec 2019 10:35:16 -0800

> commit 18c602dee472 ("qede: Use NETIF_F_GRO_HW.") introduced
> a regression in driver that when xdp program is installed on
> qede device, device's aggregation feature (hardware GRO) is not
> getting disabled, which is unexpected with xdp.
> 
> Fixes: 18c602dee472 ("qede: Use NETIF_F_GRO_HW.")
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

Applied and queued up for -stable, thanks.
