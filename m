Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943022707B7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgIRVFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRVFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:05:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61722C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:05:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9B401594F3BC;
        Fri, 18 Sep 2020 13:48:11 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:04:57 -0700 (PDT)
Message-Id: <20200918.140457.1532137508491847343.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com
Subject: Re: [net-next v6 0/5] devlink flash update overwrite mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918004529.533989-1-jacob.e.keller@intel.com>
References: <20200918004529.533989-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:48:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu, 17 Sep 2020 17:45:24 -0700

> This series introduces support for a new attribute to the flash update
> command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.
> 
> This attribute is a bitfield which allows userspace to specify what set of
> subfields to overwrite when performing a flash update for a device.
> 
> The intention is to support the ability to control the behavior of
> overwriting the configuration and identifying fields in the Intel ice device
> flash update process. This is necessary  as the firmware layout for the ice
> device includes some settings and configuration within the same flash
> section as the main firmware binary.
 ...

There are a lot of rejects due to some recent mlxsw changes, could you
please respin?

Thank you.
