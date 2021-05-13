Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D2B3800F4
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhEMXnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:43:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34064 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhEMXnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:43:20 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F06026415A;
        Fri, 14 May 2021 01:41:18 +0200 (CEST)
Date:   Fri, 14 May 2021 01:42:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net 1/1] netfilter: flowtable: Remove redundant hw
 refresh bit
Message-ID: <20210513234207.GA31703@salvia>
References: <20210510115024.10748-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210510115024.10748-1-roid@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 02:50:24PM +0300, Roi Dayan wrote:
> Offloading conns could fail for multiple reasons and a hw refresh bit is
> set to try to reoffload it in next sw packet.
> But it could be in some cases and future points that the hw refresh bit
> is not set but a refresh could succeed.
> Remove the hw refresh bit and do offload refresh if requested.
> There won't be a new work entry if a work is already pending
> anyway as there is the hw pending bit.

Applied to nf, thanks.
