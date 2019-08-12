Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDFB8A835
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 22:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfHLULg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 16:11:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60662 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfHLULf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 16:11:35 -0400
Received: from p200300ddd71876867e7a91fffec98e25.dip0.t-ipconnect.de ([2003:dd:d718:7686:7e7a:91ff:fec9:8e25])
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hxGf2-0005KS-ES; Mon, 12 Aug 2019 22:11:20 +0200
Date:   Mon, 12 Aug 2019 22:11:14 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
cc:     Denis Efremov <efremov@linux.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Add definition for the number of standard PCI BARs
In-Reply-To: <20190812200134.GB11785@google.com>
Message-ID: <alpine.DEB.2.21.1908122210300.7324@nanos.tec.linutronix.de>
References: <20190811150802.2418-1-efremov@linux.com> <20190812200134.GB11785@google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019, Bjorn Helgaas wrote:

> On Sun, Aug 11, 2019 at 06:07:55PM +0300, Denis Efremov wrote:
> > Code that iterates over all standard PCI BARs typically uses
> > PCI_STD_RESOURCE_END, but this is error-prone because it requires
> > "i <= PCI_STD_RESOURCE_END" rather than something like
> > "i < PCI_STD_NUM_BARS". We could add such a definition and use it the same
> > way PCI_SRIOV_NUM_BARS is used. There is already the definition
> > PCI_BAR_COUNT for s390 only. Thus, this patchset introduces it globally.
> > 
> > The patch is splitted into 7 parts for different drivers/subsystems for
> > easy readability.
> 
> This looks good.  I can take all these together, since they all depend
> on the first patch.  I have a few comments on the individual patches.
> 
> > Denis Efremov (7):
> >   PCI: Add define for the number of standard PCI BARs
> >   s390/pci: Replace PCI_BAR_COUNT with PCI_STD_NUM_BARS
> >   x86/PCI: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END

Fine with me for the x86 part. That's your turf anyway :)

Thanks,

	tglx
