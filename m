Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA8E0AB1
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbfJVRaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:30:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42152 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732657AbfJVRaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:30:02 -0400
Received: by mail-lj1-f196.google.com with SMTP id u4so3938475ljj.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 10:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HmmPBl6eQCJQQpK05KW2nNJH7nyGoslANOpWRy61vOw=;
        b=zYh25urd8gs/0FeIw9pUR75l7cU4AlLmzOJvB6ZLBSpfGISKg9PuCs9ZV2wD0jAI7V
         cKcsmwjQWpX/u/wIY3StphOwuuFtS/TuWDnRTA42d6kACzgwf0gyqwpERegSyMe2dIMn
         LIUDxpLB9H8xTqkLR+RhcjAyMsrw+rc/EaSQldj/orTbyI734aVIWjj7GZd6MtmU5Znh
         i2b9LYEIiZtRB73o1wmzfB2xBuzW+gKyJfEqcev98AZ5SVm2QXuz2VhM07AqGahfr4Iu
         VaDKlG7ehiyVq5urU0fsWwcwl2WX0avYGr7HBnb3BjEoJGegVQ5LdaqXKmskejbCYh3e
         ItfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HmmPBl6eQCJQQpK05KW2nNJH7nyGoslANOpWRy61vOw=;
        b=UDc/37eanBq1IxD5t0D/EKDUEM3TCNCttjgB/yQ7TxMQNarOU2uRjOt2oce1NHfmH7
         Wof1EJnL9Kc/Vac57Wa+la/JJ+Cqle29RjyHC+XaCYgxoBjc4XhPzH1nUyMEUfuLMAPU
         MCRA9zN0EKfaRvx4HbPTuxidWd5tuVBvax2vLokdAR8WIh5oLR59lBTPy0nsVOGLXwcz
         2eTUxtezkBXw3TByt2/qHZpNccVKti8znmG06ybnwFp12jIBF/qP5GWb8hs+R4VmsSB0
         fZDX0Z0ZCNrK01ABYqJrjXOmnud7GUNPHaSjvcfd2hxRuIhOZssSBoEWT4bb9hBa1opZ
         zJ/w==
X-Gm-Message-State: APjAAAVKLZ8rDKiWGQGTXza5Xi0YKbosPvD8NNVRPTrkL4zfd3yTerxt
        Lj0la3uCfWOqOrMiDjJb5eWn1g==
X-Google-Smtp-Source: APXvYqxpzJg00yRe3OjBd6BnC1zysssaNWZcfUFrdIXzW/KSn/Vdod1X21VKHzDtvBdgHy9erg6Qcw==
X-Received: by 2002:a2e:416:: with SMTP id 22mr3073575lje.55.1571765400271;
        Tue, 22 Oct 2019 10:30:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h21sm1288560ljl.20.2019.10.22.10.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 10:30:00 -0700 (PDT)
Date:   Tue, 22 Oct 2019 10:29:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        anirudha.sarangi@xilinx.com, john.linn@xilinx.com,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: axienet: In kconfig add ARM64 as
 supported platform
Message-ID: <20191022102952.09211971@cakuba.netronome.com>
In-Reply-To: <cbdd6608-804a-086c-1892-1903ec4a7d80@xilinx.com>
References: <1571653110-20505-1-git-send-email-radhey.shyam.pandey@xilinx.com>
        <cbdd6608-804a-086c-1892-1903ec4a7d80@xilinx.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 16:15:45 +0200, Michal Simek wrote:
> On 21. 10. 19 12:18, Radhey Shyam Pandey wrote:
> > xilinx axi_emac driver is supported on ZynqMP UltraScale platform.
> > So enable ARCH64 in kconfig. It also removes redundant ARCH_ZYNQ
> > dependency. Basic sanity testing is done on zu+ mpsoc zcu102
> > evaluation board.
> > 
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > ---
> > Changes for v2:
> > Remove redundant ARCH_ZYNQ dependency.
> > Modified commit description.
> > ---
> >  drivers/net/ethernet/xilinx/Kconfig | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
> > index 8d994ce..da11876 100644
> > --- a/drivers/net/ethernet/xilinx/Kconfig
> > +++ b/drivers/net/ethernet/xilinx/Kconfig
> > @@ -6,7 +6,7 @@
> >  config NET_VENDOR_XILINX
> >  	bool "Xilinx devices"
> >  	default y
> > -	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
> > +	depends on PPC || PPC32 || MICROBLAZE || MIPS || X86 || ARM || ARM64 || COMPILE_TEST
> >  	---help---
> >  	  If you have a network (Ethernet) card belonging to this class, say Y.
> >  
> > @@ -26,11 +26,11 @@ config XILINX_EMACLITE
> >  
> >  config XILINX_AXI_EMAC
> >  	tristate "Xilinx 10/100/1000 AXI Ethernet support"
> > -	depends on MICROBLAZE || X86 || ARM || COMPILE_TEST
> > +	depends on MICROBLAZE || X86 || ARM || ARM64 || COMPILE_TEST
> >  	select PHYLINK
> >  	---help---
> >  	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
> > -	  AXI bus interface used in Xilinx Virtex FPGAs.
> > +	  AXI bus interface used in Xilinx Virtex FPGAs and Soc's.
> >  
> >  config XILINX_LL_TEMAC
> >  	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
> >   
> 
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> 
> But I can image that others could prefer to remove all dependencies.

Yes, we'd much rather see this litany of architectures removed.
Is there any reason it's there in the first place?

Most drivers are tested on just a few architectures, but as long
as correct APIs are used they are assumed to work across the board.
Otherwise 75% of our drivers would be x86 only. Don't be shy.
