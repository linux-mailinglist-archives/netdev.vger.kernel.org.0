Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34D2161D66
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgBQWhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:37:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgBQWhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:37:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6C4C15AA8196;
        Mon, 17 Feb 2020 14:37:00 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:37:00 -0800 (PST)
Message-Id: <20200217.143700.570694578372290215.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next] net: bridge: teach ndo_dflt_bridge_getlink()
 more brport flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217134501.97044-1-jwi@linux.ibm.com>
References: <20200217134501.97044-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:37:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon, 17 Feb 2020 14:45:01 +0100

> This enables ndo_dflt_bridge_getlink() to report a bridge port's
> offload settings for multicast and broadcast flooding.
> 
> CC: Roopa Prabhu <roopa@cumulusnetworks.com>
> CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied, thanks.
