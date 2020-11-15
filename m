Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9364E2B35FB
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgKOQCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 11:02:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgKOQCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 11:02:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keKUG-007CIz-CI; Sun, 15 Nov 2020 17:02:44 +0100
Date:   Sun, 15 Nov 2020 17:02:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz, f.fainelli@gmail.com,
        marek.behun@nic.cz, vivien.didelot@gmail.com, info <info@turris.cz>
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
Message-ID: <20201115160244.GD1701029@lunn.ch>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
 <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
 <20201114184915.fv5hfoobdgqc7uxq@skbuf>
 <c0bb216e-0717-a131-f96d-c5194b281746@elloe.vision>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0bb216e-0717-a131-f96d-c5194b281746@elloe.vision>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> At some point, with absolutely nothing showing in any Mox log in the
> meantime, additional renewals will fail.

What might be interesting is running

ip monitor

and

bridge monitor

Look for neighbours being timed out do to inactivity.

       Andrew

