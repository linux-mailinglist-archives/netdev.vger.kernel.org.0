Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE60281CB6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJBUNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBUNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:13:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DD9C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:13:39 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kORQv-00FRVY-UZ; Fri, 02 Oct 2020 22:13:38 +0200
Message-ID: <580e017d3acc8dda58507f8c4d5bbe639a8cecb7.camel@sipsolutions.net>
Subject: Re: [PATCH 3/5] netlink: rework policy dump to support multiple
 policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Fri, 02 Oct 2020 22:13:36 +0200
In-Reply-To: <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
         <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
         <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oh, and ...

> > +/**
> > + * netlink_policy_dump_add_policy - add a policy to the dump
> > + * @pstate: state to add to, may be reallocated, must be %NULL the first time
> > + * @policy: the new policy to add to the dump
> > + * @maxtype: the new policy's max attr type
> > + *
> > + * Returns: 0 on success, a negative error code otherwise.
> > + *
> > + * Call this to allocate a policy dump state, and to add policies to it. This
> > + * should be called from the dump start() callback.
> > + *
> > + * Note: on failures, any previously allocated state is freed.
> > + */
> > +int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
> > +				   const struct nla_policy *policy,
> > +				   unsigned int maxtype);
> 
> Personal preference perhaps, but I prefer kdoc with the definition.

I realized recently that this is actually better, because then "make
W=1" will in fact check the kernel-doc for consistency ... but it
doesn't do it in header files.

Just have to get into the habit now ...

johannes

