Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214ED40D132
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 03:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhIPB3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 21:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233426AbhIPB3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 21:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8EE461186;
        Thu, 16 Sep 2021 01:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631755712;
        bh=EqafTgNEL5sr2TwGdaf9SrOSTajixtZ6ERfs+mFkGao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EJMD5hoLbYJV/S83UBoPn+azS7NKik7agt+TYMoM2T5mWAv5TjsWnQMyPLNK5Fk/z
         LfaWla5ibS4kiFvPXvhRvn8JpGYEfyrIb0Ui3OGGVmcdPL9SqcsoayE1BGywCu9GY6
         JkwIrZ4/t1S4lPfMiF/W0YGfqQ5sCJwJbmGiw676Xdlva60Q/DrW1QBLRMsOX75x2k
         U3xseuYturtg1mcuOcY3ltvs+lIZ24F8eCFaqYG/xZtNhn2aDbAl+B/uleca9VdNKT
         rh4LcRTxxgCpvLgUMbldX0SGshS10RMN+DRwrHB+uGFoAbPKYQdEDTI9bM9sNjzEWl
         Ebg6IHHErnu4Q==
Date:   Wed, 15 Sep 2021 18:28:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next] Revert "net: wwan: iosm: firmware flashing and
 coredump collection"
Message-ID: <20210915182830.554461ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR11MB50088886CB7E54A9A9E719C7D7DB9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20210915215823.11584-1-kuba@kernel.org>
        <SJ0PR11MB50088886CB7E54A9A9E719C7D7DB9@SJ0PR11MB5008.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Sep 2021 23:17:09 +0000 Kumar, M Chetan wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Thursday, September 16, 2021 3:28 AM
> > To: davem@davemloft.net
> > Cc: netdev@vger.kernel.org; loic.poulain@linaro.org; ryazanov.s.a@gmail.com;
> > Kumar, M Chetan <m.chetan.kumar@intel.com>; Jakub Kicinski
> > <kuba@kernel.org>
> > Subject: [PATCH net-next] Revert "net: wwan: iosm: firmware flashing and
> > coredump collection"
> > 
> > The devlink parameters are not the right mechanism to pass
> > extra parameters to device flashing. The params added are
> > also undocumented.  
> 
> Could you please suggest us how should we pass extra parameters ?

Once you document them, we'll know what they are, why they are needed
etc.

> Also I was about to submit the patch for documentation!!

2 days later. I'd much rather have the code reverted and then 
it's on you to fix it, not on me to chase you.
