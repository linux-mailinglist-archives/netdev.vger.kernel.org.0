Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6D18A372
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCRUEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgCRUEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:04:44 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC602071C;
        Wed, 18 Mar 2020 20:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584561884;
        bh=wyV+GxC7PAsjV738sIOJrbKaZkxOpnmQepQl32CCaBE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eCJAz7B6vut8/ssdGpJVTIS3hFrxqlFZgxC8CyCO7hOqQ7OOFKo1aJ7gjXqdxj0Zb
         w97U/XOBQA5BPk+dng9xV4x2hUV+QiyH9exroneRfNHpOJIg+qaTmq1qf7wQXacMcU
         rzf5YNZuNKftCzfC108/NQXI8PDprVn1UxKn7dVQ=
Date:   Wed, 18 Mar 2020 13:04:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
Message-ID: <20200318130441.42ac70b5@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAACQVJqSMsMNChPssuw850HVYXYJAYx=HcwYXGrG3FsMgVQf1g@mail.gmail.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAACQVJqSMsMNChPssuw850HVYXYJAYx=HcwYXGrG3FsMgVQf1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 09:51:29 +0530 Vasundhara Volam wrote:
> On Tue, Mar 17, 2020 at 11:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 17 Mar 2020 20:44:38 +0530 Vasundhara Volam wrote:  
> > > Add definition and documentation for the new generic info "drv.spec".
> > > "drv.spec" specifies the version of the software interfaces between
> > > driver and firmware.
> > >
> > > Cc: Jiri Pirko <jiri@mellanox.com>
> > > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > > ---
> > >  Documentation/networking/devlink/devlink-info.rst | 6 ++++++
> > >  include/net/devlink.h                             | 3 +++
> > >  2 files changed, 9 insertions(+)
> > >
> > > diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> > > index 70981dd..0765a48 100644
> > > --- a/Documentation/networking/devlink/devlink-info.rst
> > > +++ b/Documentation/networking/devlink/devlink-info.rst
> > > @@ -59,6 +59,12 @@ board.manufacture
> > >
> > >  An identifier of the company or the facility which produced the part.
> > >
> > > +drv.spec
> > > +--------
> > > +
> > > +Firmware interface specification version of the software interfaces between  
> >
> > Why did you call this "drv" if the first sentence of the description
> > says it's a property of the firmware?  
>
> Since it is a version of interface between driver and firmware. Both
> driver and firmware
> can support different versions. I intend to display the version
> implemented in the driver.

We're just getting rid of driver versions, with significant effort,
so starting to extend devlink info with driver stuff seems risky.
How is driver information part of device info in the first place?

As you said good driver and firmware will be modular and backward
compatible, so what's the meaning of the API version?

This field is meaningless.

> I can probably add for both driver and firmware. Add it is as drv.spec
> and fw.spec.
