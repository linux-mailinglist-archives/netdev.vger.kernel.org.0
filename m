Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232AE453A2F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbhKPTdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:33:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhKPTdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 14:33:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CF336140D;
        Tue, 16 Nov 2021 19:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637091042;
        bh=+Ty9ThuacF/5qyYxqg9AiudbC/9ecfrcUqPzo23RDEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dec4gNcWXRpxxeGuPPN0Je6wnv+GK53gbhZfr3mpa5pvgY7OtTmkM/e3rLFoHcaYE
         mHYMqBiCMZCDd8e3yCFhvEWcSr9qmsqoxB9IZxePbaqNeZpv2hjpkF5+EVpItygWnR
         VzntnqfLoYVVxyBSQPjljmfirEMn3BkQZ8ApFVOI5nsoh6Pt7uorlg/KnBS/1DqjSP
         Ycm3kAvTPjbls6/UTrew9gktgVJ/yxy+G+YUUugRjuQtwD73Ptbo1AbDIqm7k6NfDE
         quIl5rZJhT8qz13itA1g7U04Nq0ylCDsGWXHmJdudp5dIgu3y7o+mFFy0gHe/PuiqB
         peIqT0CBDxizA==
Date:   Tue, 16 Nov 2021 11:30:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Message-ID: <20211116113041.17fd8ff2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211116154111.GF6326@breakpoint.cc>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
        <20211110114448.2792314-3-maciej.machnikowski@intel.com>
        <YY0+PmNU4MSGfgqA@hog>
        <20211111162252.GJ16363@breakpoint.cc>
        <MW5PR11MB58124A70268058505368A5C8EA999@MW5PR11MB5812.namprd11.prod.outlook.com>
        <20211116154111.GF6326@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 16:41:11 +0100 Florian Westphal wrote:
> > and the concept of that functionality
> > is - any packet network can implement it - SONET, GPON or even wireless.  
> 
> Ethtool ops expose a wide range of low-level functions not related to
> ethernet, e.g. eeprom dump, interrupt coalescing settings of and so on
> and so forth.
> 
> But hey, if net maintainers are ok with rtnetlink...

I agree, this has been brought up by 5 people or so already.
