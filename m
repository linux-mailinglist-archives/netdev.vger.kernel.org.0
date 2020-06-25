Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160A2209C81
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 12:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390789AbgFYKJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 06:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389646AbgFYKJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 06:09:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426EAC061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 03:09:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1joOog-0006FB-2A; Thu, 25 Jun 2020 12:09:10 +0200
Date:   Thu, 25 Jun 2020 12:09:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Florian Westphal <fw@strlen.de>, steffen.klassert@secunet.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH ipsec-next v2 2/6] xfrm: replay: get rid of duplicated
 notification code
Message-ID: <20200625100910.GY26990@breakpoint.cc>
References: <20200624080804.7480-1-fw@strlen.de>
 <20200624080804.7480-3-fw@strlen.de>
 <20200625070741.GA2939559@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625070741.GA2939559@bistromath.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sabrina Dubroca <sd@queasysnail.net> wrote:
> >  	case XFRM_REPLAY_MODE_BMP:
> >  		xfrm_replay_notify_bmp(x, event);
> > -		return;
> > +		goto notify;
> >  	case XFRM_REPLAY_MODE_ESN:
> >  		xfrm_replay_notify_esn(x, event);
> > -		return;
> > +		goto notify;
> 
> These two functions have some early returns that skip the
> notification, but now the notification will be sent in all cases:

Right, I will rework this series.

Thanks for pointing this out.
