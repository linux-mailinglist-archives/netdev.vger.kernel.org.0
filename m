Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FDC2043A9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgFVWaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgFVWaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:30:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644A6C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 15:30:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4155C12969E30;
        Mon, 22 Jun 2020 15:30:01 -0700 (PDT)
Date:   Mon, 22 Jun 2020 15:29:58 -0700 (PDT)
Message-Id: <20200622.152958.364606546607888736.davem@davemloft.net>
To:     parav@mellanox.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, kuba@kernel.org,
        jiri@mellanox.com
Subject: Re: [PATCH net-next 0/9] devlink: Support get,set mac address of a
 port function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619033255.163-1-parav@mellanox.com>
References: <20200619033255.163-1-parav@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 15:30:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>
Date: Fri, 19 Jun 2020 03:32:46 +0000

> Currently, ip link set dev <pfndev> vf <vf_num> <param> <value> has
> below few limitations.
> 
> 1. Command is limited to set VF parameters only.
> It cannot set the default MAC address for the PCI PF.
> 
> 2. It can be set only on system where PCI SR-IOV capability exists.
> In smartnic based system, eswitch of a NIC resides on a different
> embedded cpu which has the VF and PF representors for the SR-IOV
> functions of a host system in which this smartnic is plugged-in.
> 
> 3. It cannot setup the function attributes of sub-function described
> in detail in comprehensive RFC [1] and [2].
> 
> This series covers the first small part to let user query and set MAC
> address (hardware address) of a PCI PF/VF which is represented by
> devlink port pcipf, pcivf port flavours respectively.
> 
> Whenever a devlink port manages a function connected to a devlink port,
> it allows to query and set its hardware address.
> 
> Driver implements necessary get/set callback functions if it supports
> port function for a given port type.
 ...

Series applied, thank you.
