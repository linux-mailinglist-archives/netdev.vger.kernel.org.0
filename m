Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837F811BD93
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 21:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLKUCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 15:02:03 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38183 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfLKUCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 15:02:03 -0500
Received: by mail-oi1-f193.google.com with SMTP id b8so14382592oiy.5
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 12:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g3bJuUaLyL2VFZYFbkaoSwsmrv1zbc4GsOZTr/pd6to=;
        b=GLc8U8ER8mC5XiReAgATgNGs2Ol6tiFV/1Vh5KIjgwHR1Fdc1pEVFrr5jyBVpLt/Hj
         THIcIhky0YndpEIWHf5z2T/PXD/VY1w9H607XgMjtDuwSrSxHkO7PKIWD6M4j+9IaFt+
         2VYkz270LcDP79S8+LYwGigH8uv+bypMWjvyEWdP5wPiCxhEhOGFuW518GoiCyHK/XwV
         UXT6D73jx290uJH1ju9IaTk9YFxhUq16oq/uz7o5ss5nkyJKX5RH4LZl8H0xPpg9iXtv
         cP17q+GPZ2xvXZMVOMTHfdgrruI6+a+11V2SBATvFAOnh90d19HcUH8IyTPQg0A1C7YQ
         VBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g3bJuUaLyL2VFZYFbkaoSwsmrv1zbc4GsOZTr/pd6to=;
        b=T76Z+c4kzG8aVCjNv2chwElFwDO8UUtxpG6YS0u/so0hh6/S/IY9SbiTKpq6voFH2k
         8/H3KTUJqMYNmSkZvPIDiKFeTH5ZBDb30pP1MBagHM3bBgC6NSTZf9l+qoH8ualfwVjn
         i7LgT2ZtExgbY/6e4h6qROOAGxK1jwqDnPr30kv49berAvoazs0gGHgbxsdeHtV6UBpT
         R8YItYt384oVAvkF6g/1eSrkNKXKsXRYZxOLDK/jVVj5eoTp/8NZmAWU/VZhJduy1abu
         TvmS3dPSPvxokA1VxENy5Bc9lNx6pY0s/OEdaxVei09lAT0Qf0IPZIUutbui8+ag+eUz
         i8Ow==
X-Gm-Message-State: APjAAAUOV6U+PU33hpYZu99iwdW9yQY24jWH7xmdxxRBvJQwRS7nwGFW
        uHxVndc9IKReuZW8A2WuYFJnNQ==
X-Google-Smtp-Source: APXvYqwSNfEpmU+gcH5IN9C9kiT1CF65+u4xWW8KPWPrB/3SN3QTyW62PKOIKtmB4JHlQvwUfISiUw==
X-Received: by 2002:a05:6808:f:: with SMTP id u15mr4011672oic.164.1576094522380;
        Wed, 11 Dec 2019 12:02:02 -0800 (PST)
Received: from ziepe.ca ([217.140.111.136])
        by smtp.gmail.com with ESMTPSA id j202sm1147859oih.8.2019.12.11.12.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Dec 2019 12:02:01 -0800 (PST)
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1if8BN-0003dP-04; Wed, 11 Dec 2019 16:02:01 -0400
Date:   Wed, 11 Dec 2019 16:02:00 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com
Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Message-ID: <20191211200200.GA13279@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:49:34PM -0800, Jeff Kirsher wrote:
> From: Shiraz Saleem <shiraz.saleem@intel.com>
> 
> Add Kconfig and Makefile to build irdma driver.
> 
> Remove i40iw driver. irdma is the replacement driver
> that supports X722.

I looked through this for a litle while, it is very very big. I'd like
some of the other people who have sent drivers lately to give it a go
over as well..

A few broad comments 
 - Do not use the 'err1', 'err2', etc labels for goto unwind
 - Please check all uses of rcu, I could not see why some existed
 - Use the new rdma mmap api. The whole mmap flow looked wonky to me
 - Check explicit casts, I saw alot that where questionable
 - Make sure rdma-core still builds after all the kernel uapi header
   changes - looks to me like it breaks the build
 - Check that atomics should not actually be a refcount_t
 - New drivers should use the ops->driver_unregister flow
 - devlink in the rdma driver seems very strange, I thought this
   should be in the PCI function driver?
 - The whole cqp_compl_thread thing looks really weird

Jason
