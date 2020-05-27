Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995771E4D4E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgE0Srw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgE0Srg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:47:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59056C08C5C9;
        Wed, 27 May 2020 11:30:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A790B128B2F53;
        Wed, 27 May 2020 11:30:55 -0700 (PDT)
Date:   Wed, 27 May 2020 11:30:55 -0700 (PDT)
Message-Id: <20200527.113055.1994967996705658293.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     nikolay@cumulusnetworks.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, mkubecek@suse.cz,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2] bridge: mrp: Rework the MRP netlink
 interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527123430.616826-1-horatiu.vultur@microchip.com>
References: <20200527123430.616826-1-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:30:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Wed, 27 May 2020 12:34:30 +0000

> This patch reworks the MRP netlink interface. Before, each attribute
> represented a binary structure which made it hard to be extended.
> Therefore update the MRP netlink interface such that each existing
> attribute to be a nested attribute which contains the fields of the
> binary structures.
> In this way the MRP netlink interface can be extended without breaking
> the backwards compatibility. It is also using strict checking for
> attributes under the MRP top attribute.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Applied, thanks.
