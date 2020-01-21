Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E73143B95
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAULE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:04:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgAULE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 06:04:27 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37BBF15C1C486;
        Tue, 21 Jan 2020 03:04:26 -0800 (PST)
Date:   Tue, 21 Jan 2020 12:04:24 +0100 (CET)
Message-Id: <20200121.120424.703038534084567073.davem@davemloft.net>
To:     alex.shi@linux.alibaba.com
Cc:     arvid.brodin@alten.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/hsr: remove seq_nr_after_or_eq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579596593-258202-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1579596593-258202-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 03:04:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Date: Tue, 21 Jan 2020 16:49:53 +0800

> It's never used after introduced. So maybe better to remove.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>

Applied to net-next
