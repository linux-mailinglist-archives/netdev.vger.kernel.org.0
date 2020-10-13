Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DE628D57A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 22:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgJMUlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 16:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJMUlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 16:41:09 -0400
Received: from coco.lan (ip5f5ad5b2.dynamic.kabel-deutschland.de [95.90.213.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1320520878;
        Tue, 13 Oct 2020 20:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602621669;
        bh=KF0q+uupmDV1pOAyg9WYj6hVV6CX1TMrjKTkOPB24yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kVCJ0MMa7YrUSlZvqdvOd3h65STWdVIDu5uRnJoFnXPFMclK3wtnTid6cB4Z1W4zh
         +Oee99PbVb8n0oEoUFufTP4cDkZTWTjgtwMYuc4ohHmh6jvZ0M12V2QyAZth0wPtqJ
         1I1IIfucq+4aqSqcUM+qA3I9UjRxwKjX53fTKH7U=
Date:   Tue, 13 Oct 2020 22:41:03 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Pedersen <thomas@adapt-ip.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 68/80] nl80211: docs: add a description for s1g_cap
 parameter
Message-ID: <20201013224103.7f958544@coco.lan>
In-Reply-To: <5ad3c2c6cd096b6fb5c9bedd340b927adb899213.camel@sipsolutions.net>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
        <9633ea7d9b0cb2f997d784df86ba92e67659f29b.1602589096.git.mchehab+huawei@kernel.org>
        <5ad3c2c6cd096b6fb5c9bedd340b927adb899213.camel@sipsolutions.net>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 13 Oct 2020 20:47:47 +0200
Johannes Berg <johannes@sipsolutions.net> escreveu:

> Thanks Mauro.
> 
> 
> On Tue, 2020-10-13 at 13:54 +0200, Mauro Carvalho Chehab wrote:
> > Changeset df78a0c0b67d ("nl80211: S1G band and channel definitions")
> > added a new parameter, but didn't add the corresponding kernel-doc
> > markup, as repoted when doing "make htmldocs":
> > 
> > 	./include/net/cfg80211.h:471: warning: Function parameter or member 's1g_cap' not described in 'ieee80211_supported_band'
> > 
> > Add a documentation for it.  
> 
> Should I take this through my tree, or is that part of a larger set
> that'll go somewhere else?

Whatever works best for you ;-)

If you don't pick it via your tree, I'm planning to send it
together with the other patches likely on Thursday.


Thanks,
Mauro
