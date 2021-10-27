Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DC443CC7B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbhJ0Omv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236488AbhJ0Omu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFE9760720;
        Wed, 27 Oct 2021 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635345625;
        bh=NOqWKfn6Yz4kBIFHpmZu4vO/wZyXegOGpxv8kVU+EH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FvWE+yz4d/I5eCSy9m0flmjwqqt7FYfH9yzkx/7HqfQSHToiyg6H0v6c+VVccUCoP
         wd+qEL3kIj86bDjasBojn+b2Jvnvsqtzy3fwUY/AsdaI07CCGD6lz22Tf4HoO3Y6jO
         cw8RYwZmN7ZKVfcvX0iq1nOz6/Q3ZsI4piFRkonPalJ5pC55E8E4vsA3zR9VZztaIL
         kR72HlZhQxgbrWPbksxbp1ztRLOCh2qvrs8WHgEhJ3bPuQKEfgt+UteFBfxmF7W+2J
         diQpFr48CCXuFmx6jrq1lIzwqeH1MUF0IEWZk2Nt9FVAFHdiSn1UQgYiLq/o+yTxXN
         UY+utz71Fh83A==
Date:   Wed, 27 Oct 2021 07:40:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [RFC v5 net-next 4/5] rtnetlink: Add support for SyncE
 recovered clock configuration
Message-ID: <20211027074023.2589af7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <PH0PR11MB495117F04EED3A5D56AFB527EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
        <20211026173146.1031412-5-maciej.machnikowski@intel.com>
        <20211026143236.050af4e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495117F04EED3A5D56AFB527EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 13:29:40 +0000 Machnikowski, Maciej wrote:
> > Please add a write up of how things fit together in Documentation/.
> > I'm sure reviewers and future users will appreciate that.  
>  
> Sure! Documentation/networking/synce.rst would be the right place to add it?
> Or is there any better place?

SGTM
