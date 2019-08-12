Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465D18A944
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfHLVZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:25:47 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50838 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727434AbfHLVZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:25:47 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxHp3-0004cR-S6; Mon, 12 Aug 2019 23:25:45 +0200
Date:   Mon, 12 Aug 2019 23:25:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Todd Seidelmann <tseidelmann@linode.com>
Cc:     netdev@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net] netfilter: ebtables: Fix argument order to
 ADD_COUNTER
Message-ID: <20190812212545.le2m7vsihcyk7ti6@breakpoint.cc>
References: <00a6c489-dc5b-d66f-f06d-b8785acb50e7@linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a6c489-dc5b-d66f-f06d-b8785acb50e7@linode.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Todd Seidelmann <tseidelmann@linode.com> wrote:
> The ordering of arguments to the x_tables ADD_COUNTER macro
> appears to be wrong in ebtables (cf. ip_tables.c, ip6_tables.c,
> and arp_tables.c).
> 
> This causes data corruption in the ebtables userspace tools
> because they get incorrect packet & byte counts from the kernel.

Please send netfilter patches to netfilter-devel@vger.kernel.org .

Fixes: d72133e628803 ("netfilter: ebtables: use ADD_COUNTER macro")

Acked-by: Florian Westphal <fw@strlen.de>
