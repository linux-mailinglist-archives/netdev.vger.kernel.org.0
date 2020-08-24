Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9769B250A2B
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHXUko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHXUko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:40:44 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51544205CB;
        Mon, 24 Aug 2020 20:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598301643;
        bh=VsjLaXv58uApo39XrXjCyhP6BZ6IBLyE8ahQ0IUsBm0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hjZs1DmXmfk8MzdH0EJ65hDd9XXpNrrx67bE9AJn0BG3+9g5E2XhYgaU/WcSCFQV9
         77z2GdKbiDpUY7yVoyZ4zfrnWw6c6pSgRTUvQtc5CvOUIz7TnL/feuTqp8xj20bcsZ
         8p7iXr3/Jqqq2M3TPI2ZT5P48YHR7Med+T38B4XY=
Date:   Mon, 24 Aug 2020 13:40:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Brady, Alan" <alan.brady@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [net-next v5 06/15] iecm: Implement mailbox functionality
Message-ID: <20200824134041.4249c0bd@kicinski-fedora-PC1C0HJN>
In-Reply-To: <MW3PR11MB4522AEB1B7D5001AA66D15158F560@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-7-anthony.l.nguyen@intel.com>
        <MW3PR11MB4522AEB1B7D5001AA66D15158F560@MW3PR11MB4522.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Aug 2020 20:35:51 +0000 Brady, Alan wrote:
> > @@ -28,7 +36,32 @@ static enum iecm_status iecm_ctlq_init_regs(struct
> > iecm_hw *hw,
> >  					    struct iecm_ctlq_info *cq,  
> 
> I believe we have made a grave error and sent the wrong version.
> iecm_status enum should be completely removed.  Sincere apologies for
> the thrash.  Will be sending another version up soon.

Ugh, I was half way through review.

Let me send my comments and you can see how many of them apply.
