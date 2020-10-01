Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656E02801BA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbgJAO4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732299AbgJAO4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 10:56:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA05820780;
        Thu,  1 Oct 2020 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601564202;
        bh=beqSGl90rSl6/+rXxOibbCRTTgRSruAFLFoz/BTIDtM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vXRYO+UoBV/YARsfxS69OdmvvB2AQGPLqc8a0hsPU9/c8OW5tOKcc6C6Te0iI3Tbi
         E+qSBppZwGRGi2wKZr6UUWnpW2D4eElD14V8Bx5Su8Ruh7Toar6mxC91ez3Y56iD8+
         IN9OkXFJoylK2SRzqQTysE2F9uNMYVXBJKp0NOhI=
Date:   Thu, 1 Oct 2020 07:56:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 5/6] l2tp: add ac_pppoe pseudowire driver
Message-ID: <20201001075640.16212741@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930210707.10717-6-tparkin@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
        <20200930210707.10717-6-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 22:07:06 +0100 Tom Parkin wrote:
> The AC/PPPoE driver implements pseudowire type L2TP_PWTYPE_PPP_AC, for
> use in a PPPoE Access Concentrator configuration.  Rather than
> terminating the PPP session locally, the AC/PPPoE driver forwards PPP
> packets over an L2TP tunnel for termination at the LNS.
> 
> l2tp_ac_pppoe provides a data path for PPPoE session packets, and
> should be instantiated once a userspace process has completed the PPPoE
> discovery process.
> 
> To create an instance of an L2TP_PWTYPE_PPP_AC pseudowire, userspace
> must use the L2TP_CMD_SESSION_CREATE netlink command, and pass the
> following attributes:
> 
>  * L2TP_ATTR_IFNAME, to specify the name of the interface associated
>    with the PPPoE session;
>  * L2TP_ATTR_PPPOE_SESSION_ID, to specify the PPPoE session ID assigned
>    to the session;
>  * L2TP_ATTR_PPPOE_PEER_MAC_ADDR, to specify the MAC address of the
>    PPPoE peer

C=1 generates:

net/l2tp/l2tp_ac_pppoe.c:234:20: warning: incorrect type in argument 1 (different address spaces)
net/l2tp/l2tp_ac_pppoe.c:234:20:    expected struct net_device *dev
net/l2tp/l2tp_ac_pppoe.c:234:20:    got struct net_device [noderef] __rcu *dev
net/l2tp/l2tp_ac_pppoe.c:380:45: error: incompatible types in comparison expression (different address spaces):
net/l2tp/l2tp_ac_pppoe.c:380:45:    struct net_device [noderef] __rcu *
net/l2tp/l2tp_ac_pppoe.c:380:45:    struct net_device *
