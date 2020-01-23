Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2206146B3A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAWO0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAWO0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:26:07 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF8832087E;
        Thu, 23 Jan 2020 14:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789567;
        bh=5Yi104wdcgLvcgT8PLbU/QKE5+NR5yaTWxupHP98I+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xGPT8PvkggxeOXB/++WHkOQl6M2yHtGooRfU8TTTt7cuJj94cJoHcUyJxzp+HcwsL
         T0UMyFiiA+W3Wapq0BP6DsHl8gJzxN7pA3EPWIC5mXOAdq7bDp0hhGnyLvPSZs6VrY
         gF2yuteXnEhj7IiESb1JO02BhSIlrf+iNSGB8Nlc=
Date:   Thu, 23 Jan 2020 06:26:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH net-next 01/14] qed: FW 8.42.2.0 Internal ram offsets
 modifications
Message-ID: <20200123062606.728b838b@cakuba>
In-Reply-To: <MN2PR18MB3182AB7FB24C2F4EC9E16B64A10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
        <20200122152627.14903-2-michal.kalderon@marvell.com>
        <20200122074528.670d3d2a@cakuba>
        <MN2PR18MB3182AB7FB24C2F4EC9E16B64A10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 16:02:06 +0000, Michal Kalderon wrote:
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-  
> > owner@vger.kernel.org> On Behalf Of Jakub Kicinski  
> > 
> > On Wed, 22 Jan 2020 17:26:14 +0200, Michal Kalderon wrote:  
> > > IRO stands for internal RAM offsets. Updating the FW binary produces
> > > different iro offsets. This file contains the different values, and a
> > > new representation of the values.
> > >
> > > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>  
> > 
> > If you have different offsets depending on FW build - where is the code that
> > checks the FW version is the one driver expects? At a quick glance you're not
> > bumping any numbers in this patch..  
> The FW version is bumped in patch 0009-qed-FW-8.42.2.0-HSI-Changes.patch and the driver loads
> The FW binary according to this version. 

Please make it so the driver is not broken between patch 1 and patch 9.
