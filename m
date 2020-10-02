Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14CA28169F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbgJBPaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387984AbgJBPaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:30:30 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182CCC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 08:30:30 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kON0u-00FJOD-C3; Fri, 02 Oct 2020 17:30:28 +0200
Message-ID: <a290d0b3c02065b019073840a4f3369e3acc1f2e.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: fix policy dump leak
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Fri, 02 Oct 2020 17:30:27 +0200
In-Reply-To: <20201002082910.6951a5db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid>
         <20201002082910.6951a5db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 08:29 -0700, Jakub Kicinski wrote:
> On Fri,  2 Oct 2020 09:46:04 +0200 Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > If userspace doesn't complete the policy dump, we leak the
> > allocated state. Fix this.
> > 
> > Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks.

> FWIW make sure to mark the patches with net and net-next in the tag. 
> The more automation we have, the more it matters.

Yeah, sorry. It occurred to me like 10 seconds after sending the patch,
and then of course I forgot _again_ when I sent the others ... I'm not
doing that (yet) on my trees, so not quite natural yet.

johannes

