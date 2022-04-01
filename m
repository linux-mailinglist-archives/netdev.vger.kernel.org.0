Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2CD4EE797
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 07:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244987AbiDAFLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 01:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiDAFLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 01:11:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE0E1E7465;
        Thu, 31 Mar 2022 22:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a4BwqPk85GvPQxl/KizQiBDKTaZ08byn7qa3hx7iA34=; b=KOJwv85m6nI+qdKCQfs1p86OPU
        5FGO4RDDxrv9sy1p8lvRJtiwijAhVpxSL9BTzhqne/tfnoBq8NaP95VeLGBWolHJ2TZ+QLu6F8EuE
        Tv4t4+0Itm7WEWNWgDlfdspUCl2Nw3fCn+g8Z7UlFJA1WKtzwrlvYtVuYWfH1f+Elg64l1KozGGQ8
        WO4Dvih0mV6eDMlTyivd5mgpV8JUBTG1dmaTxa1tFf9P1JkD+H1HarQnX1QmjVAsYaZhj8ATcv52h
        HWAJTu2xVXIX9YnJF4PtWohwzxMMxkxqDCv3alWVtz4d3Tg6SBxTnHgtc5GbvN7VoRpsFvVtmG/+V
        VxO044TA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1na9XO-004Vvf-RF; Fri, 01 Apr 2022 05:09:30 +0000
Date:   Thu, 31 Mar 2022 22:09:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Moore, Robert" <robert.moore@intel.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Benjamin =?iso-8859-1?Q?St=FCrz?= <benni@stuerz.xyz>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-atm-general@lists.sourceforge.net" 
        <linux-atm-general@lists.sourceforge.net>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Harald Welte <laforge@gnumonks.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "dennis.dalessandro@cornelisnetworks.com" 
        <dennis.dalessandro@cornelisnetworks.com>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Gregory Clement <gregory.clement@bootlin.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>,
        "3chas3@gmail.com" <3chas3@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Len Brown <lenb@kernel.org>,
        "mike.marciniszyn@cornelisnetworks.com" 
        <mike.marciniszyn@cornelisnetworks.com>,
        Robert Richter <rric@kernel.org>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@kernel.org>,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux@simtec.co.uk" <linux@simtec.co.uk>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        James Morse <james.morse@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [PATCH 05/22] acpica: Replace comments with C99 initializers
Message-ID: <YkaJCjhyrRfAb3by@infradead.org>
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-5-benni@stuerz.xyz>
 <CAHp75VeTXMAueQc_c0Ryj5+a8PrJ7gk-arugiNnxtAm03x7XTg@mail.gmail.com>
 <BYAPR11MB3256D71C02271CD434959E0187E19@BYAPR11MB3256.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB3256D71C02271CD434959E0187E19@BYAPR11MB3256.namprd11.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please fix your mailer.  This mail is completely unreadable.
