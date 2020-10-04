Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0CA282E6B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 01:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJDX7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 19:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgJDX7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 19:59:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B7AC0613CE;
        Sun,  4 Oct 2020 16:59:23 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id x2so4345266pjk.0;
        Sun, 04 Oct 2020 16:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=D0XrjGNpHDFsmwtiuJ2IjixWsPGZ7fiNnf/mc72+SJU=;
        b=KuhOwWCI11VVGNZg8HT8PDuLKMByoX64pq0TNg+CFYEhRcOWnY5scWFQi6a9HjuvFL
         /byE5nFgjyXeRHP7lRDahUyKKs1dVx0anjOfYLTbna+zv4QYvmmiLuTEcS+4dNgmtZXl
         2efgAj34C1uw4KNahhp7x1TeARbVkCklfu3Cy13jprAKzRY3cHcMzcSR62VxVv91PqKV
         Bdb3JDvLO2wO20ZEekmxPI9zrxJ2TdOlFrVxh9uVHYTTB82FosIKFRp3aK29av8esAwu
         ls2S7PpsDx3xmWewKu4hNhuiPVXeV/ukk5+b+4PT/aPDxdoQlfTShXI0gPnk/y6hEJEF
         NP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=D0XrjGNpHDFsmwtiuJ2IjixWsPGZ7fiNnf/mc72+SJU=;
        b=fzbD9Nb+9G681TcWURBpD3pWKRXqyP+TwIEs4JY3c23waMcFqEv4BsBe2+WcOOf9DP
         5G647t5DXnpD6aE0c5A4wSwJeXz4CyIpjUpcXKi5CHzidVrAUQGWd5AhHK9vbbmWb+dj
         evhC3wA5NktbnQi4I0JUGgz/9Xc1EkBtW+xEcpgQXOgEnXNsqAtLgGaBAf/+PW/2t8iD
         wTteqyhS1/rMIRTVzTt/rojuDinVmFLpx3ztHiKt4JcTrlD7cp5v8xQO3k6DT8srfh4d
         dH6lTJvrMNxnOvKE4vXMpUs9smDbhExPH5bLTvx8cLqnPMLIAKHWHgu9uWOjhsR3yZXU
         wHGg==
X-Gm-Message-State: AOAM533GbhkCF2KD+zscC0ptK77NEaqBLFFhbBVCar22QXzCwOXOGHQ/
        zF1RVjn1zJXxuaksYUfK+DDHFCMlLbBceQ==
X-Google-Smtp-Source: ABdhPJwtD8zyZbhPPscEGsSFWHtWOYEBhXfXhLAAQiBnQRgXOALaJqiACd/JE/QYUzSvyC9WTYWrRA==
X-Received: by 2002:a17:90a:b285:: with SMTP id c5mr13486274pjr.44.1601855963238;
        Sun, 04 Oct 2020 16:59:23 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id g4sm8623298pgg.75.2020.10.04.16.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 16:59:21 -0700 (PDT)
Date:   Mon, 5 Oct 2020 08:59:16 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20201004235916.GA25722@f3>
References: <20201002235941.77062-1-coiby.xu@gmail.com>
 <20201003055348.GA100061@f3>
 <20201004152230.s2kxna2jl2uzlink@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201004152230.s2kxna2jl2uzlink@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-04 23:22 +0800, Coiby Xu wrote:
> On Sat, Oct 03, 2020 at 02:53:48PM +0900, Benjamin Poirier wrote:
> > On 2020-10-03 07:59 +0800, Coiby Xu wrote:
> > > This fixes commit 0107635e15ac
> > > ("staging: qlge: replace pr_err with netdev_err") which introduced an
> > > build breakage of missing `struct ql_adapter *qdev` for some functions
> > > and a warning of type mismatch with dumping enabled, i.e.,
> > > 
> > > $ make CFLAGS_MODULE="-DQL_ALL_DUMP -DQL_OB_DUMP -DQL_CB_DUMP \
> > >     -DQL_IB_DUMP -DQL_REG_DUMP -DQL_DEV_DUMP" M=drivers/staging/qlge
> > > 
> > > qlge_dbg.c: In function ‘ql_dump_ob_mac_rsp’:
> > > qlge_dbg.c:2051:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
> > >  2051 |  netdev_err(qdev->ndev, "%s\n", __func__);
> > >       |             ^~~~
> > > qlge_dbg.c: In function ‘ql_dump_routing_entries’:
> > > qlge_dbg.c:1435:10: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Wformat=]
> > >  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
> > >       |         ~^
> > >       |          |
> > >       |          char *
> > >       |         %d
> > >  1436 |        i, value);
> > >       |        ~
> > >       |        |
> > >       |        int
> > > qlge_dbg.c:1435:37: warning: format ‘%x’ expects a matching ‘unsigned int’ argument [-Wformat=]
> > >  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
> > >       |                                 ~~~~^
> > >       |                                     |
> > >       |                                     unsigned int
> > > 
> > > Note that now ql_dump_rx_ring/ql_dump_tx_ring won't check if the passed
> > > parameter is a null pointer.
> > > 
> > > Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
> > > Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> > > Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> > > Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> > > ---
> > 
> > Reviewed-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> 
> Thank you! Btw, I guess when this patch is picked, the "Reviewed-by" tag
> will also be included. So I needn't to send another patch, am I right?

I think so. Maintainers usually take care of adding attribution tags
from followup emails and that's what Greg has done for your previous
qlge patch it looks like.
