Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE54F30F131
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 11:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhBDKtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 05:49:51 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:4252 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhBDKtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 05:49:50 -0500
Received: from localhost ([10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 114AmrTd021689;
        Thu, 4 Feb 2021 02:48:54 -0800
Date:   Thu, 4 Feb 2021 16:18:54 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add new T6 PCI device id 0x6092
Message-ID: <20210204104852.GA10526@chelsio.com>
References: <20210202182511.8109-1-rajur@chelsio.com>
 <20210203182337.3a77480a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203182337.3a77480a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, February 02/03/21, 2021 at 18:23:37 -0800, Jakub Kicinski wrote:
> On Tue,  2 Feb 2021 23:55:11 +0530 Raju Rangoju wrote:
> > Signed-off-by: Raju Rangoju <rajur@chelsio.com>
> 
> Does this device require any code which only exists in net-next?
> 

No code dependency exists in net-next

> Pure device id patches are okay for net.

Sure, it can go net tree.
