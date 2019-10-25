Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB9E4F0F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437139AbfJYO2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:28:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43452 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436722AbfJYO2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:28:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so2561269wrr.10;
        Fri, 25 Oct 2019 07:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0lU4vBZ00lsZOGR37S7Y41s23WGWn3vWrl2tK4zXVT4=;
        b=FRyVA/kppsnK9aDVKI19li9Up5yBufEWGsaMRrbzNqAdVN0Pxy+nXiU8vTXFGK/P/e
         nF7MumzJx/Z607woRf65WoIBgRny3FnE9Kkhy/Z2ke7J90aD7SE5wBIJ674ICi7FEUvF
         wqJw/a10wiqU+bqUYJfPtsofmfqfBgsK6R6YhsGVb/n1NM0D2pfqZacOM4oYIotTYY1q
         gvC/tBc0E1muwXXuvboSMbF7uV54wopD6ZaKZiBqzKQAhGtSh2Pnx3E+rzzgzNMeMFte
         kqQvKg6PJ7N7fkxJa7Wraj/57XEimHE3914RA77cOpooEhpdL8dTwYrPsAbKNpHE10Lm
         wTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0lU4vBZ00lsZOGR37S7Y41s23WGWn3vWrl2tK4zXVT4=;
        b=HmBK+xOjT83ZtI00SOR0VmZcWihsMBsvqRIQu5xGrr2R6CgOptdZ/OhcvLXMAegeHf
         L6zvGWzfN5rVW64hXjWzpUsIm7fv/LjawJgE3DEhESow7g7DRchSw8MMIt0Fd99CEy3D
         UreOGHm7/qf+1SezKBAync2vBOtsun6wzheX10m861hNa3J2kQ6M/3EWn+NFqEzWG78r
         OdDxvAOrhir4+fgshoHrcDOSSpYmfcnAjvvjnCRhL1nNcHN/NM3qhtexpqnIoq/3m4xQ
         DAE5dH6mbCo9+ZliLgmmXuaCrhg5lqMCBrWFS0tkrhBgPWeHJWE/xH2xVTqRxemWVDks
         bsqA==
X-Gm-Message-State: APjAAAVWrbAexr6+q+N/r7dlREr0mH7FhQU+dGIycafjyBhf6ErTvYBU
        NNAte3jfonEkemPRbK3WdaQ=
X-Google-Smtp-Source: APXvYqyKe3NGWagSOC0ejXtsTs8OGvjSR/esTy0xnHYnHPSF5tQir+GSkLkz8VE581dzDdt3nsxkbA==
X-Received: by 2002:a05:6000:44:: with SMTP id k4mr3450806wrx.170.1572013725170;
        Fri, 25 Oct 2019 07:28:45 -0700 (PDT)
Received: from sivanov-pc ([92.247.20.94])
        by smtp.gmail.com with ESMTPSA id o70sm2620480wme.29.2019.10.25.07.28.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Oct 2019 07:28:44 -0700 (PDT)
Date:   Fri, 25 Oct 2019 17:28:42 +0300
From:   Samuil Ivanov <samuil.ivanovbg@gmail.com>
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Staging: qlge: Rename prefix of a function to qlge
Message-ID: <20191025142842.GA10016@sivanov-pc>
References: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
 <20191024212941.28149-2-samuil.ivanovbg@gmail.com>
 <20191025101705.GM24678@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025101705.GM24678@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 01:19:05PM +0300, Dan Carpenter wrote:
> On Fri, Oct 25, 2019 at 12:29:39AM +0300, Samuil Ivanov wrote:
> > diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> > index 6ec7e3ce3863..e9f1363c5bf2 100644
> > --- a/drivers/staging/qlge/qlge.h
> > +++ b/drivers/staging/qlge/qlge.h
> > @@ -2262,7 +2262,7 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data);
> >  int ql_unpause_mpi_risc(struct ql_adapter *qdev);
> >  int ql_pause_mpi_risc(struct ql_adapter *qdev);
> >  int ql_hard_reset_mpi_risc(struct ql_adapter *qdev);
> > -int ql_soft_reset_mpi_risc(struct ql_adapter *qdev);
> > +int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev);
> 
> The patch series doesn't change all the functions so now it's hodge
> podge.
> 
> >  int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf, u32 ram_addr,
> >  			  int word_count);
> >  int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump);
> > diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> > index 019b7e6a1b7a..df5344e113ca 100644
> > --- a/drivers/staging/qlge/qlge_dbg.c
> > +++ b/drivers/staging/qlge/qlge_dbg.c
> > @@ -1312,7 +1312,7 @@ void ql_get_dump(struct ql_adapter *qdev, void *buff)
> >  
> >  	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags)) {
> >  		if (!ql_core_dump(qdev, buff))
> > -			ql_soft_reset_mpi_risc(qdev);
> > +			qlge_soft_reset_mpi_risc(qdev);
> >  		else
> >  			netif_err(qdev, drv, qdev->ndev, "coredump failed!\n");
> >  	} else {
> > diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
> > index 9e422bbbb6ab..efe893935929 100644
> > --- a/drivers/staging/qlge/qlge_mpi.c
> > +++ b/drivers/staging/qlge/qlge_mpi.c
> > @@ -88,9 +88,10 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data)
> >  	return status;
> >  }
> >  
> > -int ql_soft_reset_mpi_risc(struct ql_adapter *qdev)
> > +int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev)
> >  {
> >  	int status;
> > +
> >  	status = ql_write_mpi_reg(qdev, 0x00001010, 1);
> 
> This white space change is unrelated.
> 
> >  	return status;
> >  }
> 
> regards,
> dan carpenter
> 

Hello Dan and Greg,

Dan you are correct it is a bit of a hodge podge :)
I think that it is better to have a bigger patches that will rename
more functions, but I don't this it is good to have all the
functions renamed in one patch.

Just in the header file I counted around 55 function definitions,
and in the source files there are some more.
So that will make one huge patch.

And I am not sure if the maintainers will be OK with reviewing it.

So my sugestion is to have a bigger patches.
For example, one patch with 10 to 15 subpatches.
And one subpatch will rename one function and
update the occurrences in the driver.

This way with like 5 iterations all the functions will be renamed.

If you have a better solution please tell.

Grt,
Samuil
