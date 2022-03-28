Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C684E986A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 15:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbiC1Nke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 09:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbiC1Nka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 09:40:30 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6B1E13F1C;
        Mon, 28 Mar 2022 06:38:49 -0700 (PDT)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 22SDJU00005431;
        Mon, 28 Mar 2022 08:19:30 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 22SDJSov005423;
        Mon, 28 Mar 2022 08:19:28 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 28 Mar 2022 08:19:28 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Benjamin =?iso-8859-1?Q?St=FCrz?= <benni@stuerz.xyz>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-atm-general@lists.sourceforge.net,
        linux-ia64@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>,
        Harald Welte <laforge@gnumonks.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "H. Peter Anvin" <hpa@zytor.com>, wcn36xx@lists.infradead.org,
        Pkshih <pkshih@realtek.com>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES" 
        <linux-samsung-soc@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        dennis.dalessandro@cornelisnetworks.com,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>,
        Chas Williams <3chas3@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Len Brown <lenb@kernel.org>,
        mike.marciniszyn@cornelisnetworks.com,
        Robert Richter <rric@kernel.org>,
        Andrew Donnellan <ajd@linux.ibm.com>, kvalo@kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        loic.poulain@linaro.org, Borislav Petkov <bp@alien8.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Tony Luck <tony.luck@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        gregkh <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        James Morse <james.morse@arm.com>,
        Networking <netdev@vger.kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [PATCH 01/22] orion5x: Replace comments with C99 initializers
Message-ID: <20220328131928.GH614@gate.crashing.org>
References: <20220326165909.506926-1-benni@stuerz.xyz> <CAK8P3a1e57mNUQgronhwrsXsuQW9sZYxCktKij7NwsieBWiGmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK8P3a1e57mNUQgronhwrsXsuQW9sZYxCktKij7NwsieBWiGmw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 08:23:31PM +0100, Arnd Bergmann wrote:
> On Sat, Mar 26, 2022 at 5:58 PM Benjamin Stürz <benni@stuerz.xyz> wrote:
> >
> > This replaces comments with C99's designated
> > initializers because the kernel supports them now.
> 
> The change looks fine, but the comment looks misplaced, as enum initializers
> are not c99 feature.

Yes, it is from C89/C90.

> Also, the named array and struct intializers have been
> supported by gnu89 for a long time and widely used in the kernel, so it's
> not a recent change even for the others.

GCC supports this since 1998.  There was a syntax different from C99
designated initializers (".ans = 42") before (namely, "ans: 42").

1998 is long enough ago for all intents and purposes now of course ;-)


Segher
