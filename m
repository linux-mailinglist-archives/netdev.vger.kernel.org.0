Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D865F35236
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFDVtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:49:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52978 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfFDVtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:49:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0F7B15015EB0;
        Tue,  4 Jun 2019 14:49:52 -0700 (PDT)
Date:   Tue, 04 Jun 2019 14:49:52 -0700 (PDT)
Message-Id: <20190604.144952.1353373326253870063.davem@davemloft.net>
To:     lariel@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Support MPLS features in bonding and vlan
 net devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559601394-5363-1-git-send-email-lariel@mellanox.com>
References: <1559601394-5363-1-git-send-email-lariel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 14:49:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>
Date: Mon, 3 Jun 2019 22:36:45 +0000

> Netdevice HW MPLS features are not passed from device driver's netdevice to
> upper netdevice, specifically VLAN and bonding netdevice which are created
> by the kernel when needed.
> 
> This prevents enablement and usage of HW offloads, such as TSO and checksumming
> for MPLS tagged traffic when running via VLAN or bonding interface.
> 
> The patches introduce changes to the initialization steps of the VLAN and bonding
> netdevices to inherit the MPLS features from lower netdevices to allow the HW
> offloads.

Series applied, thanks.
