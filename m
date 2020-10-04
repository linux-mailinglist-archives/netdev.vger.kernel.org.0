Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A593282782
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgJDADG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgJDADG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:03:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B64FC0613D0;
        Sat,  3 Oct 2020 17:03:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21E9F11E3E4CA;
        Sat,  3 Oct 2020 16:46:17 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:03:03 -0700 (PDT)
Message-Id: <20201003.170303.263984023177569654.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, andrew@lunn.ch
Subject: Re: [PATCH v4 net-next 0/2] Add Seville Ethernet switch to T1040RDB
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002134106.3485970-1-vladimir.oltean@nxp.com>
References: <20201002134106.3485970-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:46:17 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri,  2 Oct 2020 16:41:04 +0300

> Seville is a DSA switch that is embedded inside the T1040 SoC, and
> supported by the mscc_seville DSA driver inside drivers/net/dsa/ocelot.
> 
> This series adds this switch to the SoC's dtsi files and to the T1040RDB
> board file.
> 
> I would like to send this series through net-next. There is no conflict
> with other patches submitted to T1040 device tree. Maybe this could at
> least get an ACK from devicetree maintainers.

Series applied, thank you.
