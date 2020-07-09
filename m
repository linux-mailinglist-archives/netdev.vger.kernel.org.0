Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E5C21A8C8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGIUQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIUQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:16:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D908C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 13:16:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2E8D120F19C4;
        Thu,  9 Jul 2020 13:16:23 -0700 (PDT)
Date:   Thu, 09 Jul 2020 13:16:22 -0700 (PDT)
Message-Id: <20200709.131622.1310118724530519195.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v3 0/9] Expose port split attributes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 13:16:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  9 Jul 2020 16:18:13 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Danielle says:
> 
> Currently, user space has no way of knowing if a port can be split and
> into how many ports. Among other things, this makes it impossible to
> write generic tests for port split functionality.
> 
> Therefore, this set exposes two new devlink port attributes to user
> space: Number of lanes and whether the port can be split or not.
> 
> Patch set overview:
> 
> Patches #1-#4 cleanup 'struct devlink_port_attrs' and reduce the number
> of parameters passed between drivers and devlink via
> devlink_port_attrs_set()
> 
> Patch #5 adds devlink port lanes attributes
> 
> Patches #6-#7 add devlink port splittable attribute
> 
> Patch #8 exploits the fact that devlink is now aware of port's number of
> lanes and whether the port can be split or not and moves some checks
> from drivers to devlink
> 
> Patch #9 adds a port split test
> 
> Changes since v2:
> * Remove some local variables from patch #3
> * Reword function description in patch #5
> * Fix a bug in patch #8
> * Add a test for the splittable attribute in patch #9
> 
> Changes since v1:
> * Rename 'width' attribute to 'lanes'
> * Add 'splittable' attribute
> * Move checks from drivers to devlink

Series applied, thanks everyone.
