Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015A02D3E23
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgLIJEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728634AbgLIJDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 04:03:53 -0500
Date:   Wed, 9 Dec 2020 14:33:00 +0530
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607504585;
        bh=Y8sKKGrlYezUfpA9QSrlmnL0kO7yXjvMcIxMPszDLQU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZYv88C+wY/E/J2SeDl906oq3dpbKDT6luvBWvgQIoTtv6uk70LSXQOc4LV4/Ckte2
         t2UovonfT5iDGd4TYZiJMKtE6Td0rbMVabgQIfxxzGAPJPouzmrrf7Cdq5VSoEWG56
         q3+OKUTzYzW22kRBiuIhOsQUhVtGj0btEIGytZTd6kpR81vO0k3bNJzFp7kxiFMuAS
         P2jivjBpreQyW8DQ9NQIzE3uS8JtbsnUyXVSE1qVpB3csHKn7duH6xd5l8cNGL9/dL
         p0AYMZhW78mhf8JJeZgcCWjjWmJu/y/PpwrMg7iVUj5PLUcBVq4nuWF8fIxyWO+fHP
         iGoo++aTYv9fg==
From:   Vinod Koul <vkoul@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
Message-ID: <20201209090300.GI8403@vkoul-mobl>
References: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09-12-20, 09:31, Heiner Kallweit wrote:
> pci_set_mwi() and pci_try_set_mwi() do exactly the same, just that the
> former one is declared as __must_check. However also some callers of
> pci_set_mwi() have a comment that it's an optional feature. I don't
> think there's much sense in this separation and the use of
> __must_check. Therefore remove pci_try_set_mwi() and remove the
> __must_check attribute from pci_set_mwi().
> I don't expect either function to be used in new code anyway.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> patch applies on top of pci/misc for v5.11
> ---
>  drivers/dma/dw/pci.c                          |  2 +-
>  drivers/dma/hsu/pci.c                         |  2 +-

Acked-By: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
