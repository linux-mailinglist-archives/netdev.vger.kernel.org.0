Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD582F6D27
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbhANVYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbhANVYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:24:00 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED675C061757;
        Thu, 14 Jan 2021 13:23:19 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l0A57-006O3k-Sa; Thu, 14 Jan 2021 22:23:01 +0100
Message-ID: <8b6f763d3eba85f664fd05d7a3c7c311c0648da2.camel@sipsolutions.net>
Subject: Re: [PATCH v6 12/16] net: tip: fix a couple kernel-doc markups
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Jon Maloy <jmaloy@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ying Xue <ying.xue@windriver.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Date:   Thu, 14 Jan 2021 22:22:58 +0100
In-Reply-To: <20210114103402.31946ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1610610937.git.mchehab+huawei@kernel.org>
         <9d205b0e080153af0fbddee06ad0eb23457e1b1b.1610610937.git.mchehab+huawei@kernel.org>
         <da52ef69-753a-7aa8-a2b1-1b5ef48df94e@redhat.com>
         <20210114103402.31946ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-14 at 10:34 -0800, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 10:59:08 -0500 Jon Maloy wrote:
> > On 1/14/21 3:04 AM, Mauro Carvalho Chehab wrote:
> > > A function has a different name between their prototype
> > > and its kernel-doc markup:
> > > 
> > > 	../net/tipc/link.c:2551: warning: expecting prototype for link_reset_stats(). Prototype was for tipc_link_reset_stats() instead
> > > 	../net/tipc/node.c:1678: warning: expecting prototype for is the general link level function for message sending(). Prototype was for tipc_node_xmit() instead
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > 
> > Acked-by: Jon Maloy <jmaloy@redhat.com>
> 
> Thanks! Applied this one to net, the cfg80211 one does not apply to
> net, so I'll leave it to Johannes.

Right, that was diffed against -next, and I've got a fix pending that I
didn't send yet.

I've applied this now, thanks.

johannes

