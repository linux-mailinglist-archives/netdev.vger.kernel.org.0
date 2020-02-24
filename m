Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7BB16AC06
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgBXQr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:47:29 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36453 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgBXQr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:47:29 -0500
Received: by mail-pj1-f67.google.com with SMTP id gv17so7103pjb.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 08:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=es-iitr-ac-in.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2zePMqHb3pxqOSl/NHaUkMDrUSvpWjI4HscCu6Jr28k=;
        b=ZwdohMMjroCJi5cDmXzMY1AW4fuHeMb0XbtE7ZyLvdY2TmdNxW4nhXx6yqm4f03V4O
         eT3TFPHeWwM2FEyVDDAvDi+WtbvSyoqjV6MkeirxuqmP70depek/y+KRWpeWdnaiqGFS
         Z+76/2ZoqQLn0ew3wr7AJ39b3DSalwhweP2CQvZ+O4/N03aQ5R9CV9iSLCv0j9dL6TD7
         kUY6/Bb4yRNNfLGRj60fR0SUuwvkwcMrTFRjB/tqpFiiMhw1aKdRg1Tq7qyEe8SKRNxZ
         uNmI5mAV5zoffPBG/GN2+NvnGFdN5MUCEB3F34AXL5kmt26jahSW5Do+o6OUe1BLRTfL
         buyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2zePMqHb3pxqOSl/NHaUkMDrUSvpWjI4HscCu6Jr28k=;
        b=hrtBNzyNx00UGdofrmF2EFA8wrr0yoEC18OqQ+PIZ2wiPQqV26mH0sWbk+AaR0gMvO
         bv9TfyE2q0W6Dt6lsPo1pZzX3h0kOJptSvyKZXtwmqcsMTPV6fL33uxAzZw9QisEaxJm
         hQZSuefiFbgW7olJjcbTtA1JiAdg55Zv2fb9TrDWyY9+ZyY2E/qB1V4zEwmuIIIvc+ZV
         gYXN5eFsq552w/QJnqqpydsGBleHMTs7yUL5CUCOkKg0e3Paw7bzqkXydmektb3oIhdV
         MYKR7uHckxYwKPZ4WsaYV+xdyXC+E6mnzUVESYVTFPFsWBF8JAUt4cpnkjOhWjaXLZ5F
         XGAw==
X-Gm-Message-State: APjAAAWFgin7zJGRBmONokpXAcFbFziaXI8EXLIaV/TLWyEwsG7ZT6Hd
        ANB1J+2JjywbVYmHPRxDn2V9Bw==
X-Google-Smtp-Source: APXvYqwecQZyBx2Lu6irbcoubh2qjH4GBrXCroPb6bZfgoJ7nVIHn8R8yjAR6JV/sdr+Y/WoSHiLuw==
X-Received: by 2002:a17:902:9342:: with SMTP id g2mr49081074plp.339.1582562848308;
        Mon, 24 Feb 2020 08:47:28 -0800 (PST)
Received: from kaaira-HP-Pavilion-Notebook ([103.37.201.170])
        by smtp.gmail.com with ESMTPSA id d3sm13201089pfn.113.2020.02.24.08.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Feb 2020 08:47:27 -0800 (PST)
From:   Kaaira Gupta <kgupta@es.iitr.ac.in>
X-Google-Original-From: Kaaira Gupta <Kaairakgupta@es.iitr.ac.in>
Date:   Mon, 24 Feb 2020 22:17:21 +0530
To:     Joe Perches <joe@perches.com>, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] staging: qlge: emit debug and dump at same level
Message-ID: <20200224164721.GA7214@kaaira-HP-Pavilion-Notebook>
References: <20200224082448.GA6826@kaaira-HP-Pavilion-Notebook>
 <84410699e6acbffca960aa2944e9f5869478b178.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84410699e6acbffca960aa2944e9f5869478b178.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 05:38:09AM -0800, Joe Perches wrote:
> On Mon, 2020-02-24 at 13:54 +0530, Kaaira Gupta wrote:
> > Simplify code in ql_mpi_core_to_log() by calling print_hex_dump()
> > instead of existing functions so that the debug and dump are
> > emitted at the same KERN_<LEVEL>
> []
> > diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> []
> > @@ -1324,27 +1324,10 @@ void ql_mpi_core_to_log(struct work_struct *work)
> >  {
> >  	struct ql_adapter *qdev =
> >  		container_of(work, struct ql_adapter, mpi_core_to_log.work);
> > -	u32 *tmp, count;
> > -	int i;
> >  
> > -	count = sizeof(struct ql_mpi_coredump) / sizeof(u32);
> > -	tmp = (u32 *)qdev->mpi_coredump;
> > -	netif_printk(qdev, drv, KERN_DEBUG, qdev->ndev,
> > -		     "Core is dumping to log file!\n");
> 
> There is no real need to delete this line.
> 
> And if you really want to, it'd be better to mention
> the removal in the commit message description.
> 
> As is for this change, there is no "debug" and "dump"
> as the commit message description shows, just "dump".

This patch has already been added to the tree, if I amend the commit now
using git rebase, won't it affect the upstream as the SHA-1 of the
commit and it's children will change?

> 
> 
> 
> 
