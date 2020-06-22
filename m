Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BDC20447B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgFVXce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgFVXce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:32:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07040C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:32:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79B0812972178;
        Mon, 22 Jun 2020 16:32:32 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:32:31 -0700 (PDT)
Message-Id: <20200622.163231.1180767429643053835.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/4] mlxsw: Offload TC action pedit munge
 tcp/udp sport/dport
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621083436.476806-1-idosch@idosch.org>
References: <20200621083436.476806-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:32:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 21 Jun 2020 11:34:32 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> On Spectrum-2 and Spectrum-3, it is possible to overwrite L4 port number of
> a TCP or UDP packet in the ACL engine. That corresponds to the pedit munges
> of tcp and udp sport resp. dport fields. Offload these munges on the
> systems where they are supported.
> 
> The current offloading code assumes that all systems support the same set
> of fields. This now changes, so in patch #1 first split handling of pedit
> munges by chip type. The analysis of which packet field a given munge
> describes is kept generic.
> 
> Patch #2 introduces the new flexible action fields. Patch #3 then adds the
> new pedit fields, and dispatches on them on Spectrum>1.
> 
> Patch #4 adds a forwarding selftest for pedit dsfield, applicable to SW as
> well as HW datapaths.

Series applied to net-next, thank you.
