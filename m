Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893BF169D6E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 06:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgBXFQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 00:16:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgBXFQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 00:16:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AC191553101A;
        Sun, 23 Feb 2020 21:16:12 -0800 (PST)
Date:   Sun, 23 Feb 2020 21:16:11 -0800 (PST)
Message-Id: <20200223.211611.73759908601322562.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] igmp: remove unused macro
 IGMP_Vx_UNSOLICITED_REPORT_INTERVAL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582445143-12129-1-git-send-email-lirongqing@baidu.com>
References: <1582445143-12129-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 21:16:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Sun, 23 Feb 2020 16:05:43 +0800

> After commit 2690048c01f3 ("net: igmp: Allow user-space
> configuration of igmp unsolicited report interval"), they
> are not used now
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Applied, thanks.
