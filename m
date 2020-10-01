Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD67B28083F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 22:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbgJAUKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 16:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgJAUKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 16:10:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF34C0613D0;
        Thu,  1 Oct 2020 13:10:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3252148489AD;
        Thu,  1 Oct 2020 12:53:18 -0700 (PDT)
Date:   Thu, 01 Oct 2020 13:10:05 -0700 (PDT)
Message-Id: <20201001.131005.812058315852168053.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, andrew@lunn.ch
Subject: Re: [PATCH v3 devicetree 0/2] Add Seville Ethernet switch to
 T1040RDB
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001132013.1866299-1-vladimir.oltean@nxp.com>
References: <20201001132013.1866299-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:53:19 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Thu,  1 Oct 2020 16:20:11 +0300

> Seville is a DSA switch that is embedded inside the T1040 SoC, and
> supported by the mscc_seville DSA driver inside drivers/net/dsa/ocelot.
> 
> This series adds this switch to the SoC's dtsi files and to the T1040RDB
> board file.

I am assuming the devicetree folks will pick this series up.

Thanks.

