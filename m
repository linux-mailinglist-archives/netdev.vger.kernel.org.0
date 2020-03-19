Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9CF18C2F2
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCSWYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgCSWYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 18:24:15 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C47F20663;
        Thu, 19 Mar 2020 22:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584656654;
        bh=bpgyourbAhbxdgT4tSVutkZGxa0e5VrzunoBKhpOYnY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CXfjfLpjwcmwR+ZgPhPDygRlvzb/wM1+Mn/RWleQhLifsE16iinRXw50wB5li5lVM
         hOP/uQJpwQcPaOy+09Ac+6v5C8eT2piGP+CzD9N/AAtb8UGcet9WgQlFwlY7z7O/8e
         EVf28eXPodQFGKOJB5G+8HWHTB17hgKjHE2rIbbY=
Date:   Thu, 19 Mar 2020 15:24:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/5] mlxsw: Offload TC action skbedit priority
Message-ID: <20200319152412.088acba3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200319134724.1036942-1-idosch@idosch.org>
References: <20200319134724.1036942-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 15:47:19 +0200 Ido Schimmel wrote:
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

FWIW:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
