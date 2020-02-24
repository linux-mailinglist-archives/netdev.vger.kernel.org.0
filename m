Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB65816ACF4
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgBXRSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:18:32 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40271 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXRSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:18:32 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so4310108plp.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 09:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=es-iitr-ac-in.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gyw3IQoCgUqeHBYgq3kf+BJNZrC8xCDPvwa+Ug1jeIY=;
        b=rxarjv0j6U/0Mn9WePM3dmGAynqBodgb0qcGxwIqrk4TVZWw97sTqpQVtxMP0sFT0S
         KBZwY3S4PVFCTll37uvZ7vy5EJrgHC/O82hs1PPzVsl2OGg4F2qHiMEMmFBZN5wmBKKL
         GDCCq7rqcNqv7zWuNGRZvqt/On3TdqBdZDtRNt9jgINp9+YN8wBEI6JYJfj6FUadIC8+
         TBEJyhq5fgG2byb3XP37tkPBOHdOEBmZiFy7Jrw298f3NpVkfHbkJ+jWXczGd8vpFwXL
         1urlhCWFuMu3jWJEfhVPxC9HDgUCWZjw7BeE6HF61dIhXALyrX0b5+LRyp6KF0FL9V02
         7qsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gyw3IQoCgUqeHBYgq3kf+BJNZrC8xCDPvwa+Ug1jeIY=;
        b=OV6zNz70I78rO7eJpToWjCxcQVNygsdGoUH5OcFx5BPDX/IKgXGg82T+udaG8hsemg
         j08ywIeXI0hXTtsH9o03qcDAQeudNjYU5cjHObRY+3AX8sErk6MxeApCH6Ko2gGk5Up5
         LUHtpM2/2rG9A3IWJKtD1rCbvroHRgUThpdRhfo1J7FkFbpL9E5nqE5eRdlileszGLno
         PljVXKtlX8pd/A0ZV//8R8ZneaLCOux9KqyZakQJcppItuqMEoYDE8aCnJuiEVaueBwW
         51BWSOQcLbjxQADCGjGkK7R6omtHNyqVQSVpUW0Of4uLMy20ydDrgnMZX33i0p71qi88
         /XOA==
X-Gm-Message-State: APjAAAWb55V6wreNk5ou+vS4zhizRvCy2VsyvleHzbdzxrjWh4beDd61
        DBoG1z2xL2aVseMykQsqsa7mjw==
X-Google-Smtp-Source: APXvYqypr5gvqxegqJ49eFPGEqT53fDvW/SfNn7izliGbOcALtB1GFkm3Wv3PpxGw3FpScvNByib1w==
X-Received: by 2002:a17:90a:c691:: with SMTP id n17mr80171pjt.41.1582564711576;
        Mon, 24 Feb 2020 09:18:31 -0800 (PST)
Received: from kaaira-HP-Pavilion-Notebook ([103.37.201.170])
        by smtp.gmail.com with ESMTPSA id t8sm29369pjy.20.2020.02.24.09.18.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Feb 2020 09:18:30 -0800 (PST)
From:   Kaaira Gupta <kgupta@es.iitr.ac.in>
X-Google-Original-From: Kaaira Gupta <Kaairakgupta@es.iitr.ac.in>
Date:   Mon, 24 Feb 2020 22:48:23 +0530
To:     Joe Perches <joe@perches.com>, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] staging: qlge: emit debug and dump at same level
Message-ID: <20200224171823.GA8240@kaaira-HP-Pavilion-Notebook>
References: <20200224082448.GA6826@kaaira-HP-Pavilion-Notebook>
 <84410699e6acbffca960aa2944e9f5869478b178.camel@perches.com>
 <20200224164721.GA7214@kaaira-HP-Pavilion-Notebook>
 <9f0d39d5972553b86123873294fc9f9566130036.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f0d39d5972553b86123873294fc9f9566130036.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 08:54:43AM -0800, Joe Perches wrote:
> On Mon, 2020-02-24 at 22:17 +0530, Kaaira Gupta wrote:
> > On Mon, Feb 24, 2020 at 05:38:09AM -0800, Joe Perches wrote:
> > > On Mon, 2020-02-24 at 13:54 +0530, Kaaira Gupta wrote:
> > > > Simplify code in ql_mpi_core_to_log() by calling print_hex_dump()
> > > > instead of existing functions so that the debug and dump are
> > > > emitted at the same KERN_<LEVEL>
> > > []
> > > > diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> > > []
> > > > @@ -1324,27 +1324,10 @@ void ql_mpi_core_to_log(struct work_struct *work)
> > > >  {
> > > >  	struct ql_adapter *qdev =
> > > >  		container_of(work, struct ql_adapter, mpi_core_to_log.work);
> > > > -	u32 *tmp, count;
> > > > -	int i;
> > > >  
> > > > -	count = sizeof(struct ql_mpi_coredump) / sizeof(u32);
> > > > -	tmp = (u32 *)qdev->mpi_coredump;
> > > > -	netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
> > > > -		     "Core is dumping to log file!\n");
> > > 
> > > There is no real need to delete this line.
> > > 
> > > And if you really want to, it'd be better to mention
> > > the removal in the commit message description.
> > > 
> > > As is for this change, there is no "debug" and "dump"
> > > as the commit message description shows, just "dump".
> > 
> > This patch has already been added to the tree,
> 
> What tree is that?
> It's not in -next as of right now.

Its in staging-next right now.
This is the link: https://lore.kernel.org/driverdev-devel/cba75ee4d88afdf118631510ad0f971e42c1a31c.camel@perches.com/

> 
> >  if I amend the commit now
> > using git rebase, won't it affect the upstream as the SHA-1 of the
> > commit and it's children will change?
> 
> You are sending patches not pull requests.
> 
> If it's really in an actual tree that people
> care about, send another patch putting the
> netif_printk back.

I'll submit a patch, but can you please explain me why this function is
still needed when we are already using print_hex_dump()?

> 
> 
