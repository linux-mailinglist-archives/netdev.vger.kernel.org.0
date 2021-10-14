Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CBE42E31A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 23:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhJNVLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 17:11:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47240 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhJNVLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 17:11:45 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF77C63F27;
        Thu, 14 Oct 2021 23:08:01 +0200 (CEST)
Date:   Thu, 14 Oct 2021 23:09:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, horms@verge.net.au,
        ja@ssi.bg, kadlec@netfilter.org, fw@strlen.de,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net] netfilter: ipvs: make global sysctl readonly in
 non-init netns
Message-ID: <YWicjzI/DSvQ9OfP@salvia>
References: <20211012145437.754391-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211012145437.754391-1-atenart@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 04:54:37PM +0200, Antoine Tenart wrote:
> Because the data pointer of net/ipv4/vs/debug_level is not updated per
> netns, it must be marked as read-only in non-init netns.

Applied, thanks
