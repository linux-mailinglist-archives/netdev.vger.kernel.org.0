Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDB712853E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 23:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfLTWx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 17:53:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfLTWx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 17:53:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 263781510456C;
        Fri, 20 Dec 2019 14:53:55 -0800 (PST)
Date:   Fri, 20 Dec 2019 14:53:52 -0800 (PST)
Message-Id: <20191220.145352.754139742452100943.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     cforno12@linux.vnet.ibm.com, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 0/2] net/ethtool: Introduce
 link_ksettings API for virtual network devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191219192909.5ed9996c@hermes.lan>
References: <20191219131156.21332555@hermes.lan>
        <20191219.141619.1840874136750249908.davem@davemloft.net>
        <20191219192909.5ed9996c@hermes.lan>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 14:53:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Thu, 19 Dec 2019 19:29:09 -0800

> On Thu, 19 Dec 2019 14:16:19 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
>> From: Stephen Hemminger <stephen@networkplumber.org>
>> Date: Thu, 19 Dec 2019 13:11:56 -0800
>> 
>> > I don't think this makes sense for netvsc. The speed and duplex have no
>> > meaning, why do you want to allow overriding it? If this is to try and make
>> > some dashboard look good; then you aren't seeing the real speed which is
>> > what only the host knows. Plus it does take into account the accelerated
>> > networking path.  
>> 
>> Maybe that's the point, userspace has extraneous knowledge it might
>> use to set it accurately.
>> 
>> This helps for bonding/team etc. as well.
>> 
>> I don't think there is any real harm in allowing to set this, and
>> we've done this in the past I think.
> 
> My preference would be to have host report some real data.
> But that might take host side changes which have a long lead time to
> get done.

_Iff_ they ever get done.

Meanwhile... we should provide some way to address this in the short
term.
