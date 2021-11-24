Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D1045D154
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhKXXpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhKXXpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:45:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5986960F6F;
        Wed, 24 Nov 2021 23:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637797355;
        bh=ZOhuQHT6Bb7MaoM35eONy90grotjbFu3htO0PfeSo/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p8erm+LMgIezU7jJ/iqPGR+pKhn4Ms4GwSrYqOBnXBVeilqYEi3rVe9sT1r+g3/JH
         EbMR0y8+o2njkQj7iRtXfS04tCLIrTw+Tq0YXrOuFTHlEIhNELEKDmkzUe4wlU86wH
         K2DhH06joTDDgOhV4+BotQIbuy9+2MXDVoYvnOl+P0u6mplu9PW1o0Y7fps734HQWj
         +cs0vPHSvF+nyu+fwRz8ppEFbEzRzUKCBtyeHlsbSYwXmx7EKZ+ZGkBnx9cMgrGkr+
         1Esby+Jw0FNgP6YHrYXaRdZlZgX7VNJ3L92CfSRiipIONTdAi5sI5l9ieNaDUMEHYT
         he9jfSNqelMvw==
Date:   Wed, 24 Nov 2021 15:42:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [PATCH net-next 00/12][pull request] 40GbE Intel Wired LAN
 Driver Updates 2021-11-24
Message-ID: <20211124154234.4f78a4d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:16:40 -0800 Tony Nguyen wrote:
> Mitch adds restoration of MSI state during reset and reduces the log
> level on a couple messages.
> 
> Patryk adds an info message when MTU is changed.
> 
> Grzegorz adds messaging when transitioning in and out of multicast
> promiscuous mode.
> 
> Jake returns correct error codes for iavf_parse_cls_flower().
> 
> Jedrzej adds messaging for when the driver is removed and refactors
> struct usage to take less memory. He also adjusts ethtool statistics to
> only display information on active queues.
> 
> Tony allows for user to specify the RSS hash.
> 
> Karen resolves some static analysis warnings, corrects format specifiers,
> and rewords a message to come across as informational.

Looks like patch 03/12 still hasn't gotten to the ML :S
