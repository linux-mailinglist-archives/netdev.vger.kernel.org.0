Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49ECFA799
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfKMDwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:52:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfKMDwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:52:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F17DB154FCEF9;
        Tue, 12 Nov 2019 19:52:30 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:52:30 -0800 (PST)
Message-Id: <20191112.195230.1255959947276169668.davem@davemloft.net>
To:     mschiffer@universe-factory.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next v2 0/2] Implement get_link_ksettings for VXLAN
 and bridge
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1573591594.git.mschiffer@universe-factory.net>
References: <cover.1573591594.git.mschiffer@universe-factory.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:52:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <mschiffer@universe-factory.net>
Date: Tue, 12 Nov 2019 22:12:23 +0100

> Mesh routing protocol batman-adv (in particular the new BATMAN_V algorithm)
> uses the link speed reported by get_link_ksettings to determine a path
> metric for wired links. In the mesh framework Gluon [1], we layer VXLAN
> and sometimes bridge interfaces on our Ethernet links.
> 
> These patches implement get_link_ksettings for these two interface types.
> While this is obviously not accurate for bridges with multiple active
> ports, it's much better than having no estimate at all (and in the
> particular setup of Gluon, bridges with a single port aren't completely
> uncommon).
> 
> [1] https://github.com/freifunk-gluon/gluon

Series applied, thanks.

