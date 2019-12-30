Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C397F12D4DB
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfL3Wlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:41:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbfL3Wlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 17:41:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3F4A1555A0B8;
        Mon, 30 Dec 2019 14:41:31 -0800 (PST)
Date:   Mon, 30 Dec 2019 14:41:31 -0800 (PST)
Message-Id: <20191230.144131.1699488284422282142.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, surendra@chelsio.com
Subject: Re: [PATCH net] cxgb4/cxgb4vf: fix flow control display for auto
 negotiation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577709848-6417-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1577709848-6417-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 14:41:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Mon, 30 Dec 2019 18:14:08 +0530

> As per 802.3-2005, Section Two, Annex 28B, Table 28B-2 [1], when
> _only_ Rx pause is enabled, both symmetric and asymmetric pause
> towards local device must be enabled. Also, firmware returns the local
> device's flow control pause params as part of advertised capabilities
> and negotiated params as part of current link attributes. So, fix up
> ethtool's flow control pause params fetch logic to read from acaps,
> instead of linkattr.
> 
> [1] https://standards.ieee.org/standard/802_3-2005.html
> 
> Fixes: c3168cabe1af ("cxgb4/cxgbvf: Handle 32-bit fw port capabilities")
> Signed-off-by: Surendra Mobiya <surendra@chelsio.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied and queued up for -stable, thanks.
