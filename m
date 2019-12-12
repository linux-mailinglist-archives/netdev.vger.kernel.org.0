Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF7E11D6D7
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbfLLTJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:09:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730096AbfLLTJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:09:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CC81153E164D;
        Thu, 12 Dec 2019 11:09:09 -0800 (PST)
Date:   Thu, 12 Dec 2019 11:09:09 -0800 (PST)
Message-Id: <20191212.110909.1254452992283106976.davem@davemloft.net>
To:     manishc@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com
Subject: Re: [PATCH net 1/1] qede: Fix multicast mac configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191212144928.509-1-manishc@marvell.com>
References: <20191212144928.509-1-manishc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 11:09:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>
Date: Thu, 12 Dec 2019 06:49:28 -0800

> Driver doesn't accommodate the configuration for max number
> of multicast mac addresses, in such particular case it leaves
> the device with improper/invalid multicast configuration state,
> causing connectivity issues (in lacp bonding like scenarios).
> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

Applied and queued up for -stable.
