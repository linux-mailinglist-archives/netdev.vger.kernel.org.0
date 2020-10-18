Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CD1291CB5
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbgJRTkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733282AbgJRTkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:40:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E0C206CA;
        Sun, 18 Oct 2020 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603050006;
        bh=iStiqQYGOTw+am+EALmpvFNI9jjx2zB/KhAVYa66N2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q8sp0MUGngACNgMUXUP12CJd0WCe60DQxwb+RJsf2ei8hQb37qwFWuyun0JRebS+F
         E5mp5j+y+iAP+5Bf8nOadS96uhiaI9yJ4A0J1Y8IBYWs4DkhMq/8Vyo6oCTIcuwuHg
         1Odw9WURHVbugh+509tpoCqHoyavWXSRda6RcHYw=
Date:   Sun, 18 Oct 2020 12:40:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 035/111] ipv6/icmp: l3mdev: Perform icmp
 error route lookup on source device routing table (v2)
Message-ID: <20201018124004.5f8c50a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018191807.4052726-35-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
        <20201018191807.4052726-35-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 15:16:51 -0400 Sasha Levin wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> [ Upstream commit 272928d1cdacfc3b55f605cb0e9115832ecfb20c ]
> 
> As per RFC4443, the destination address field for ICMPv6 error messages
> is copied from the source address field of the invoking packet.
> 
> In configurations with Virtual Routing and Forwarding tables, looking up
> which routing table to use for sending ICMPv6 error messages is
> currently done by using the destination net_device.

This one got applied a few days ago, and the urgency is low so it may be
worth letting it see at least one -rc release ;)

Maybe Mathieu & David feel differently.
