Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA1426A1F2
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgIOJTx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 05:19:53 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59441 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgIOJTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:19:44 -0400
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A7B9F60004;
        Tue, 15 Sep 2020 09:19:26 +0000 (UTC)
Date:   Tue, 15 Sep 2020 11:19:25 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Joe Perches <joe@perches.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        linux-wireless@vger.kernel.org, linux-fbdev@vger.kernel.org,
        oss-drivers@netronome.com, nouveau@lists.freedesktop.org,
        alsa-devel <alsa-devel@alsa-project.org>,
        dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, linux-mtd@lists.infradead.org,
        linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-rtc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        dccp@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        linux-afs@lists.infradead.org, coreteam@netfilter.org,
        intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kees Cook <kees.cook@canonical.com>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-sctp@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
        storagedev@microchip.com, ceph-devel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-mips@vger.kernel.org, iommu@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
Message-ID: <20200915111925.475dd3f1@xps13>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

For MTD:

>  drivers/mtd/nand/raw/nandsim.c                            |  2 +-

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>


Thanks,
Miquèl
