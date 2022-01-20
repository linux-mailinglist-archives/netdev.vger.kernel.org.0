Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA29F4948E9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbiATHy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:54:28 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50177 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230405AbiATHy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 02:54:27 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5CAC65C018D;
        Thu, 20 Jan 2022 02:54:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 20 Jan 2022 02:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9VURfEWqy+HkoUXp5
        6wSoSqBU2Hu9rCAvCF49LnegvY=; b=ROJy5FJGx7V+HMRHKedL0SFAm8oEhNNwK
        64fCr+njJUkoeoHrImMJJdOHnEaGRmLcj8QhgjILNPaHsoQ0ZzCaoF4jIDxQvMjs
        iyKeDkB7o6G+jESRoL/00ldfShDyrU1fswN94bI3kq76uVdXPvUXBBFTtkfW5n4l
        pOh79s3BRaBOOqTF8glvCMpcgjXD1pR2HWs4klhOS/S7UQSLb/RJ9tOR3nZ3fzK4
        Guzqk0UxIr1cshdq2ELPVofV43/oewPl2SLdS6QgovyFt1jj05eusc8A+eSVGCos
        T7voUX13imsuq1mAJEvcaipVZU5D/kcFP4glTRcAFjhrS0FEJzquw==
X-ME-Sender: <xms:MhXpYZGXPRPoiSn2CAgNJEPHlTg-R_33rgS-fXhGPwvfc45WKbiojQ>
    <xme:MhXpYeXqB0ejdI-pczHjK2lX83ksakP-eSggGid0FLI0TT48j7jYOBgTGBQCSF3hu
    DKRamMBcJwmsH8>
X-ME-Received: <xmr:MhXpYbIZ5XNhblfZbxPhp4zGk-goXYew7eNSrk4jd45YinQnGaa8_GsU9jgRbKjN9KEzgak-CJ13Pk1pg1Y-9rAalCUT2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:MhXpYfFInX51s-WzOnU0EK7vwrl343PfbYcFNfeiP6iQ0Dk1qbaIDw>
    <xmx:MhXpYfVY8LCa96KB8ronao-rG0xhjMsrDEF6L5z4SqwMW8H0togYYg>
    <xmx:MhXpYaOaBD_nA2W03x5heM38_KEvMyEfNs8Y_s8cNrSFuVreOAPs1Q>
    <xmx:MxXpYaSR2ndShtdtPdT5WLmFj6gTEo1QcafTF9JSw2WcO2x63wVIgA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Jan 2022 02:54:26 -0500 (EST)
Date:   Thu, 20 Jan 2022 09:54:21 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, michel@fb.com,
        dcavalca@fb.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ethtool 5.16 release / ethtool -m bug fix
Message-ID: <YekVLcKZxa7ojNYc@shredder>
References: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <YefdxW/V/rjiiw2x@shredder>
 <20220119073902.507f568c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119073902.507f568c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 07:39:02AM -0800, Jakub Kicinski wrote:
> On Wed, 19 Jan 2022 11:45:41 +0200 Ido Schimmel wrote:
> > On Tue, Jan 18, 2022 at 02:51:59PM -0800, Jakub Kicinski wrote:
> > > Hi Michal!
> > > 
> > > Sorry to hasten but I'm wondering if there is a plan to cut the 5.16
> > > ethtool release? Looks like there is a problem in SFP EEPROM parsing
> > > code, at least with QSFP28s, user space always requests page 3 now.
> > > This ends in an -EINVAL (at least for drivers not supporting the paged
> > > mode).  
> > 
> > Jakub, are you sure you are dealing with QSFP and not SFP? I'm asking
> > because I assume the driver in question is mlx5 that has this code in
> > its implementation of get_module_eeprom_by_page():
> > 
> > ```
> > switch (module_id) {
> > case MLX5_MODULE_ID_SFP:
> > 	if (params->page > 0)
> > 		return -EINVAL;
> > 	break;
> > ```
> 
> Yup, it's a QSFP28 / SFF-8636, the report was with a different NIC.
> 
> > And indeed, ethtool(8) commit fc47fdb7c364 ("ethtool: Refactor
> > human-readable module EEPROM output for new API") always asks for Upper
> > Page 03h, regardless of the module type.
> > 
> > It is not optimal for ethtool(8) to ask for unsupported pages and I made
> > sure it's not doing it anymore, but I believe it's wrong for the kernel
> > to return an error. All the specifications that I'm aware of mandate
> > that when an unsupported page is requested, the Page Select byte will
> > revert to 0. That is why Upper Page 00h is always read-only.
> > 
> > For reference, see section 10.3 in SFF-8472, section 6.2.11 in SFF-8636
> > and section 8.2.13 in CMIS.
> > 
> > Also, the entire point of the netlink interface is that the kernel can
> > remain ignorant of the EEPROM layout and keep all the logic in user
> > space.
> 
> The EINVAL came from fallback_set_params().

I see. I was fixated on get_module_eeprom_by_page(), but you are using
the fallback.

> 
> As far as I can see user space will call sff8636_show_dom() regardless
> of what we return from the kernel, so returning first page again should
> not confuse anything.. as long as the fields read from page 3 happen to
> be 0 in page 0?

sff8636_show_dom() parses and prints module-level and channel-level
thresholds from page 3. It will not try to parse or print this
information if the page isn't available. This is determined based on the
'Flat_mem' bit in the lower page.

> 
> What about drivers which do implement get_module_eeprom_by_page? Can we
> somehow ensure they DTRT and are consistent with the legacy / flat API?

Not sure what you mean by that (I believe they are already doing the
right thing). Life is much easier for drivers that implement
get_module_eeprom_by_page() because they only need to fetch the
information user space is asking for. They need not perform any parsing
of the data, unlike in the legacy callbacks.

> 
> > > By the looks of it - Ido fixed this in 6e2b32a0d0ea ("sff-8636: Request
> > > specific pages for parsing in netlink path") but it may be too much code 
> > > to backport so I'm thinking it's easiest for distros to move to v5.16.  
> > 
> > I did target fixes at 'ethtool' and features at 'ethtool-next', but I
> > wasn't aware of this bug.
> 
