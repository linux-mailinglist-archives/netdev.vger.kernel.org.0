Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B1411D1C0
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfLLQDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbfLLQDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 11:03:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A87C22173E;
        Thu, 12 Dec 2019 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576166595;
        bh=hfABrdLSbH0bF01p271neeli3FQecfhJg4XVLx7Gzt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xoPRm99RqXB4G6cle4WwUEdyyR/xvWEN2/Pv6Q1/dEW7dcz94kHXPQUoWAlzNwVf6
         CfAhr/QJHu8bLnf8dLLvaKAuEubbTEUmyqMocdFxvWs8wxkeif566rlC19JCkNCBuo
         1ZP/hc43GyOhkAPxmlTplERgVf0xW5BcW91kOcy0=
Date:   Thu, 12 Dec 2019 17:03:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Scott Schafer <schaferjscott@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        Manish Chopra <manishc@marvell.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 11/23] staging: qlge: Fix CHECK: braces {} should be
 used on all arms of this statement
Message-ID: <20191212160312.GA1672580@kroah.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
 <0e1fc1a16725094676fdab63d3a24a986309a759.1576086080.git.schaferjscott@gmail.com>
 <20191212121206.GB1895@kadam>
 <20191212150200.GA8219@karen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212150200.GA8219@karen>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 09:02:00AM -0600, Scott Schafer wrote:
> On Thu, Dec 12, 2019 at 03:12:06PM +0300, Dan Carpenter wrote:
> > On Wed, Dec 11, 2019 at 12:12:40PM -0600, Scott Schafer wrote:
> > > @@ -351,8 +352,9 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
> > >  	mbcp->out_count = 6;
> > >  
> > >  	status = ql_get_mb_sts(qdev, mbcp);
> > > -	if (status)
> > > +	if (status) {
> > >  		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
> > > +	}
> > >  	else {
> > 
> > The close } should be on the same line as the else.
> > 
> > >  		int i;
> > >  
> > 
> > regards,
> > dan carpenter
> 
> this was fixed in patch 22

Don't add a warning that you later fix up :)

