Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7B2213E8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGOSDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgGOSDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 14:03:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00B120656;
        Wed, 15 Jul 2020 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594836213;
        bh=CCKI/cSODa+1OuuLzye9p6FdI01SrPBIRU3pEyWA0Ik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hhG84f05rx5OYf424oZkWZc+naGKxdtj/N2B0GhZcSMyp86PYltPPo+E/tUA4gNsB
         UIPU1PSo3XYzLtaOSS/AY5Jmqa3s7p0+8mGt4i40NQ5Q5ZZp/WKjGsHyDc1Ln6kaNb
         +RQbI160Yoy9DIWe4o9hTxMIdzGFh+WVRPBQMdIU=
Date:   Wed, 15 Jul 2020 11:03:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wang, Haiyue" <haiyue.wang@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Message-ID: <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 01:17:26 +0000 Wang, Haiyue wrote:
> > Could you say a little more about the application and motivation for
> > this?
> 
> Sure, I will try to describe the whole story.
> 
> > We are talking about a single control domain here, correct?  
> 
> Correct.

We have a long standing policy of not supporting or helping bifurcated
drivers.

I'm tossing this from patchwork.
