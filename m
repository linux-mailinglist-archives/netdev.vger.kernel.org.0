Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963A221DF7F
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGMSXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGMSXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:23:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F99C061794
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 11:23:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C968129549BA;
        Mon, 13 Jul 2020 11:23:14 -0700 (PDT)
Date:   Mon, 13 Jul 2020 11:23:11 -0700 (PDT)
Message-Id: <20200713.112311.1759350279713109431.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        sfr@canb.auug.org.au
Subject: Re: [PATCH net-next] net: bridge: fix undefined
 br_vlan_can_enter_range in tunnel code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713075546.1147199-1-nikolay@cumulusnetworks.com>
References: <20200713075546.1147199-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 11:23:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Mon, 13 Jul 2020 10:55:46 +0300

> If bridge vlan filtering is not defined we won't have
> br_vlan_can_enter_range and thus will get a compile error as was
> reported by Stephen and the build bot. So let's define a stub for when
> vlan filtering is not used.
> 
> Fixes: 94339443686b ("net: bridge: notify on vlan tunnel changes done via the old api")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied, thanks for fixing this.
