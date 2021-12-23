Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CBF47E737
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbhLWRpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 12:45:36 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:36181 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhLWRpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 12:45:36 -0500
Received: (Authenticated sender: repk@triplefau.lt)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 740DE24000D;
        Thu, 23 Dec 2021 17:45:33 +0000 (UTC)
Date:   Thu, 23 Dec 2021 18:50:30 +0100
From:   Remi Pommarel <repk@triplefau.lt>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl
 working in compat mode
Message-ID: <YcS25oqoo+xnAIIW@pilgrim>
References: <20211223153139.7661-1-repk@triplefau.lt>
 <20211223153139.7661-3-repk@triplefau.lt>
 <20211223085944.55b43857@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223085944.55b43857@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 08:59:44AM -0800, Jakub Kicinski wrote:
> On Thu, 23 Dec 2021 16:31:39 +0100 Remi Pommarel wrote:
> > In compat mode SIOC{G,S}IFBR ioctls were only supporting
> > BRCTL_GET_VERSION returning an artificially version to spur userland
> > tool to use SIOCDEVPRIVATE instead. But some userland tools ignore that
> > and use SIOC{G,S}IFBR unconditionally as seen with busybox's brctl.
> > 
> > Example of non working 32-bit brctl with CONFIG_COMPAT=y:
> > $ brctl show
> > brctl: SIOCGIFBR: Invalid argument
> > 
> > Example of fixed 32-bit brctl with CONFIG_COMPAT=y:
> > $ brctl show
> > bridge name     bridge id               STP enabled     interfaces
> > br0
> > 
> > Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> > Co-developed-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Since Arnd said this is not supposed to be backported I presume it
> should go to net-next?

Yes, out of curiosity, is it appropriate to mix "[PATCH net]" and
"[PATCH net-next]" in the same serie ?

Thanks

-- 
Remi
