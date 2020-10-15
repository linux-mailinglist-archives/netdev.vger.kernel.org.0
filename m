Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6226528F9B3
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391896AbgJOTrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391890AbgJOTrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:47:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79571206DD;
        Thu, 15 Oct 2020 19:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602791270;
        bh=OKj5OghpJrPlsoA9aCuGSDcJqT/RXPzJFqtejR5rWx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pjUMw+Ysxlpi9c+zVluPvSvHulTuNDWb3rDmUpG7CdiEDvOrJhRp4FvbWlb3suRoE
         UIxvUSpJqbF9RRWuuLCCDpVJpdnPVAcR6sykUgrzytDisRGkdVTL9I2U+f3XvoRLZE
         PTEt4BCNJ68zSpvnaWM2Uy1h1oy6KqEbtx3yaZXE=
Date:   Thu, 15 Oct 2020 12:47:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next,v2 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201015124748.7793cbda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015163038.26992-1-pablo@netfilter.org>
References: <20201015163038.26992-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 18:30:29 +0200 Pablo Neira Ayuso wrote:
> The following patchset adds infrastructure to augment the Netfilter
> flowtable fastpath [1] to support for local network topologies that
> combine IP forwarding, bridge and vlan devices.
> 
> A typical scenario that can benefit from this infrastructure is composed
> of several VMs connected to bridge ports where the bridge master device
> 'br0' has an IP address. A DHCP server is also assumed to be running to
> provide connectivity to the VMs. The VMs reach the Internet through
> 'br0' as default gateway, which makes the packet enter the IP forwarding
> path. Then, netfilter is used to NAT the packets before they leave to
> through the wan device.

Hi Pablo, I should have looked at this closer yesterday, but I think it
warrants a little more review than we can afford right now. 

Let's take it after the merge window, sorry!
