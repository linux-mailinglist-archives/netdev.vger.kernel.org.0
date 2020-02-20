Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC9B166B2C
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgBTXtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:49:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60384 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbgBTXtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:49:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8A6415BDA725;
        Thu, 20 Feb 2020 15:49:12 -0800 (PST)
Date:   Thu, 20 Feb 2020 15:48:45 -0800 (PST)
Message-Id: <20200220.154845.660550523925122796.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] ionic: fix fw_status read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219225942.34005-1-snelson@pensando.io>
References: <20200219225942.34005-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 15:49:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed, 19 Feb 2020 14:59:42 -0800

> The fw_status field is only 8 bits, so fix the read.  Also,
> we only want to look at the one status bit, to allow for future
> use of the other bits, and watch for a bad PCI read.
> 
> Fixes: 97ca486592c0 ("ionic: add heartbeat check")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied and queued up for -stable, thanks.
