Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C53A197CD6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgC3N0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:26:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgC3N0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 09:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0WmH5baULZnWXSWQBWjN+jwXRJyBL36hKjLIsJQUryk=; b=xMSS+PdtAc9X0pgv2eiSSQmDLm
        vBhYST+zRABiQTYcSGo4H+tOoeT/PJKryildb8/jQJMhdPqENQl3sZeWaPPIGKD1+o7gsmVYY389r
        hTlnZzVWNmG4BCInvp76HExqCczDSuXCqaoF08piO69ND5HXr5tiM2NNFRcTGFkl46P4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIuQd-0004rz-EF; Mon, 30 Mar 2020 15:26:11 +0200
Date:   Mon, 30 Mar 2020 15:26:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: ingress rate limiting on mv88e6xxx
Message-ID: <20200330132611.GA18392@lunn.ch>
References: <056a0c42-3831-9ecb-a455-637c8ea13516@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056a0c42-3831-9ecb-a455-637c8ea13516@prevas.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 03:22:44PM +0200, Rasmus Villemoes wrote:
> I'm trying to figure out what the proper way is to expose the ingress
> rate limiting knobs of the mv88e6250 (and related) to userspace. The
> simpest seems to be a set of sysfs files for each port, but I'm assuming
> that's a no-go (?)
> 
> So what is the right way, and has anyone looked at hooking this up?

Hi Rasmus

You need to map TC to the switch QoS functions.

    Andrew
