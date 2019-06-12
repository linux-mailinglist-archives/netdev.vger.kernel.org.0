Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E722542E5B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbfFLSIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:08:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfFLSIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:08:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C97E15283810;
        Wed, 12 Jun 2019 11:08:52 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:08:51 -0700 (PDT)
Message-Id: <20190612.110851.2217938591330502137.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/7] mlxsw: Various fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:08:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 11 Jun 2019 10:19:39 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset contains various fixes for mlxsw.
> 
> Patch #1 fixes an hash polarization problem when a nexthop device is a
> LAG device. This is caused by the fact that the same seed is used for
> the LAG and ECMP hash functions.
> 
> Patch #2 fixes an issue in which the driver fails to refresh a nexthop
> neighbour after it becomes dead. This prevents the nexthop from ever
> being written to the adjacency table and used to forward traffic. Patch
> #3 is a test case.
> 
> Patch #4 fixes a wrong extraction of TOS value in flower offload code.
> Patch #5 is a test case.
> 
> Patch #6 works around a buffer issue in Spectrum-2 by reducing the
> default sizes of the shared buffer pools.
> 
> Patch #7 prevents prio-tagged packets from entering the switch when PVID
> is removed from the bridge port.
> 
> Please consider patches #2, #4 and #6 for 5.1.y

Series applied and queued up for -stable.
