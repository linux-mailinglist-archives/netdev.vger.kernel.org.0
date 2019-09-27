Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3089C0B25
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfI0Sdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:33:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35330 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfI0Sdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:33:40 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85B0F153F0BB9;
        Fri, 27 Sep 2019 11:33:38 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:33:36 +0200 (CEST)
Message-Id: <20190927.203336.2041116983711339045.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/3] mlxsw: Various fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190926114340.9483-1-idosch@idosch.org>
References: <20190926114340.9483-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:33:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 26 Sep 2019 14:43:37 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset includes two small fixes for the mlxsw driver and one
> patch which clarifies recently introduced devlink-trap documentation.
> 
> Patch #1 clears the port's VLAN filters during port initialization. This
> ensures that the drop reason reported to the user is consistent. The
> problem is explained in detail in the commit message.
> 
> Patch #2 clarifies the description of one of the traps exposed via
> devlink-trap.
> 
> Patch #3 from Danielle forbids the installation of a tc filter with
> multiple mirror actions since this is not supported by the device. The
> failure is communicated to the user via extack.

Series applied.
