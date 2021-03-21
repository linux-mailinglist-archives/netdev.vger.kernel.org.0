Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5A3434A4
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 21:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhCUUaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 16:30:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230241AbhCUU31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 16:29:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lO4hP-00CIAJ-Ab; Sun, 21 Mar 2021 21:29:23 +0100
Date:   Sun, 21 Mar 2021 21:29:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Hsu, Chiahao" <andyhsu@amazon.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        kuba@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YFeso1fr1hLxi3lR@lunn.ch>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch>
 <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch>
 <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com>
 <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com>
 <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > At the end, it will be more granular module parameter that user still
> > will need to guess.
> I believe users always need to know any parameter or any tool's flag before
> they use it.
> For example, before user try to set/clear this ctrl_ring_enabled, they
> should already have basic knowledge about this feature,
> or else they shouldn't use it (the default value is same as before), and
> that's also why we use the 'ctrl_ring_enabled' as parameter name.

To me, it seems you are fixing this problem in the wrong place. As a
VM user in the cloud, i have no idea how the cloud provider needs the
VM configured to allow the cloud provider to migrate the VM to
somewhere else in the bitbarn. As the VM user, it should not be my
problem. I would expect the cloud provider to configure the VM host to
only expose facilities to the VM which allows it to be migrated.

This is a VM host problem, not a VM problem.

     Andrew
