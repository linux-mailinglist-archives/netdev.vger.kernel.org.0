Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66F317868E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 00:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgCCXk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:40:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgCCXk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:40:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F1F415AA10BA;
        Tue,  3 Mar 2020 15:40:56 -0800 (PST)
Date:   Tue, 03 Mar 2020 15:40:55 -0800 (PST)
Message-Id: <20200303.154055.1783483455182489337.davem@davemloft.net>
To:     parav@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        moshe@mellanox.com, vladyslavt@mellanox.com, saeedm@mellanox.com,
        leon@kernel.org
Subject: Re: [PATCH net-next 0/2] devlink: Introduce devlink port flavour
 virtual
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303141243.7608-1-parav@mellanox.com>
References: <20200303141243.7608-1-parav@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 15:40:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>
Date: Tue,  3 Mar 2020 08:12:41 -0600

> Currently PCI PF and VF devlink devices register their ports as
> physical port in non-representors mode.
> 
> Introduce a new port flavour as virtual so that virtual devices can
> register 'virtual' flavour to make it more clear to users.
> 
> An example of one PCI PF and 2 PCI virtual functions, each having
> one devlink port.
> 
> $ devlink port show
> pci/0000:06:00.0/1: type eth netdev ens2f0 flavour physical port 0
> pci/0000:06:00.2/1: type eth netdev ens2f2 flavour virtual port 0
> pci/0000:06:00.3/1: type eth netdev ens2f3 flavour virtual port 0
> 
> Patch summary:
> Patch-1 Introduces new devlink port flavour 'virtual'.
> Patch-2 Uses new flavour to register PCI VF virtual ports.

Series applied, thanks Parav.
