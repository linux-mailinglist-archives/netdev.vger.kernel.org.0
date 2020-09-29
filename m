Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F01627BCDB
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgI2GLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:11:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgI2GLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:11:02 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601359860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JAxYHRdsbLtzM2kIQHgB0ZgL2sD23xll0p+Cp1/eLJU=;
        b=PjW0eRA4pM5C9/JqUelAkuIIyjdEvfLyNL3rmlLqjhHIsxhYYsSI032U1CQMU4Jlw2bTbh
        W7HaqygNCViATSnN4x6zY/AGZlsS/WGfmuvZdyqOGbSzNVIe8ETqobZhLhC0SYOyLUw4pu
        EpQ96AhWjIiYIVRnXtZe6Y4E7wnJdOU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-is2bxjFCPParUggnWqKrHw-1; Tue, 29 Sep 2020 02:10:58 -0400
X-MC-Unique: is2bxjFCPParUggnWqKrHw-1
Received: by mail-wr1-f71.google.com with SMTP id j7so1295710wro.14
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:10:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JAxYHRdsbLtzM2kIQHgB0ZgL2sD23xll0p+Cp1/eLJU=;
        b=Szq81rSeIMEh1P2uMouJfM3Py69vTu6aJTDoY/JVovF46046c4ry4y1MN2EneHWQ6o
         ho8RhbR6zU9jxr1HJL27qnwGRE7phx5tmYthQ/GiyorC2tBzy6vgcc5wgWGqZALd2VHU
         b/0neRzpavyJBLBg7rIr0fXhCdb9DMS8N86j23udLhV3NpbjvGzhGsgaIYCWA+2CFChJ
         bGU9VGdGfz8Ut7LQwrc33yi830Hxp32Ue6hhaTvizCoP6KnYmgp8jY53JpvVFShRboOB
         LpnUoxEiQvKW/YJftbYbWm9225t+sDn7wDRiawSeCi6rbJxe1xzVOKB+gkEi97c2zpx6
         h21w==
X-Gm-Message-State: AOAM532e86dw544AKvLlXGMpDhtQvozYY08wPeolBz7/BoKq+N06+bTN
        Fjp/FTPLOY2tsQKQBoAQMJ6nvvX6Oyv7ZzWY9Gb9/MAkV8SNrRgAQArHv93OdcbOvT5Rsi49xSV
        u7YArbtIV3MexI2iM
X-Received: by 2002:adf:eb04:: with SMTP id s4mr2366071wrn.81.1601359857388;
        Mon, 28 Sep 2020 23:10:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbRp2Llm5I3cTgA/LEzQYm1zgKOCI/i4yvi7klM6uNyHOo4UgNBNnqGUpXczfJ7duXJzSDAA==
X-Received: by 2002:adf:eb04:: with SMTP id s4mr2366044wrn.81.1601359857144;
        Mon, 28 Sep 2020 23:10:57 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id e13sm4772905wre.60.2020.09.28.23.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 23:10:56 -0700 (PDT)
Date:   Tue, 29 Sep 2020 02:10:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200929021030-mutt-send-email-mst@kernel.org>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
 <20200925061959-mutt-send-email-mst@kernel.org>
 <20200929060142.GA120395@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929060142.GA120395@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:01:42AM +0300, Eli Cohen wrote:
> On Fri, Sep 25, 2020 at 06:20:45AM -0400, Michael S. Tsirkin wrote:
> > > > 
> > > > Hmm other drivers select VHOST_IOTLB, why not do the same?
> > > 
> > > I can't see another driver doing that.
> > 
> > Well grep VHOST_IOTLB and you will see some examples.
> 
> $ git grep -wn VHOST_IOTLB
> drivers/vhost/Kconfig:2:config VHOST_IOTLB
> drivers/vhost/Kconfig:11:       select VHOST_IOTLB
> drivers/vhost/Kconfig:18:       select VHOST_IOTLB
> 
> What am I missing here?

Nothing, there's a select here as expected.

> > > Perhaps I can set dependency on
> > > VHOST which by itself depends on VHOST_IOTLB?
> > 
> > VHOST is processing virtio in the kernel. You don't really need that
> > for mlx, do you?
> > 
> > > > 
> > > > 
> > > > > >  	help
> > > > > >  	  Support library for Mellanox VDPA drivers. Provides code that is
> > > > > >
> > > > 
> > 

