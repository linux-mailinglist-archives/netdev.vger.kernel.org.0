Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6D11484C9
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbgAXL7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:59:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39550 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgAXL7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 06:59:32 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30948158B6EE7;
        Fri, 24 Jan 2020 03:59:25 -0800 (PST)
Date:   Fri, 24 Jan 2020 12:58:33 +0100 (CET)
Message-Id: <20200124.125833.809170017035214921.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/4] net: bridge: add per-vlan state option
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
References: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jan 2020 03:59:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Fri, 24 Jan 2020 13:40:18 +0200

> This set adds the first per-vlan option - state, which uses the new vlan
> infrastructure that was recently added. It gives us forwarding control on
> per-vlan basis. The first 3 patches prepare the vlan code to support option
> dumping and modification. We still compress vlan ranges which have equal
> options, each new option will have to add its own equality check to
> br_vlan_opts_eq(). The vlans are created in forwarding state by default to
> be backwards compatible and vlan state is considered only when the port
> state is forwarding (more info in patch 4).
> I'll send the selftest for the vlan state with the iproute2 patch-set.
> 
> v2: patch 3: do full (all-vlan) notification only on vlan
>     create/delete, otherwise use the per-vlan notifications only,
>     rework how option change ranges are detected, add more verbose error
>     messages when setting options and add checks if a vlan should be used.

Series applied, thanks.
