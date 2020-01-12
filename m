Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 420CA1388D3
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 00:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgALXy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 18:54:56 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46892 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387471AbgALXy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 18:54:56 -0500
Received: by mail-qt1-f195.google.com with SMTP id g1so7618394qtr.13
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 15:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QECIxvXldhkMJFt0djz6qtJ/uPYPO1s9x56W6TJ6wzo=;
        b=SpLegbzOveTbs+ZOtT+k6RWf2vdDMJuG3gB5bR8kFxxQdenmqVPhSDBN9SvMhuA62K
         F6D1CPtyMpVMDV89mgv9eQsutM0RHdE04KAEBzkh6q7pdoyK638sBTLxQHFga5MsKuYU
         B/UNe+ziZlxnKPic7vK1qcgU/Yul1zMlxqTsgyZz4f03Wk8JV3wWtm6PBbXEfhS22fKK
         Yn7R4FCKp6lTZXMmprhQUGkMgbCniLoVTEYuNQWjtD3+5rixwfeIP5x9fYCPfbRVAwMt
         +GnbCRtm+qecsJSsBx0sGZoQ6HdO8gOignRD6rJjG7m3PTGOee02y0x827zvmSN5SrCh
         NVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QECIxvXldhkMJFt0djz6qtJ/uPYPO1s9x56W6TJ6wzo=;
        b=rPn9XIRDx7XV7b2Lm5fpysFaw5WpX60gSnRgB5iH8iZ2R/m1YX9TOWpvfcyaIa4+5A
         c3nFtH7rN0a3f/VoNyoI8kVpDEooiDepSk6D4R4GV+mTo6hl2mK3KHvsunQVVESQn3kv
         36TC1koD6fA96NVbLNiWnmidhip9ofSIbUrpN/SMm0BTAqJmAn/sxxdXBY0l0Yv95wME
         ChdyZYjsx1eCdsBEJs2JIC2Kp+TO0WM099l7nP9R94ifrpClaNFbBnrEYGTxumXp+pE4
         ISINohVF8zCZSVL9MVOwqjUspgoBuiJbfLpRwDFrHxYFz/qYn/qxoHh2cwR/2P7wSx7E
         tvOQ==
X-Gm-Message-State: APjAAAXslVpzPvThlFiI6FXfNG341J6VP03MJBPJbXP8qbegb7udykPe
        Ym21bWjh8OXRY5H+xOodx8K69Q==
X-Google-Smtp-Source: APXvYqw0HF3THv3cEhFsjUx4gokaXgXA4wvGXQ/CnZgRdvb3tRdwInZCk1qTVjtITXmqbxoLhnkEIg==
X-Received: by 2002:ac8:1aeb:: with SMTP id h40mr8262135qtk.269.1578873295622;
        Sun, 12 Jan 2020 15:54:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id f5sm4192976qke.109.2020.01.12.15.54.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 12 Jan 2020 15:54:55 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iqn4I-0008Ht-8U; Sun, 12 Jan 2020 19:54:54 -0400
Date:   Sun, 12 Jan 2020 19:54:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/5] VIRTIO_NET Emulation Offload
Message-ID: <20200112235454.GA20866@ziepe.ca>
References: <20191212110928.334995-1-leon@kernel.org>
 <20200107193744.GB18256@ziepe.ca>
 <20200110183041.GA6871@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110183041.GA6871@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 08:30:41PM +0200, Leon Romanovsky wrote:
> On Tue, Jan 07, 2020 at 03:37:44PM -0400, Jason Gunthorpe wrote:
> > On Thu, Dec 12, 2019 at 01:09:23PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Hi,
> > >
> > > In this series, we introduce VIRTIO_NET_Q HW offload capability, so SW will
> > > be able to create special general object with relevant virtqueue properties.
> > >
> > > This series is based on -rc patches:
> > > https://lore.kernel.org/linux-rdma/20191212100237.330654-1-leon@kernel.org
> > >
> > > Thanks
> > >
> > > Yishai Hadas (5):
> > >   net/mlx5: Add Virtio Emulation related device capabilities
> > >   net/mlx5: Expose vDPA emulation device capabilities
> >
> > This series looks OK enough to me. Saeed can you update the share
> > branch with the two patches?
> 
> Merged, thanks,
> 
> ca1992c62cad net/mlx5: Expose vDPA emulation device capabilities
> 90fbca595243 net/mlx5: Add Virtio Emulation related device capabilities

Done, thanks

Jason
