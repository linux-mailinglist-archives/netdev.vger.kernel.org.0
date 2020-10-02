Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01135281EED
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJBXNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:13:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0643FC0613D0;
        Fri,  2 Oct 2020 16:13:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC16111E58441;
        Fri,  2 Oct 2020 15:56:31 -0700 (PDT)
Date:   Fri, 02 Oct 2020 16:13:18 -0700 (PDT)
Message-Id: <20201002.161318.726844448692603677.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, shawnguo@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/10] arm64: dts: layerscape: update MAC
 nodes with PHY information
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002210737.27645-1-ioana.ciornei@nxp.com>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:56:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Sat,  3 Oct 2020 00:07:27 +0300

> This patch set aims to add the necessary DTS nodes to complete the
> MAC/PCS/PHY representation on DPAA2 devices. The external MDIO bus nodes
> and the PHYs found on them are added, along with the PCS MDIO internal
> buses and their PCS PHYs. Also, links to these PHYs are added from the
> DPMAC node.
> 
> I am resending these via netdev because I am not really sure if Shawn is
> still able to take them in time for 5.10 since his last activity on the
> tree has been some time ago.
> I tested them on linux-next and there are no conflicts.
> 
> Changes in v2:
>  - documented the dpmac node into a new yaml entry
>  - dropped the '0x' from some unit addresses

I don't feel comfortable taking such a sizable set of DT changes into
the networking tree rather than the devicetree or ARM tree(s).

I know we're fast and more responsive than the other subsystems (by
several orders of magnitude) but that isn't a reason to bypass the
correct tree for these changes.

Thank you.
