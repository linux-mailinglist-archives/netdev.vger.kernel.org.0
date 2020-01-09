Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2175136086
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388603AbgAISwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:52:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730541AbgAISwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 13:52:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12AA1158477F3;
        Thu,  9 Jan 2020 10:52:38 -0800 (PST)
Date:   Thu, 09 Jan 2020 10:52:37 -0800 (PST)
Message-Id: <20200109.105237.1514181450032103034.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: allow TSO on VXLAN over VLAN
 topologies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c1f4cc6214c28ce9a39147db9f3b66927dbae612.1578567988.git.dcaratti@redhat.com>
References: <c1f4cc6214c28ce9a39147db9f3b66927dbae612.1578567988.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 10:52:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Thu,  9 Jan 2020 12:07:59 +0100

> since mlx5 hardware can segment correctly TSO packets on VXLAN over VLAN
> topologies, CPU usage can improve significantly if we enable tunnel
> offloads in dev->vlan_features, like it was done in the past with other
> NIC drivers (e.g. mlx4, be2net and ixgbe).
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Saeed, I am assuming you will review and integrate this.

Thank you.
