Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AA714C957
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 12:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgA2LND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 06:13:03 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:58825 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgA2LNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 06:13:02 -0500
X-Originating-IP: 90.76.211.102
Received: from localhost (lfbn-tou-1-1151-102.w90-76.abo.wanadoo.fr [90.76.211.102])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 9A4EE1BF215;
        Wed, 29 Jan 2020 11:13:00 +0000 (UTC)
Date:   Wed, 29 Jan 2020 12:12:59 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, sd@queasysnail.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/2] macsec: report the offloading mode
 currently selected
Message-ID: <20200129111259.GA3102@kwain>
References: <20200120201823.887937-1-antoine.tenart@bootlin.com>
 <20200120201823.887937-2-antoine.tenart@bootlin.com>
 <69ba6f7f-9f52-a7fb-7608-955cdb200dd1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69ba6f7f-9f52-a7fb-7608-955cdb200dd1@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On Mon, Jan 27, 2020 at 09:41:21AM -0700, David Ahern wrote:
> On 1/20/20 1:18 PM, Antoine Tenart wrote:
> > @@ -997,6 +1002,19 @@ static int process(struct nlmsghdr *n, void *arg)
> >  	if (attrs[MACSEC_ATTR_RXSC_LIST])
> >  		print_rxsc_list(attrs[MACSEC_ATTR_RXSC_LIST]);
> >  
> > +	if (attrs[MACSEC_ATTR_OFFLOAD]) {
> > +		struct rtattr *attrs_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
> > +		__u8 offload;
> > +
> > +		parse_rtattr_nested(attrs_offload, MACSEC_OFFLOAD_ATTR_MAX,
> > +				    attrs[MACSEC_ATTR_OFFLOAD]);
> > +
> > +		offload = rta_getattr_u8(attrs_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
> > +		print_string(PRINT_ANY, "offload",
> > +			     "    offload: %s ", offload_str[offload]);
> 
> you should be an accessor around offload_str[offload] to handle a future
> change adding a new type.

Good idea, I'll do that.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
