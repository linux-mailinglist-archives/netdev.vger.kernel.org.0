Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4018C646
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCTEJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:09:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgCTEJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:09:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A32C158F9872;
        Thu, 19 Mar 2020 21:09:39 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:09:39 -0700 (PDT)
Message-Id: <20200319.210939.448284811013875625.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] mlxsw: Offload TC action skbedit priority
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319134724.1036942-1-idosch@idosch.org>
References: <20200319134724.1036942-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:09:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 19 Mar 2020 15:47:19 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> The TC action "skbedit priority P" has the effect of assigning skbprio of P
> to SKBs that it's applied on. In HW datapath of a switch, the corresponding
> action is assignment of internal switch priority. Spectrum switches allow
> setting of packet priority based on an ACL action, which is good match for
> the skbedit priority gadget. This patchset therefore implements offloading
> of this action to the Spectrum ACL engine.
> 
> After a bit of refactoring in patch #1, patch #2 extends the skbedit action
> to support offloading of "priority" subcommand.
> 
> On mlxsw side, in patch #3, the QOS_ACTION flexible action is added, with
> fields necessary for priority adjustment. In patch #4, "skbedit priority"
> is connected to that action.
> 
> Patch #5 implements a new forwarding selftest, suitable for both SW- and
> HW-datapath testing.

Looks quite straightforward, applied, thanks.
