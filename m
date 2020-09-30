Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A906827F26D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgI3TPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3TPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:15:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F24C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:15:39 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNhZf-00E0AC-9e; Wed, 30 Sep 2020 21:15:35 +0200
Message-ID: <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
Subject: Re: Genetlink per cmd policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Date:   Wed, 30 Sep 2020 21:15:33 +0200
In-Reply-To: <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
         <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
         <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
         <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
         <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 12:14 -0700, Jakub Kicinski wrote:

> > Hm. I guess you could even have both?
> > 
> > 	struct genl_ops *ops;
> > 	struct genl_ops_ext *extops;
> > 
> > and then search both arrays, no need for memcpy/pointer assignment?
> 
> Yup, both should work quite nicely, too. No reason to force one or the
> other.

Indeed.

> Extra n_ops_ext should be fine, I think I can make n_ops a u8 in 
> the first place, since commands themselves are u8s. And 0 is commonly
> unused.

True. I'm not really worried about the extra pointer in the *family*
though, there aren't really all that many families :)

johannes

