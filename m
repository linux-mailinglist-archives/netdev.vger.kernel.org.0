Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F9C1665DE
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgBTSKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:10:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbgBTSKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:10:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E16DE15AC0C32;
        Thu, 20 Feb 2020 10:10:46 -0800 (PST)
Date:   Thu, 20 Feb 2020 10:10:46 -0800 (PST)
Message-Id: <20200220.101046.2297771829583296710.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, johannes@sipsolutions.net,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next] net: use netif_is_bridge_port() to check for
 IFF_BRIDGE_PORT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220080007.51862-1-jwi@linux.ibm.com>
References: <20200220080007.51862-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 10:10:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 20 Feb 2020 09:00:07 +0100

> Trivial cleanup, so that all bridge port-specific code can be found in
> one go.
> 
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Roopa Prabhu <roopa@cumulusnetworks.com>
> CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied.
