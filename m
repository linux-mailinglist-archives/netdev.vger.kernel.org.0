Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC81EDB59
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 04:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgFDCss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 22:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDCss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 22:48:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E01DF20657;
        Thu,  4 Jun 2020 02:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591238927;
        bh=tkqTB3HywmuSqr5h1TruL53mUKtFVywlSGoRVaK7Phg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VM2Db7Z7ukqm3m+jFUzzRDhmUReA42TIYpQxjPj2tkB8vWvOaHiduKMstKV9ohIps
         xsUESA8M9Kv4ChdqeP6U3gW9+ebjTBHjkmGPlwYLqd4IopblDy1NC449gTJa1Q/mSX
         sEX5D7+Kt/+EBpelYKfEgcdktq4m5EE3uMLFXKxk=
Date:   Wed, 3 Jun 2020 19:48:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com
Subject: Re: [RFC PATCH net-next 0/8] Expose devlink port attributes
Message-ID: <20200603194845.3506104f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200603104504.GA2165@nanopsycho>
References: <20200602113119.36665-1-danieller@mellanox.com>
        <20200602123311.32bb062c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20200603104504.GA2165@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jun 2020 12:45:04 +0200 Jiri Pirko wrote:
> Tue, Jun 02, 2020 at 09:33:11PM CEST, kuba@kernel.org wrote:
> >On Tue,  2 Jun 2020 14:31:11 +0300 Danielle Ratson wrote:  
> >> Currently, user has no way of knowing if a port can be split and into
> >> how many ports.
> >> 
> >> Among other things, it is currently impossible to write generic tests
> >> for port split.
> >> 
> >> In order to be able to expose the information regarding the split
> >> capability to user space, set the required attributes and pass them to
> >> netlink.
> >> 
> >> Patch 1: Move set attribute from devlink_port_attrs to devlink_port.
> >> Patch 2: Move switch_port attribute from devlink_port_attrs to devlink_port
> >> Patch 3: Replace devlink_port_attrs_set parameters with a struct.
> >> Patch 4: Set and initialize lanes attribute in the driver.
> >> Patch 5: Add lanes attribute to devlink port and pass to netlink.
> >> Patch 6: Set and initialize splittable attribute in the driver.
> >> Patch 7: Add splittable attribute to devlink port and pass them to netlink.
> >> Patch 8: Add a split port test.  
> >
> >Since we have the splitability and number of lanes now understood by
> >the core - can the code also start doing more input checking?  
> 
> Yep, that should certainly be done so some of the checks can move from
> the drivers. Do you want to have this done as a part of this patchset or
> a separate one?

May be a little quicker to review if everything was done in one series,
but no strong feelings.
