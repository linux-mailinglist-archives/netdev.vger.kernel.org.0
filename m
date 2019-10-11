Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFDBD3C44
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfJKJ2H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Oct 2019 05:28:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:55754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727314AbfJKJ2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 05:28:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC74DB175;
        Fri, 11 Oct 2019 09:28:04 +0000 (UTC)
Date:   Fri, 11 Oct 2019 11:28:04 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v9 5/5] MIPS: SGI-IP27: Enable ethernet phy on second
 Origin 200 module
Message-Id: <20191011112804.ef8079aa9bad5c81ce473fbd@suse.de>
In-Reply-To: <102db20a-0c37-3e28-2d14-e9c6eaa55f5c@cogentembedded.com>
References: <20191010145953.21327-1-tbogendoerfer@suse.de>
        <20191010145953.21327-6-tbogendoerfer@suse.de>
        <102db20a-0c37-3e28-2d14-e9c6eaa55f5c@cogentembedded.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 19:37:15 +0300
Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:

> On 10/10/2019 05:59 PM, Thomas Bogendoerfer wrote:
> > +	/* enable ethernet PHY on IP29 systemboard */
> > +	pci_read_config_dword(dev, PCI_SUBSYSTEM_VENDOR_ID, &sid);
> > +	if (sid == ((PCI_VENDOR_ID_SGI << 16) | IOC3_SUBSYS_IP29_SYSBOARD))
> 
>    I thought PCI was little endian, thuis vendor ID at offset 0 and device ID
> at offset 2?

you are right. I already messed it up in pci-xtalk-bridge.c. As this is just a
fake sub device id, there is no harm, but I'll fix it.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
