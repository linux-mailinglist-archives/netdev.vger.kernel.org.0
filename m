Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8F41C1FAE
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgEAVcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgEAVcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 17:32:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35651208DB;
        Fri,  1 May 2020 21:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588368773;
        bh=Q1+yeY8fsi0ubhneVlWtQ/e/N2b8RT6+YV1BmNhagSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q07wCF67ESSd6X+RWcXaQasslVgnG++du/kLhoZVxF2CPpvbhjfVetYwlrbHUh5nh
         QGirjWHHyB+PZTHLGkN9S7NgG0s+xsJyz+HMUAGaj3GlSXn8nqtq3Q08Heh5B4hdW9
         sWrO15Q5tJMilqP/bnPkPc6QicsnycY7f6IdYxr4=
Date:   Fri, 1 May 2020 14:32:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH net-next v2] devlink: let kernel allocate region
 snapshot id
Message-ID: <20200501143251.1f7026ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02874ECE860811409154E81DA85FBB58C0771750@ORSMSX151.amr.corp.intel.com>
References: <20200429233813.1137428-1-kuba@kernel.org>
        <20200430045315.GF6581@nanopsycho.orion>
        <02874ECE860811409154E81DA85FBB58C0771750@ORSMSX151.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 May 2020 21:23:25 +0000 Keller, Jacob E wrote:
> > Could you please send the snapshot id just before you return 0 in this
> > function, as you offered in v1? I think it would be great to do it like
> > that.
> > 
> 
> Also: Does it make sense to send the snapshot id regardless of
> whether it was auto-generated or not?

I may be wrong, but I think sending extra messages via netlink,
which user space may not expect based on previous kernel versions 
is considered uAPI breakage.
