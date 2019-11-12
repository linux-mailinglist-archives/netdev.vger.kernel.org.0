Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA44CF9B61
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLVAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:00:02 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45917 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfKLVAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:00:02 -0500
Received: by mail-qt1-f195.google.com with SMTP id 30so21350651qtz.12
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RcA1vdVtYr2ysVNVJFn5DcgKL3bMRqBRJU+TaaCpfL0=;
        b=gsLyECWBq7P2ygaM5CenSPIK2Bb9Vzk/GapR143RLs/FRENjwLSRxB75aYNhw5984F
         rKvpW++sjGFPZRLl5Gkywo/VH4TZSIMo3Kz1Zdcr5u/c49gDlDhrtWbIqu252GfATxmH
         huRGQsHzg7f8DK06/AdCV6NOn3chUF3DGq+OsDZLShQQwKQsyC0eXXArp6Z2p2RNRQVX
         SFaLXbxKX5ZisLYH3fNPGdqqW8GGEVa5htyEoRcrHF79nrnEeGrlnGSrJ2Mhl/FUgXb5
         BZggyE+OornQNmefaRE6HGW52cGEvmbEcBgxTiDrOI4NDDUARx1mjzZFS7R5MrQt2IQH
         2PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RcA1vdVtYr2ysVNVJFn5DcgKL3bMRqBRJU+TaaCpfL0=;
        b=t9P73KXGrWASuq7WZ+hfKyBGbLh0UTchS7AWV1/YV1zaw1m8jt51i2JnTRFHYUHpFQ
         cR7S75JbNQCuuGnR8ltrHwsZ21WZg7jpvsJl9eO6l/n16Er9ZISfBkiSEHq784WmVzTk
         bt+OwT0OO/6GMOs/QhCAA7VoWVwAVaaBbpDb05z/t3iYv9fIrr2mvLsATqsWPGHNhvU7
         7ZkBZqdjhMiB5CP/elfriZ+hg/O8tilTg4wMPbHl+Li6UEYdKlHb6ct1sk1KRCZ5YD5l
         acNlt653gHpeSXNZCNNq4HBMLkQbIBKVMBaYMotlDS5n7WSM11pMPOJD/glqSfHMQweg
         F42w==
X-Gm-Message-State: APjAAAWzkEpp5ehM+tfbSVO2JfTe39uL7qWqJULfFMy8cEm0vpEggnmj
        lDg5nTWBdPbzRZ9RglatRa9HHA==
X-Google-Smtp-Source: APXvYqzqv+RVz+VwrSvo2+CFjhM5L0G7lxnRYD0DPmy0gOr43rtZwxesUpgTldGoOYGZryde9POElg==
X-Received: by 2002:aed:255c:: with SMTP id w28mr34148037qtc.185.1573592400902;
        Tue, 12 Nov 2019 13:00:00 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id w69sm9693057qkb.26.2019.11.12.12.59.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 12:59:59 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iUdGY-0004I0-Te; Tue, 12 Nov 2019 16:59:58 -0400
Date:   Tue, 12 Nov 2019 16:59:58 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, parav@mellanox.com,
        Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191112205958.GH5584@ziepe.ca>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 11:22:19AM -0800, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> This is the initial implementation of the Virtual Bus,
> virtbus_device and virtbus_driver.  The virtual bus is
> a software based bus intended to support lightweight
> devices and drivers and provide matching between them
> and probing of the registered drivers.
> 
> Files added:
> 	drivers/bus/virtual_bus.c
> 	include/linux/virtual_bus.h
> 	Documentation/driver-api/virtual_bus.rst
> 
> The primary purpose of the virual bus is to provide
> matching services and to pass the data pointer
> contained in the virtbus_device to the virtbus_driver
> during its probe call.  This will allow two separate
> kernel objects to match up and start communication.

I think this is the 'multi_subsystem_device' idea I threw out in this
thread. ie pass an opaque void *pointer, done here by
virtbus_get_devdata():
 
 https://lore.kernel.org/r/20191109084659.GB1289838@kroah.com

And Greg said 'Ick, no'..

So each driver should makes its own bus, and perhaps we should provide
some helper stuff for the repeating code, like PM function reflection?

Jason
