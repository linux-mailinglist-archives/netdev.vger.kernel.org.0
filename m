Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5942422ECC2
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgG0NEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:04:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:60194 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbgG0NEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 09:04:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DFDEAACA9;
        Mon, 27 Jul 2020 13:04:17 +0000 (UTC)
Message-ID: <1595855038.13408.27.camel@suse.de>
Subject: Re: [PATCH v5 net-next 2/5] net: cdc_ether: export
 usbnet_cdc_update_filter
From:   Oliver Neukum <oneukum@suse.de>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net,
        Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, gregkh@linuxfoundation.org
Date:   Mon, 27 Jul 2020 15:03:58 +0200
In-Reply-To: <2B227F47-F76D-45EF-85D6-8A5A85AE19A1@mork.no>
References: <20200715184100.109349-1-bjorn@mork.no>
         <20200715184100.109349-3-bjorn@mork.no> <1595322008.29149.5.camel@suse.de>
         <2B227F47-F76D-45EF-85D6-8A5A85AE19A1@mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 24.07.2020, 16:18 +0200 schrieb Bjørn Mork:
> 
> On July 21, 2020 11:00:08 AM GMT+02:00, Oliver Neukum <oneukum@suse.de> wrote:
> > Am Mittwoch, den 15.07.2020, 20:40 +0200 schrieb Bjørn Mork:
> > > 
> > > @@ -90,6 +90,7 @@ static void usbnet_cdc_update_filter(struct usbnet
> > 
> > *dev)
> > >  			USB_CTRL_SET_TIMEOUT
> > >  		);
> > >  }
> > > +EXPORT_SYMBOL_GPL(usbnet_cdc_update_filter);
> > 
> > Hi,
> > 
> > this function is pretty primitive. In fact it more or less
> > is a straight take from the spec. Can this justify the _GPL
> > version?
> 
> Maybe not? I must admit I didn't put much thought into it. 
> 
> I will not object to changing it. And you're the boss anyway :-)

Well,

it has been applied. I don't care enough to change it unless
we are violating a policy. I am looking for some ground rules
on that issue.

Leading us to the thorny issue of binary modules, yes I know.
Yet up to now it was my understanding that plain EXPORT_SYMBOL
is the default and EXPORT_SYMBOL_GPL needs a reason.
Now, I like the GPL as much as everybody else and I will
not challenge people on their reason if they state it
and I am willing to assume that there is a reason if the code
behind the symbol is substantial.
My job as maintainer is to check things and to ensure some
consistency. And I am seeing a certain lack of consistency here.
As I do not want to make developers unhappy I would very much
appreciate some guide lines I can point at.

I really want to preclude some lawyers sending me conflicting
patches in the future. I fear this coming.

	Regards
		Oliver

