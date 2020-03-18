Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0227118A96C
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgCRXqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:46:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRXqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:46:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DA8E155379A5;
        Wed, 18 Mar 2020 16:46:36 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:46:36 -0700 (PDT)
Message-Id: <20200318.164636.2101956120165364730.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/9] mlxsw: spectrum_cnt: Expose counter
 resources
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:46:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 18 Mar 2020 15:48:48 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jiri says:
> 
> Capacity and utilization of existing flow and RIF counters are currently
> unavailable to be seen by the user. Use the existing devlink resources
> API to expose the information:
> 
> $ sudo devlink resource show pci/0000:00:10.0 -v
> pci/0000:00:10.0:
>   name kvd resource_path /kvd size 524288 unit entry dpipe_tables none
>   name span_agents resource_path /span_agents size 8 occ 0 unit entry dpipe_tables none
>   name counters resource_path /counters size 79872 occ 44 unit entry dpipe_tables none
>     resources:
>       name flow resource_path /counters/flow size 61440 occ 4 unit entry dpipe_tables none
>       name rif resource_path /counters/rif size 18432 occ 40 unit entry dpipe_tables none

Series applied, thanks everyone.
