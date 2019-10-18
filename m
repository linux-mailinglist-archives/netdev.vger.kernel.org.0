Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F41DCFD7
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440198AbfJRUQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:16:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbfJRUQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:16:25 -0400
Received: from localhost (unknown [8.46.73.196])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BD1612651D7B;
        Fri, 18 Oct 2019 13:16:22 -0700 (PDT)
Date:   Fri, 18 Oct 2019 13:16:16 -0700 (PDT)
Message-Id: <20191018.131616.1212114496307486279.davem@davemloft.net>
To:     alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, vz@mleia.com, slemieux.tyco@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v3 0/2] net: lpc_eth: parse phy nodes from
 device tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017222231.29122-1-alexandre.belloni@bootlin.com>
References: <20191017222231.29122-1-alexandre.belloni@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 13:16:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date: Fri, 18 Oct 2019 00:22:29 +0200

> Allow describing connected phys using device tree. This solves issues finding
> the phy on the mdio bus and allows decribing the interrupt line the phy is
> possibly connected to.
> 
> Changes in v3:
>  - rebased on net-next
>  - collected Reviewed-by
> 
> Changes in v2:
>  - move the phy decription in the mdio subnode.

Series applied to net-next, thank you.
