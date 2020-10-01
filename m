Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D0C280340
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbgJAPwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732331AbgJAPwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:52:35 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C995C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 08:52:35 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kO0se-00Eg3Q-NK; Thu, 01 Oct 2020 17:52:28 +0200
Message-ID: <26debba9a99f1a3e800e7c528cef491e31227233.camel@sipsolutions.net>
Subject: Re: Genetlink per cmd policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Date:   Thu, 01 Oct 2020 17:52:27 +0200
In-Reply-To: <20201001085047.3a1c55e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
         <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
         <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
         <20200930124612.32b53118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <48868126b563b1602093f6210ed957d7ed880584.camel@sipsolutions.net>
         <20200930134734.27bba000@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20200930233817.GA3996795@lunn.ch>
         <20200930172317.48f85a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201001015323.GB4050473@lunn.ch>
         <20201001085047.3a1c55e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 08:50 -0700, Jakub Kicinski wrote:

> > > > > > > +	memcpy(op, &family->ops[i], sizeof(*op));      
> > > > > > 
> > > > > > What's wrong with struct assignment? :)

> FWIW the 400 was without the -Os with -Os it's more like 50. So I'll
> just go for it and do the struct assignment.

FWIW, I really don't think it actually _matters_. I just started using
struct assignments more since they're type safe and you don't trip up
any of the static checkers :-) More in non-kernel projects than the
kernel though, to be honest.

johannes

