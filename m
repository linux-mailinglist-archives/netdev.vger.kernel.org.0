Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB02A14A13A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgA0JzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:55:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgA0JzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:55:02 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57F781502E6D6;
        Mon, 27 Jan 2020 01:55:00 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:54:58 +0100 (CET)
Message-Id: <20200127.105458.1313122542866701833.davem@davemloft.net>
To:     sworley@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        sharpd@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: Re: [PATCH] net: include struct nhmsg size in nh nlmsg size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124215327.430193-1-sworley@cumulusnetworks.com>
References: <20200124215327.430193-1-sworley@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:55:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Worley <sworley@cumulusnetworks.com>
Date: Fri, 24 Jan 2020 16:53:27 -0500

> Include the size of struct nhmsg size when calculating
> how much of a payload to allocate in a new netlink nexthop
> notification message.
> 
> Without this, we will fail to fill the skbuff at certain nexthop
> group sizes.
> 
> You can reproduce the failure with the following iproute2 commands:
 ...
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>

Applied and queued up for -stable, thanks.
