Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55805356F94
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349057AbhDGPAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:00:52 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:44970 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348928AbhDGPAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:00:44 -0400
Received: by mail-wr1-f48.google.com with SMTP id e12so5270703wro.11;
        Wed, 07 Apr 2021 08:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EwbSmztaZBEk6NfE4Xk0DiplD2tvdJVlSEP8EVaTzgI=;
        b=mMrMzgZBaW4NtQjYbt9ndPz54UL85fxm5xvP+Zz5kRhtlL4YKzvbUgCchRXEC7LF6+
         e6E9pCaJOfcMYMOUFaFOWR6snHYcCyPuA4epqn4aEHFGl8XJaxpjTF0dbvnu36n8W4Ej
         MIwMzpcCry3SCpolf9gYmcjjkwVcSa5wJ4jORFNqKvfYBPE6LnHXaO3vYYSZ1QnUmkTo
         STcbPhVo3Xf7zQp8Bht0eRhJW5cUqrb1vgwk13W/F50m6Zh/+Ig8h4N4ZfdEuHmwIr1n
         zo/xe5+tXD9NYtEVLJkqsPQH9kKsR0ozzH5GH85ysFaCXT4d4WtrfKlXdjU/WvpWn6lz
         yIOw==
X-Gm-Message-State: AOAM533zTORG57kS1UqWBk197A9VcO07Yaod3gGI+C3tJdXtY4gnYFBE
        Kd8Rkse/zYS74NaNeGma7dg=
X-Google-Smtp-Source: ABdhPJwIU8dU9ZSylWoXAhdqqz2MvpUuLkN1zsOGbRXUcNgyW0reyvp4B2vCqtwucpNoE9UGhf48qg==
X-Received: by 2002:a05:6000:1c7:: with SMTP id t7mr4956713wrx.313.1617807632297;
        Wed, 07 Apr 2021 08:00:32 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id r5sm3763370wrx.87.2021.04.07.08.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 08:00:32 -0700 (PDT)
Date:   Wed, 7 Apr 2021 15:00:30 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210407150030.wvwz6cebxjtjpgfv@liuwe-devbox-debian-v2>
References: <20210406232321.12104-1-decui@microsoft.com>
 <20210407131705.4rwttnj3zneolnh3@liuwe-devbox-debian-v2>
 <DM5PR2101MB0934D037F5541B0FA449FA34CA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR2101MB0934D037F5541B0FA449FA34CA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 02:34:01PM +0000, Haiyang Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Wei Liu <wei.liu@kernel.org>
> > Sent: Wednesday, April 7, 2021 9:17 AM
> > To: Dexuan Cui <decui@microsoft.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> > <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> > Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> > <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> > Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
> > Network Adapter (MANA)
> > 
> > On Tue, Apr 06, 2021 at 04:23:21PM -0700, Dexuan Cui wrote:
> > [...]
> > > +config MICROSOFT_MANA
> > > +	tristate "Microsoft Azure Network Adapter (MANA) support"
> > > +	default m
> > > +	depends on PCI_MSI
> > > +	select PCI_HYPERV
> > 
> > OOI which part of the code requires PCI_HYPERV?
> > 
> > Asking because I can't immediately find code that looks to be Hyper-V
> > specific (searching for vmbus etc). This device looks like any other PCI devices
> > to me.
> 
> It depends on the VF nic's PCI config space which is presented by the pci_hyperv driver.

I think all it matters is the PCI bus is able to handle the
configuration space access, right? Assuming there is an emulated PCI
root complex which exposes the config space to the driver, will this
driver still work?

I'm trying to understand how tightly coupled with Hyper-V PCI this
driver is. In an alternative universe, Microsft may suddenly decide to
sell this hardware and someone wants to passthrough an VF via VFIO. I
don't see how this driver wouldn't work, hence the original question.

There is no need to change the code. I'm just curious about a tiny
detail in the implementation.

Wei.

> 
> Thanks,
> - Haiyang
