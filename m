Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E76263864
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgIIVU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIIVUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:20:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095DEC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 14:20:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D66C1298998B;
        Wed,  9 Sep 2020 14:03:34 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:20:20 -0700 (PDT)
Message-Id: <20200909.142020.1452856248828529591.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     parav@mellanox.com, netdev@vger.kernel.org, parav@nvidia.com
Subject: Re: [PATCH net-next v3 0/6] devlink show controller number
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909083442.5b820d72@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200909045038.63181-1-parav@mellanox.com>
        <20200909083442.5b820d72@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 14:03:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 9 Sep 2020 08:34:42 -0700

> On Wed,  9 Sep 2020 07:50:32 +0300 Parav Pandit wrote:
>> From: Parav Pandit <parav@nvidia.com>
>> 
>> Hi Jakub, Dave,
>> 
>> Currently a devlink instance that supports an eswitch handles eswitch
>> ports of two type of controllers.
>> (1) controller discovered on same system where eswitch resides.
>> This is the case where PCI PF/VF of a controller and devlink eswitch
>> instance both are located on a single system.
>> (2) controller located on external system.
>> This is the case where a controller is plugged in one system and its
>> devlink eswitch ports are located in a different system. In this case
>> devlink instance of the eswitch only have access to ports of the
>> controller.
>> However, there is no way to describe that a eswitch devlink port
>> belongs to which controller (mainly which external host controller).
>> This problem is more prevalent when port attribute such as PF and VF
>> numbers are overlapping between multiple controllers of same eswitch.
>> Due to this, for a specific switch_id, unique phys_port_name cannot
>> be constructed for such devlink ports.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
