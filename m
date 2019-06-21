Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3584EC95
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfFUPxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:53:19 -0400
Received: from www.llwyncelyn.cymru ([82.70.14.225]:47690 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFUPxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:53:19 -0400
X-Greylist: delayed 1955 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jun 2019 11:53:18 EDT
Received: from alans-desktop (82-70-14-226.dsl.in-addr.zen.co.uk [82.70.14.226])
        by fuzix.org (8.15.2/8.15.2) with ESMTP id x5LFKPst025590;
        Fri, 21 Jun 2019 16:20:25 +0100
Date:   Fri, 21 Jun 2019 16:20:24 +0100
From:   Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 0/3] net: fddi: skfp: Use PCI generic definitions
 instead of private duplicates
Message-ID: <20190621162024.53620dd9@alans-desktop>
In-Reply-To: <20190621094607.15011-1-puranjay12@gmail.com>
References: <20190621094607.15011-1-puranjay12@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jun 2019 15:16:04 +0530
Puranjay Mohan <puranjay12@gmail.com> wrote:

> This patch series removes the private duplicates of PCI definitions in
> favour of generic definitions defined in pci_regs.h.

Why bother ? It's an ancient obsolete card ?

Do you even have one to test ?

> 
> This driver only uses some of the generic PCI definitons,
> which are included from pci_regs.h and thier private versions
> are removed from skfbi.h with all other private defines.
> 
> The skfbi.h defines PCI_REV_ID and other private defines with different
> names, these are renamed to Generic PCI names to make them
> compatible with defines in pci_regs.h.
> 
> All unused defines are removed from skfbi.h.

I sincerely doubt anyone on the planet is using this card any more.

Alan
