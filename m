Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD2922124C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgGOQ2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOQ2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 12:28:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7AB2065E;
        Wed, 15 Jul 2020 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594830481;
        bh=XvCTrVWIBy+oK4cNjhoZfjf7CbCz0HoTZM5KptHveMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q5D5aSNOio+x8pmCwUa1nwM9J4oVlPC8mGUwoXS3NAdUKxEmpG64b1Q20afLh5yPU
         5mjnVzL+2Y2yuAkalvbR+yMkMz3epCdwO0FZqQHwHp4OEn3QGWmY4vfHIuN2rCES5M
         8mrgSFd8Ui2Rl+moNeLtrYPc1yTk0Hs5+fm8bg6M=
Date:   Wed, 15 Jul 2020 09:27:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH 01/13 net-next] net: nl80211.h: drop duplicate words in
 comments
Message-ID: <20200715092759.590b9143@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <359af6cb-a242-c003-83e1-cca6dd75336f@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
        <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6653f2f65ec4a9cc1024b69ffe97d5dc4c7ff33a.camel@perches.com>
        <359af6cb-a242-c003-83e1-cca6dd75336f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 09:18:40 -0700 Randy Dunlap wrote:
> On 7/15/20 9:12 AM, Joe Perches wrote:
> > On Wed, 2020-07-15 at 08:48 -0700, Jakub Kicinski wrote:  
> >> On Tue, 14 Jul 2020 19:59:02 -0700 Randy Dunlap wrote:  
> >>> Drop doubled words in several comments.
> >>>
> >>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >>> Cc: "David S. Miller" <davem@davemloft.net>
> >>> Cc: Jakub Kicinski <kuba@kernel.org>
> >>> Cc: netdev@vger.kernel.org  
> >>
> >> Hi Randy, the WiFi stuff goes through Johannes's mac80211 tree.
> >>
> >> Would you mind splitting those 5 patches out to a separate series and
> >> sending to him?  
> > 
> > Do I understand you to want separate patches
> > for separate sections of individual files?
> > 
> > I think that's a bit much...  
> 
> I plan to move wireless.h, regulatory.h, nl80211.h,
> mac80211.h, and cfg80211.h patches to a wireless patch series.
> 
> wimax can stay in net?? (I hope.)

Yup! Sounds right, wimax can go to net-next. Thanks for doing this.
