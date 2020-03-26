Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9291946D5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgCZSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:55:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgCZSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:55:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E55A415CBC249;
        Thu, 26 Mar 2020 11:55:56 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:55:55 -0700 (PDT)
Message-Id: <20200326.115555.620787715117935635.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/6] mlxsw: Offload TC action pedit munge
 dsfield
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326140114.1393972-1-idosch@idosch.org>
References: <20200326140114.1393972-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:55:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 26 Mar 2020 16:01:08 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> The Spectrum switches allow packet prioritization based on DSCP on ingress,
> and update of DSCP on egress. This is configured through the DCB APP rules.
> For some use cases, assigning a custom DSCP value based on an ACL match is
> a better tool. To that end, offload FLOW_ACTION_MANGLE to permit changing
> of dsfield as a whole, or DSCP and ECN values in isolation.
> 
> After fixing a commentary nit in patch #1, and mlxsw naming in patch #2,
> patches #3 and #4 add the offload to mlxsw.
> 
> Patch #5 adds a forwarding selftest for pedit dsfield, applicable to SW as
> well as HW datapaths. Patch #6 adds a mlxsw-specific test to verify DSCP
> rewrite due to DCB APP rules is not performed on pedited packets.
> 
> The tests only cover IPv4 dsfield setting. We have tests for IPv6 as well,
> but would like to postpone their contribution until the corresponding
> iproute patches have been accepted.

Series applied, thanks.
