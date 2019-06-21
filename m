Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03F24EA28
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 16:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfFUOFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 10:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfFUOFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 10:05:06 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D5E82075E;
        Fri, 21 Jun 2019 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561125906;
        bh=9SpD7uZXF12Lgn71hZIUmDAfAlF2fpqc8oZvSOye1Ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gduhdc+w/cr/kolxidI6ZyawEhqHL84tr773iV8OL8RKQMfeOdtzbEe4enD/Z2N6/
         fV/1UP8V1+YW/UFNIJjStUdRgpNlmVzKI4kMQZ1D5/xf8kD4AFoHJ1/leobK9PPc8x
         O3HnQ33TbfucZ4IAcL8n2m9hBviPF58L6F90iA9c=
Date:   Fri, 21 Jun 2019 09:05:05 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 0/3] net: fddi: skfp: Use PCI generic definitions
 instead of private duplicates
Message-ID: <20190621140505.GF82584@google.com>
References: <20190621094607.15011-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621094607.15011-1-puranjay12@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Stephen]

On Fri, Jun 21, 2019 at 03:16:04PM +0530, Puranjay Mohan wrote:
> This patch series removes the private duplicates of PCI definitions in
> favour of generic definitions defined in pci_regs.h.
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
> 
> Puranjay Mohan (3):
>   net: fddi: skfp: Rename local PCI defines to match generic PCI defines
>   net: fddi: skfp: Include generic PCI definitions
>   net: fddi: skfp: Remove unused private PCI definitions
> 
>  drivers/net/fddi/skfp/drvfbi.c  |  3 +-
>  drivers/net/fddi/skfp/h/skfbi.h | 80 +--------------------------------
>  2 files changed, 4 insertions(+), 79 deletions(-)

It's good form to CC people who have commented on previous versions of
your series, so I added Stephen.

FWIW,

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
