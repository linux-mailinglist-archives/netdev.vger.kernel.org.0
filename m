Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0451EC2C9
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFBTdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBTdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 15:33:14 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F382206E2;
        Tue,  2 Jun 2020 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591126393;
        bh=/IsSFhp40i8XV+E3whEUfoTlBm/Q7KCWnAImB6EGDEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qiTxBilO0egDU1eUfhuP7bZYs61+jwKwiXhcF0gbh9q54gzceaDSHqRipkOJjrjEl
         g0Z8zCJWgUHGLAufNNe8l4vGORbQE1JTHwJr6CcvI0Z0m1s5BSXJpIkcNX0RJ91JuZ
         jCHbSjeSq7p/qwolNKcTkMHrlNOAdJg1PzNbSuvI=
Date:   Tue, 2 Jun 2020 12:33:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, snelson@pensando.io, drivers@pensando.io,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        mlxsw@mellanox.com
Subject: Re: [RFC PATCH net-next 0/8] Expose devlink port attributes
Message-ID: <20200602123311.32bb062c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jun 2020 14:31:11 +0300 Danielle Ratson wrote:
> Currently, user has no way of knowing if a port can be split and into
> how many ports.
> 
> Among other things, it is currently impossible to write generic tests
> for port split.
> 
> In order to be able to expose the information regarding the split
> capability to user space, set the required attributes and pass them to
> netlink.
> 
> Patch 1: Move set attribute from devlink_port_attrs to devlink_port.
> Patch 2: Move switch_port attribute from devlink_port_attrs to devlink_port
> Patch 3: Replace devlink_port_attrs_set parameters with a struct.
> Patch 4: Set and initialize lanes attribute in the driver.
> Patch 5: Add lanes attribute to devlink port and pass to netlink.
> Patch 6: Set and initialize splittable attribute in the driver.
> Patch 7: Add splittable attribute to devlink port and pass them to netlink.
> Patch 8: Add a split port test.

Since we have the splitability and number of lanes now understood by
the core - can the code also start doing more input checking?
