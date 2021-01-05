Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D472C2EAD0F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbhAEOFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:05:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:58484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbhAEOFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:05:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1609855498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Arji6VsQzbWn/dLmQTC0xfiZ6qY2jF8dcwZUUF5xgtY=;
        b=dUBC4eCfdlshZVZvO6sceLJfDOz+ajC78KiYEk0g/bH/9FA6M8/08dtKmdiap2MF//DWyO
        w44TZfifwY/dfOjjWpW+8+VH2W+SQNc8ht0p6dbIbUn0A7DGP+zHCl8lgzSz+lAvQMH2El
        sKGzK+9uiPvsJKQ3QmbrnrIRAYseD/E=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F238BACC6;
        Tue,  5 Jan 2021 14:04:57 +0000 (UTC)
Message-ID: <de23e12b8714cf97477ff149e6ebf323795f963d.camel@suse.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
From:   Oliver Neukum <oneukum@suse.com>
To:     Roland Dreier <roland@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Tue, 05 Jan 2021 15:04:54 +0100
In-Reply-To: <CAG4TOxM_Mq-Rcdi-pbY-KCMqqS5LmRD=PJszYkAjt7XGm8mc5Q@mail.gmail.com>
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com>
         <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
         <24c6faa2a4f91c721d9a7f14bb7b641b89ae987d.camel@neukum.org>
         <CAG4TOxOc2OJnzJg9mwd2h+k0mj250S6NdNQmhK7BbHhT4_KdVA@mail.gmail.com>
         <12f345107c0832a00c43767ac6bb3aeda4241d4e.camel@suse.com>
         <CAG4TOxOOPgAqUtX14V7k-qPCbOm7+5gaHOqBvgWBYQwJkO6v8g@mail.gmail.com>
         <cebe1c1bf2fcbb6c39fd297e4a4a0ca52642fe18.camel@suse.com>
         <CAG4TOxM_Mq-Rcdi-pbY-KCMqqS5LmRD=PJszYkAjt7XGm8mc5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 04.01.2021, 11:13 -0800 schrieb Roland Dreier:
> > > to preserve the legacy behavior rather than changing the behavior of
> > > every usbnet driver all at once?  Like make a new
> > > usbnet_get_link_ksettings_nonmdio and update only cdc_ncm to use it?
> > 
> > Then I would have to touch them all. The problem is that the MDIO
> > stuff really is pretty much a layering violation. It should never
> > have been default. But now it is.
> 
> I don't understand this.  Your 0001 patch changes the behavior of
> usbnet_get_link_ksettings() and you have to touch all of the 8 drivers
> that use it if you don't want to change their behavior.  If you keep
> the old usbnet_get_link_ksettings() and add
> usbnet_get_link_ksettings_nonmdio() then you can just update cdc_ncm
> to start with, and then gradually migrate other drivers.  And
> eventually fix the layering violation and get rid of the legacy
> function when the whole transition is done.

Hi,

now that you put it that way, I get the merit of what you are saying.
Very well. I will submit the first set of patches.

May I add your "Tested-by"?

	Regards
		Oliver


