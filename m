Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4058611905D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfLJTL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:11:28 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37489 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbfLJTL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:11:27 -0500
Received: by mail-oi1-f193.google.com with SMTP id x195so10883597oix.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 11:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GmjrBCvMDnrN5WSFCLajJ8bTqGflO1i7+JSr9It/EWc=;
        b=Ex4lPsH4a8l5bv8kn9L5lrpl4vtxvRGxEZHE+Dd3TBHlofvdd8nA60V/0lovnmmqll
         vDpVuVvG/iMtMj/So/TeL3aYNFHX2Prdkd2/D908pDTt5qN65vvMXhhRRL+EIes7YhAD
         gTyX9VFnkfjqL2LiTtbgcbwDbaYJRv7ob6jUpwxrfnLaL9O2ka4REcd6/I66UMKrSFfc
         Hup9xDZ0r1tv6FI0CSP94trTTDVDrGMLnRaSbQ9h6+hFS1lrVrJ49pyAcqRs1NfKGdT9
         dK5SqXB9JmB+id7FEvJKjl4e4I5IiArymKbf8E3mpU4Ewj30eXQLtCeOq+XJOfDWXIqW
         jMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GmjrBCvMDnrN5WSFCLajJ8bTqGflO1i7+JSr9It/EWc=;
        b=p+c4yCAdQ4bskWZNxJ2W4CW0t4afYyOOOKMowkoXSKhuGKpBaHUv3azlE+YlZLHvi0
         1FhmVj9LZd3bbp5xxIIORh9CYI1DOxqFGg0eAZRuHq0XUhJ6k2ztfE6EJnt1b4JwTxnh
         BAJ+skDBRwO35kC4/uesCOlMfXxTjpvh72Qu0daY+ZtQ5c1rk3dE113M7QmxwUHYat53
         g+JhbybUFNMHwcG1RYtoCMaclCpetblLJQ2fyDA4BSeQrikVyF+yFDBZtXFFKiI2CAuZ
         gHNm2XpmIx2ZLZH1/e3z0Lt9Jam0N8o+MAaZ3vtrJpsAtjatKGIVVNbgcCtMQ7a6ygZP
         UKXg==
X-Gm-Message-State: APjAAAXR3ugT5MQhnRmLmnCafIfZlkpf37StteB5amrCF0aufEiysAPE
        TrPiEVyZ0ez9NSo1G2vFBtmk6g==
X-Google-Smtp-Source: APXvYqwlfxFGxU6uwv6jhcMu0rKVzGnVxSRBBkcr+1JAeEB3yNLukggwvld+Qv0r3g2ZrzXaWxlHnQ==
X-Received: by 2002:a05:6808:9ba:: with SMTP id e26mr349582oig.81.1576005086733;
        Tue, 10 Dec 2019 11:11:26 -0800 (PST)
Received: from ziepe.ca ([217.140.111.136])
        by smtp.gmail.com with ESMTPSA id r6sm1682834otd.66.2019.12.10.11.11.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Dec 2019 11:11:26 -0800 (PST)
Received: from jgg by LT-JGG-7470.mtl.com with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iekur-00001y-KL; Tue, 10 Dec 2019 15:11:25 -0400
Date:   Tue, 10 Dec 2019 15:11:25 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com
Subject: Re: [net-next v3 00/20][pull request] Intel Wired LAN Driver Updates
 2019-12-09
Message-ID: <20191210191125.GG46@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191210172233.GA46@ziepe.ca>
 <324a6a4c7553cea5225b6f94ff224e155a252b36.camel@intel.com>
 <20191210182543.GE46@ziepe.ca>
 <a13f11a31d5cafcc002d5e5ca73fe4a8e3744fb5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a13f11a31d5cafcc002d5e5ca73fe4a8e3744fb5.camel@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:41:54AM -0800, Jeff Kirsher wrote:
> On Tue, 2019-12-10 at 14:25 -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 10, 2019 at 10:06:41AM -0800, Jeff Kirsher wrote:
> > > > Please don't send new RDMA drivers in pull requests to net. This
> > > > driver is completely unreviewed at this point.
> > > 
> > > This was done because you requested a for a single pull request in an
> > > earlier submission 9 months ago.  I am fine with breaking up
> > > submission,
> > > even though the RDMA driver would be dependent upon the virtual bus and
> > > LAN
> > > driver changes.
> > 
> > If I said that I ment a single pull request *to RDMA* with Dave's acks
> > on the net side, not a single pull request to net.
> > 
> > Given the growth of the net side changes this may be better to use a
> > shared branch methodology.
> 
> I am open to any suggestions you have on submitting these changes that has
> the least amount of thrash for all the maintainers involved.
> 
> My concerns for submitting the network driver changes to the RDMA tree is
> that it will cause David Miller a headache when taking additional LAN
> driver changes that would be affected by the changes that were taken into
> the RDMA tree.

If you send the PR to rdma then you must refrain from sending changes
to net that would conflict with it.

I also do not want a headache with conflicts to a huge rdma driver in
net, so you cannot send it to -net.

Mellanox uses a shared branch approach now, it is working well but
requires discipline to execute.

You can also send your changes to net, wait a cycle then send the rdma
changes. IIRC one of the other drivers is working this way.

Jason

