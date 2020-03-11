Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB418159E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 11:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCKKQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 06:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgCKKQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 06:16:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC4352082F;
        Wed, 11 Mar 2020 10:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583921809;
        bh=ao16VUD39NcqXQan2raSpeGb8J8BV+ZcPrb5tn9PXhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qvw48Wkya2Tgmm7RBRqoxQwa6Qdi6OUTeBXPclgHOkG5Z44o8cmcQVHOUpHilfq2M
         j3bPVoWmO9C8ifbKBuiUjO9KFSr+cG8RWRZmP9Qudia7ryoQwKbG/oR9eAx4WLMmxu
         AYR+Qh/X802GqY4W7tbYFO8qxKjaEfIJorTzYDyw=
Date:   Wed, 11 Mar 2020 12:16:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 3/6] octeontx2-vf: Virtual function driver
 dupport
Message-ID: <20200311101646.GJ4215@unreal>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-4-git-send-email-sunil.kovvuri@gmail.com>
 <20200310144320.4f691cb6@kicinski-fedora-PC1C0HJN>
 <CA+sq2Ce7OFeKXBc_hHWODGuhgfNmfhOanhW4uyr=GLxAwZUPKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2Ce7OFeKXBc_hHWODGuhgfNmfhOanhW4uyr=GLxAwZUPKw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:44:00PM +0530, Sunil Kovvuri wrote:
> On Wed, Mar 11, 2020 at 3:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 11 Mar 2020 00:17:22 +0530 sunil.kovvuri@gmail.com wrote:
> > > +#define DRV_NAME     "octeontx2-nicvf"
> > > +#define DRV_STRING   "Marvell OcteonTX2 NIC Virtual Function Driver"
> > > +#define DRV_VERSION  "1.0"
> >
> > Please drop the driver version, kernel version should be used upstream.
> >
>
> Okay, will do.
>
> > > +
> > > +static const struct pci_device_id otx2_vf_id_table[] = {
> > > +     { PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
> > > +     { PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_VF) },
> > > +     { }
> > > +};
> > > +
> > > +MODULE_AUTHOR("Marvell International Ltd.");
> >
> > Only people can be authors, please put your name here or remove this.
> >
>
> Just for my understanding, is this due to a decision taken in netdev recently ?
> I have searched through all drivers in netdev and there is a mix of
> organizations and individuals as AUTHORS.
> Here we used org name to avoid specifying multiple names.

It was always the case in all subsystems. The authorship belongs to the developer
and not to the company. In opposite to the copyright.

Thanks
