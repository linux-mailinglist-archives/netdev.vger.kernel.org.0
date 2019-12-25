Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4A512A65F
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 07:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfLYGZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 01:25:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLYGZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 01:25:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B43DD154E705E;
        Tue, 24 Dec 2019 22:25:06 -0800 (PST)
Date:   Tue, 24 Dec 2019 22:25:04 -0800 (PST)
Message-Id: <20191224.222504.1002685539423182176.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, scott.drennan@nokia.com,
        jbenc@redhat.com, martin.varghese@nokia.com
Subject: Re: [PATCH net-next v5 0/3] New openvswitch MPLS actions for layer
 2 tunnelling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1576896417.git.martin.varghese@nokia.com>
References: <cover.1576896417.git.martin.varghese@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 22:25:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Sat, 21 Dec 2019 08:49:36 +0530

> The existing PUSH MPLS action inserts MPLS header between ethernet header
> and the IP header. Though this behaviour is fine for L3 VPN where an IP
> packet is encapsulated inside a MPLS tunnel, it does not suffice the L2
> VPN (l2 tunnelling) requirements. In L2 VPN the MPLS header should
> encapsulate the ethernet packet.
> 
> The new mpls action ADD_MPLS inserts MPLS header at the start of the
> packet or at the start of the l3 header depending on the value of l3 tunnel
> flag in the ADD_MPLS arguments.
> 
> POP_MPLS action is extended to support ethertype 0x6558
 ...

Series applied, thanks.
