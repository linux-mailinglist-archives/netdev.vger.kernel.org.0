Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491901EBFDE
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgFBQVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgFBQVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 12:21:46 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E80232067B;
        Tue,  2 Jun 2020 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591114906;
        bh=F2vboQGojJ3gh//abpbgMHDkoLrYDRcQ4VbSHGwbmDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sO0MGa09irZsf+kLkQQaFzLcjnnBgP+oyM5WJgLNvzE/n++DhKmClpiz6S50ukkQ8
         SAKibT1yekv3E0Smo2qAH13RSn5SJaBsXUF/yceVWuiNZyxIxViim+4lUCiWYUK6eN
         1Ilcj79bkZErAziVXexZ14oFBvZMGHIabe8t3TYg=
Date:   Tue, 2 Jun 2020 09:21:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, snelson@pensando.io, drivers@pensando.io,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        mlxsw@mellanox.com
Subject: Re: [RFC PATCH net-next 0/8] Expose devlink port attributes
Message-ID: <20200602092144.09d3a904@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jun 2020 14:31:11 +0300 Danielle Ratson wrote:
> Currently, user has no way of knowing if a port can be split and into
> how many ports.
> 
> Among other things, it is currently impossible to write generic tests
> for port split.
> 
> In order to be able to expose the information regarding the split
> capability to user space, set the required attributes and pass them to
> netlink.

Hi! Looks like patches 3, 5, and 7 add warnings when built with W=1 C=1.
Unfortunately there are 500 existing warnings I can't figure out which
ones are new :(
