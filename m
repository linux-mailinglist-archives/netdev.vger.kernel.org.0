Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C11292E5B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgJSTUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730820AbgJSTUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 15:20:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35C62225A;
        Mon, 19 Oct 2020 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603135241;
        bh=h+mofrc5OePT4klVdhOUQc7cHGhfx3ZPBa6ZhEL0BSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i3FS+RSzB9jqNXUlBG7bD6Cx/XzvFhTiGwoSRMW16nQReAFx3zmdl+0Tejjvrslxp
         N0G0pOD0umZsU471kFo22TicXoPbFJmJTF4DmPtbLngRNcK/FVHtlRFHY1Pf9DcAXJ
         aD2VSIDf2CsbdlAUGJICSealjSmj0WsJH4Cbg8hs=
Date:   Mon, 19 Oct 2020 12:20:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>
Subject: Re: [iproute2-next v3] devlink: display elapsed time during flash
 update
Message-ID: <20201019122040.2eaf4272@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a6814a14af5c45fbad329b9a4f59b4a8@intel.com>
References: <20201014223104.3494850-1-jacob.e.keller@intel.com>
        <f510e3b5-b856-e1a0-3c2b-149b85f9588f@gmail.com>
        <a6814a14af5c45fbad329b9a4f59b4a8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 19:05:34 +0000 Keller, Jacob E wrote:
> > The DEVLINK attributes are ridiculously long --
> > DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT is 40 characters -- which
> > forces really long code lines or oddly wrapped lines. Going forward
> > please consider abbreviations on name components to reduce their lengths.  
> 
> This is probably a larger discussion, since basically every devlink attribute name is long.
> 
> Jiri, Jakub, any thoughts on this? I'd like to see whatever abbreviation scheme we use be consistent.

As David said - let's keep an eye on this going forward. We already 
pushed back with Moshe's live reload work.

If you really want to make things better for this particular name
you could probably drop the word _STATUS from it.
