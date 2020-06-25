Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99CB20A7B4
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406797AbgFYVqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:46:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404502AbgFYVql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 17:46:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joZhe-002GDB-V7; Thu, 25 Jun 2020 23:46:38 +0200
Date:   Thu, 25 Jun 2020 23:46:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v3 1/6] Add cable test support
Message-ID: <20200625214638.GC535869@lunn.ch>
References: <20200625192446.535754-1-andrew@lunn.ch>
 <20200625192446.535754-2-andrew@lunn.ch>
 <20200625211227.hvo3a5kbmsymzkz6@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625211227.hvo3a5kbmsymzkz6@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int nl_cable_test_ntf_attr(struct nlattr *evattr)
> > +{
> > +	unsigned int cm;
> > +	uint16_t code;
> > +	uint8_t pair;
> > +	int ret;
> > +
> > +	switch (mnl_attr_get_type(evattr)) {
> > +	case ETHTOOL_A_CABLE_NEST_RESULT:
> > +		ret = nl_get_cable_test_result(evattr, &pair, &code);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		printf("Pair: %s, result: %s\n", nl_pair2txt(pair),
> > +		       nl_code2txt(code));
> 
> AFAICS this will produce output like "Pair: Pair A, ..." which looks
> a bit strange, is it intended? (The same below).

Hi Michal

The later patch which adds JSON support changes this. The Pair: gets
removed. I thought it was odd as well. But it did not go back through
the patches and change where is was initially added.

    Andrew
