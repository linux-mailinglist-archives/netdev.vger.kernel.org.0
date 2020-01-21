Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1FA143B97
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgAULEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:04:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgAULEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 06:04:35 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9379815C1C487;
        Tue, 21 Jan 2020 03:04:33 -0800 (PST)
Date:   Tue, 21 Jan 2020 12:04:31 +0100 (CET)
Message-Id: <20200121.120431.383848060907605203.davem@davemloft.net>
To:     alex.shi@linux.alibaba.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp/ipv4: remove AF_INET_FAMILY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579596607-258481-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1579596607-258481-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 03:04:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Date: Tue, 21 Jan 2020 16:50:07 +0800

> After commit 079096f103fa ("tcp/dccp: install syn_recv requests into ehash table")
> the macro isn't used anymore. remove it.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>

Applied to net-next
