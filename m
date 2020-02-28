Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652CC1736E9
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 13:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgB1MMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 07:12:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:48648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1MMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 07:12:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3E97AD39;
        Fri, 28 Feb 2020 12:12:37 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E3CE9E2FCF; Fri, 28 Feb 2020 13:12:36 +0100 (CET)
Date:   Fri, 28 Feb 2020 13:12:36 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Luigi Rizzo <lrizzo@google.com>, toke@redhat.com,
        davem@davemloft.net, hawk@kernel.org, sameehj@amazon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb
 linearization
Message-ID: <20200228121236.GG6835@unicorn.suse.cz>
References: <20200228105435.75298-1-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228105435.75298-1-lrizzo@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 02:54:35AM -0800, Luigi Rizzo wrote:
> Add a netdevice flag to control skb linearization in generic xdp mode.
> 
> The attribute can be modified through
> 	/sys/class/net/<DEVICE>/xdpgeneric_linearize
> The default is 1 (on)

I'm a bit surprised that it didn't appear in earlier rounds of review
but I believe (rt)netlink is generally preferred configuration interface
for network device attributes. Making a new attribute accessible only
through sysfs doesn't seem right. (But it's not my call to make.)

Michal
