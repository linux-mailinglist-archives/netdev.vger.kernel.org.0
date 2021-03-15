Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C4233C4A6
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhCORkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231469AbhCORjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:39:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D4964E41;
        Mon, 15 Mar 2021 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615829993;
        bh=BF8fKi0zRFRY8lXFZo5FrirrACZ5Eu+O5IwYFeCpOWE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=difkjHhkqev7l9NY+6NUHqdecSdavAPgVqcZH0tZxvb4d7uWwnOU9Q8KMyq4XYzGn
         lCjFpA7pdioMR8Zg/w9N8eo/zlHE17E/K2eJFFk2MPucd+s1tskv1QCsykBI3O9siA
         q0CQDcejAU4QbyhcBo60H+9vpbyaC/SPySwe7GUOoomkZ9/jaYbWRqOIq+d4ephIFQ
         zbv+W7j6OFgoNOmpumSdUrpRUidl09kqEj/Op3YYnnWJO6vD7mDlYw388JrNFBAmil
         qbMOFWBG817umhok0DjUQzLI+0ByBq4KdPRE2aytkbFtsVOAhX42u44Tc1R1SZIUMT
         07Ext6tvBqxPA==
Date:   Mon, 15 Mar 2021 10:39:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Don Bollinger" <don@thebollingers.org>
Cc:     "'Andrew Lunn'" <andrew@lunn.ch>, <arndb@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <brandon_chuang@edge-core.com>, <wally_wang@accton.com>,
        <aken_liu@edge-core.com>, <gulv@microsoft.com>,
        <jolevequ@microsoft.com>, <xinxliu@microsoft.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
References: <20210215193821.3345-1-don@thebollingers.org>
        <YDl3f8MNWdZWeOBh@lunn.ch>
        <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
        <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>
        <YD1ScQ+w8+1H//Y+@lunn.ch>
        <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>
        <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <005e01d71230$ad203be0$0760b3a0$@thebollingers.org>
        <YEL3ksdKIW7cVRh5@lunn.ch>
        <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
        <YEvILa9FK8qQs5QK@lunn.ch>
        <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Mar 2021 13:35:56 -0800 Don Bollinger wrote:
> > away parts of the bottom end and replace it with a different KAPI, and
> > nobody will notice? In fact, this is probably how it was designed. Anybody  
> 
> Actually everyone who touches this code would notice, each implementation
> would have to be modified, with literally no benefit to this community.

You keep saying that kernel API is "of no benefit to this community"
yet you don't want to accept the argument that your code is of no
benefit to the upstream community.

> optoe does not undermine the netlink KAPI that Moshe is working on.  

It does, although it may be hard to grasp for a vendor who can just EoL
a product at will once nobody is paying for it. We aim to provide
uniform support for all networking devices and an infinite backward
compatibility guarantee.

People will try to use optoe-based tools on the upstream drivers and
they won't work. Realistically we will need to support both APIs.

> If your community is interested, it could adopt optoe, WITH your
> KAPI, to consolidate and improve module EEPROM access for mainstream
> netdev consumers.  I am eager to collaborate on the fairly simple
> integration.

Nacked-by: Jakub Kicinski <kuba@kernel.org>

Please move on.
