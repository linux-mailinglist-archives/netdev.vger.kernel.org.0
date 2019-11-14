Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D16DFD086
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKNVrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:47:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKNVrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:47:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76DB714A71860;
        Thu, 14 Nov 2019 13:47:03 -0800 (PST)
Date:   Thu, 14 Nov 2019 13:47:02 -0800 (PST)
Message-Id: <20191114.134702.2225076954282781858.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH v2 net-next 2/2] Special handling for IP & MPLS.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <24ec93937d65fa2afc636a2887c78ae48736a649.1573659466.git.martin.varghese@nokia.com>
References: <cover.1573659466.git.martin.varghese@nokia.com>
        <24ec93937d65fa2afc636a2887c78ae48736a649.1573659466.git.martin.varghese@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 13:47:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Thu, 14 Nov 2019 20:49:58 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> Special handling is needed in bareudp module for IP & MPLS as they support
> more than one ethertypes.
> 
> MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
> While decapsulating MPLS packet from UDP packet the tunnel destination IP
> address is checked to determine the ethertype. The ethertype of the packet
> will be set to 0x8848 if the  tunnel destination IP address is a multicast
> IP address. The ethertype of the packet will be set to 0x8847 if the
> tunnel destination IP address is a unicast IP address.
> 
> IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version field
> of the IP header tunnelled will be checked to determine the ethertype.
> 
> This special handling to tunnel additional ethertypes will be disabled by
> default and can be enabled using a flag called ext mode. This flag can be
> used only with ethertypes 0x8847 and 0x0800.
> 
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2:
>     - Fixed documentation errors.
>     - Changed commit message

You must always repost the entire patch series, not just the patches
you are updating.
