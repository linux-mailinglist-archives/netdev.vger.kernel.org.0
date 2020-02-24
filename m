Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC4B16B4EB
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgBXXMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:12:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgBXXMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:12:31 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 926D01241F153;
        Mon, 24 Feb 2020 15:12:30 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:12:25 -0800 (PST)
Message-Id: <20200224.151225.1263267218414504053.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, shawnguo@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/2] Remainder for "DT bindings for Felix
 DSA switch on LS1028A"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224121534.29679-1-olteanv@gmail.com>
References: <20200224121534.29679-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:12:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 24 Feb 2020 14:15:32 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series is the remainder of patchset [0] which has been merged
> through Shawn Guo's devicetree tree.
> 
> It contains changes to the PHY mode validation in the Felix driver
> ("gmii" to "internal") and the documentation for the DT bindings.
> 
> [0]: https://patchwork.ozlabs.org/cover/1242716/

Series applied, thanks.
