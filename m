Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3E1A794B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439012AbgDNLTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:19:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45690 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438988AbgDNLTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:19:08 -0400
Received: by mail-ed1-f68.google.com with SMTP id m12so16552857edl.12;
        Tue, 14 Apr 2020 04:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kLr1otCrFIODbPMjYkvy3aKgept10MpBYq6j6d3c97s=;
        b=Lkpk71t5dUqBb1Br8APtSp2E/Ovfy4KU5iskMlVizPr3JdwxjAnHr0aXEDsGwBR8xd
         DyXXXwDSRirPCe0zZn/ANlwYeyH1IEAFNgVzrgjafNQ0aR/wXNPvx7cedaMDmQHkXUYN
         EZjHxD9vSd3a2RBbywqSQCEUUErYivDr2tg9MzL8cnZT2HrgkQ6fKzmTBT7aj4i+hDwZ
         iyDe/1BqP++5vgKwITGM+57Cigfl1sRmfLNKlWMUKghBRWoxKjX5H1nxqZ7ljjcAzzMS
         PQ8dyuxL9IjpvV3EvQGJOtYjvhiWQX04JQVY9BEURda+Uur3h7w+74+mbG2KLVXsmHID
         c+yg==
X-Gm-Message-State: AGi0PuYV65CIKOT8fCSmDGTerMGIH0/cZlI4KGDQMUxWEXo0IPHEol0n
        lKs2fNXOaBj9ccPRI2pcf+4wcteO
X-Google-Smtp-Source: APiQypI+e8NhZbH4s6s1t6e787WWdZVnlyyo3DThuzngTxyATZQvoEtvVJUA6KnpSKeyc8xiorGa1Q==
X-Received: by 2002:a17:906:7e19:: with SMTP id e25mr20500556ejr.358.1586863146621;
        Tue, 14 Apr 2020 04:19:06 -0700 (PDT)
Received: from kozik-lap ([194.230.155.125])
        by smtp.googlemail.com with ESMTPSA id j5sm1662117edh.4.2020.04.14.04.19.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 04:19:05 -0700 (PDT)
Date:   Tue, 14 Apr 2020 13:19:03 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: Build regressions/improvements in v5.7-rc1
Message-ID: <20200414111903.GA1895@kozik-lap>
References: <20200413093100.24470-1-geert@linux-m68k.org>
 <alpine.DEB.2.21.2004131232220.32713@ramsan.of.borg>
 <877dyijrh7.fsf@mpe.ellerman.id.au>
 <20200414110627.GA1373@kozik-lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200414110627.GA1373@kozik-lap>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 01:06:27PM +0200, Krzysztof Kozlowski wrote:
> On Tue, Apr 14, 2020 at 08:23:32PM +1000, Michael Ellerman wrote:
 > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable-4k.h: error: expected ')' before '!=' token:  => 58:40
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable-4k.h: error: expected ')' before '==' token:  => 57:37
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable-4k.h: error: expected identifier or '(' before '!' token:  => 56:25
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected ')' before '!=' token:  => 163:40
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected ')' before '==' token:  => 333:50
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected ')' before '^' token:  => 333:36
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected identifier or '(' before '!' token:  => 146:27, 144:24, 160:25, 161:24, 143:25
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected identifier or '(' before 'struct':  => 77:21
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/pgtable.h: error: redefinition of 'pgd_huge':  => 291:19
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/pte-book3e.h: error: redefinition of 'pte_mkprivileged':  => 108:26
> > >>  + /kisskb/src/arch/powerpc/include/asm/nohash/pte-book3e.h: error: redefinition of 'pte_mkuser':  => 115:20
> > >>  + /kisskb/src/arch/powerpc/kvm/book3s_64_vio_hv.c: error: 'struct kvm_arch' has no member named 'spapr_tce_tables':  => 68:46, 68:2
> > >
> > > ppc64_book3e_allmodconfig
> > 
> > Caused by:
> > 
> > e93a1695d7fb ("iommu: Enable compile testing for some of drivers")
> > 
> > Which did:
> > 
> >  config SPAPR_TCE_IOMMU
> >  	bool "sPAPR TCE IOMMU Support"
> > -	depends on PPC_POWERNV || PPC_PSERIES
> > +	depends on PPC_POWERNV || PPC_PSERIES || (PPC && COMPILE_TEST)
> > 
> > 
> > Which is just ... not right, the dependencies on the correct platform
> > are important, otherwise the build breaks.
> 
> The SPAPR_TCE_IOMMU should compile fine.  The actual trouble here is
> that KVM_BOOK3S_64 selects SPAPR_TCE_IOMMU which is a user-visible
> symbol.  This is generally discouraged because of exactly this error -
> select ignores any dependencies.
> 
> I can revert the COMPILE_TEST for SPAPR_TCE_IOMMU or change
> select->depends in KVM_BOOK3S_64.  I think the latter is the proper
> change here.

Eh, not really, it looks more complex because there are more
dependencies (the book3s_64_vio_hv is pulled by KVM Makefile if
SPAPR_TCE_IOMMU is set).

I guess the revert of this part makes most sense.

Best regards,
Krzysztof

