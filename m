Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF0F292A80
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgJSPda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgJSPda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 11:33:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7205622260;
        Mon, 19 Oct 2020 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603121609;
        bh=yya1o9T7oC4vyJO2cm36z0cnriLTvHBVSH790kbyNYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=flrDcCno2RMwv3HFAcbG3KdXBl2sY6l0k3xT9KrMH4ZkM4sitHZHQaCJ5HiwcmqWA
         OWrwBrIXQxuCBlXdyLhTpg6B6Xpcvk0TM7zdeUG7jv2DmAdHShzVQa0jthGt5QgLJg
         izU0jlzTR/Nsz4Jr2NWVgb30cn7mjx05st3X/X+w=
Date:   Mon, 19 Oct 2020 08:33:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 035/111] ipv6/icmp: l3mdev: Perform icmp
 error route lookup on source device routing table (v2)
Message-ID: <20201019083327.34c2cbc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019115236.GA4060117@sasha-vm>
References: <20201018191807.4052726-1-sashal@kernel.org>
        <20201018191807.4052726-35-sashal@kernel.org>
        <20201018124004.5f8c50a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <842ae8c4-44ef-2005-18d5-80e00c140107@gmail.com>
        <20201019115236.GA4060117@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 07:52:36 -0400 Sasha Levin wrote:
> On Sun, Oct 18, 2020 at 07:40:12PM -0600, David Ahern wrote:
> >On 10/18/20 1:40 PM, Jakub Kicinski wrote:  
> >> This one got applied a few days ago, and the urgency is low so it may be
> >> worth letting it see at least one -rc release ;)  
> >
> >agreed  
> 
> Definitely - AUTOSEL patches get extra soaking time before getting
> queued up. This is more of a request to make sure it's not doing
> anything silly.

Could you put a number on "extra soaking time"? 

I'm asking mostly out of curiosity :)
