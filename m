Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CBF2000EE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgFSDpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgFSDpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:45:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1CEC06174E;
        Thu, 18 Jun 2020 20:45:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B5655120ED49C;
        Thu, 18 Jun 2020 20:45:08 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:45:08 -0700 (PDT)
Message-Id: <20200618.204508.1827331900997451321.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix node reference count
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618034245.29928-1-f.fainelli@gmail.com>
References: <20200618034245.29928-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:45:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 17 Jun 2020 20:42:44 -0700

> of_find_node_by_name() will do an of_node_put() on the "from" argument.
> With CONFIG_OF_DYNAMIC enabled which checks for device_node reference
> counts, we would be getting a warning like this:
 ...
> Fix this by adding a of_node_get() to increment the reference count
> prior to the call.
> 
> Fixes: afa3b592953b ("net: dsa: bcm_sf2: Ensure correct sub-node is parsed")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for v5.7 -stable, thanks.
