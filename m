Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D0B1823CE
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgCKVYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgCKVYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 17:24:53 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 359FB2074C;
        Wed, 11 Mar 2020 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583961893;
        bh=Q9rhNlQyQLDuhvVKV1SzvfWQ+1E8JgIZRk3myxlv2nU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KDobOvjDY6+YPr0toVbzLvUFmRqNdpkVFA0WZM6b8pZNLWQHM/2/m0w7N73D912OC
         bZ5O0AILNzirbocKDFHOu6PvC3fVFow77AyBuIHHFOd+ciy3iZHo7VFMEmuRAs2x6y
         F3g2UIBqYJrBOkrnzTFZUs16tJ7RMdDZNRCYGXeM=
Date:   Wed, 11 Mar 2020 14:24:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Sunil Kovvuri <sunil.kovvuri@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 3/6] octeontx2-vf: Virtual function driver
 dupport
Message-ID: <20200311142450.6f30fffa@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200311101646.GJ4215@unreal>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
        <1583866045-7129-4-git-send-email-sunil.kovvuri@gmail.com>
        <20200310144320.4f691cb6@kicinski-fedora-PC1C0HJN>
        <CA+sq2Ce7OFeKXBc_hHWODGuhgfNmfhOanhW4uyr=GLxAwZUPKw@mail.gmail.com>
        <20200311101646.GJ4215@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 12:16:46 +0200 Leon Romanovsky wrote:
> On Wed, Mar 11, 2020 at 12:44:00PM +0530, Sunil Kovvuri wrote:
> > On Wed, Mar 11, 2020 at 3:13 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > +static const struct pci_device_id otx2_vf_id_table[] = {
> > > > +     { PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
> > > > +     { PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_VF) },
> > > > +     { }
> > > > +};
> > > > +
> > > > +MODULE_AUTHOR("Marvell International Ltd.");  
> > >
> > > Only people can be authors, please put your name here or remove this.
> > >  
> >
> > Just for my understanding, is this due to a decision taken in netdev recently ?
> > I have searched through all drivers in netdev and there is a mix of
> > organizations and individuals as AUTHORS.
> > Here we used org name to avoid specifying multiple names.  
> 
> It was always the case in all subsystems. The authorship belongs to the developer
> and not to the company. In opposite to the copyright.

Yup. The enforcement hasn't been perfect since it's a hard thing to add
to checkpatch etc. But since it jumped out I thought I'd mention it.

Here's me complaining on another Marvell driver submission recently ;)

https://lore.kernel.org/netdev/20200229181214.46c2a495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
