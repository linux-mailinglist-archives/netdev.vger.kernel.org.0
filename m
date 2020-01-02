Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D0C12F1DC
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgABXkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:40:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgABXkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:40:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB7FE156EF06E;
        Thu,  2 Jan 2020 15:40:34 -0800 (PST)
Date:   Thu, 02 Jan 2020 15:40:34 -0800 (PST)
Message-Id: <20200102.154034.2123269473192368005.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/3] mlxsw: Allow setting default port priority
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191229114829.61803-1-idosch@idosch.org>
References: <20191229114829.61803-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 15:40:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 29 Dec 2019 13:48:26 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> When LLDP APP TLV selector 1 (EtherType) is used with PID of 0, the
> corresponding entry specifies "default application priority [...] when
> application priority is not otherwise specified."
> 
> mlxsw currently supports this type of APP entry, but uses it only as a
> fallback for unspecified DSCP rules. However non-IP traffic is prioritized
> according to port-default priority, not according to the DSCP-to-prio
> tables, and thus it's currently not possible to prioritize such traffic
> correctly.
> 
> This patchset extends the use of the abovementioned APP entry to also set
> default port priority (in patches #1 and #2) and then (in patch #3) adds a
> selftest.

Series applied, thanks Ido.

Always nice to see those test cases.
