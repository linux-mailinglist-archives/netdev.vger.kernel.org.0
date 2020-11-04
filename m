Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084432A66F9
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgKDPAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:00:44 -0500
Received: from mga18.intel.com ([134.134.136.126]:53568 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgKDPAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:00:43 -0500
IronPort-SDR: 1LZgxxVIFn7y86NTfOnmfAXzi4emzNJwc5Esyubs098QdNOcpBy34eLYjAFUKGXHR4erSvh/Nx
 BQ6Rzj+/rQYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="157001165"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="157001165"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 07:00:22 -0800
IronPort-SDR: bFDFZC4z0VPm9yhcNjj/tvhdZwZeSRDAi0X6ghMbKaO1q7SFNKqhaYMcwGPhrejDVtU1LaBdyg
 aBBoOP0v/VoA==
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="353854707"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 07:00:19 -0800
Received: by lahna (sSMTP sendmail emulation); Wed, 04 Nov 2020 16:58:07 +0200
Date:   Wed, 4 Nov 2020 16:58:07 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 06/10] thunderbolt: Create debugfs directory
 automatically for services
Message-ID: <20201104145807.GP2495@lahna.fi.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
 <20201104140030.6853-7-mika.westerberg@linux.intel.com>
 <20201104142038.GA2201525@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104142038.GA2201525@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 03:20:38PM +0100, Greg KH wrote:
> > +/**
> > + * tb_service_debugfs_remove() - Remove service debugfs directory
> > + * @svc: Thunderbolt service pointer
> > + *
> > + * Removes the previously created debugfs directory for @svc.
> > + */
> > +void tb_service_debugfs_remove(struct tb_service *svc)
> > +{
> > +	debugfs_remove(svc->debugfs_dir);
> 
> debugfs_remove_recursive() just to be safe that you really did clean
> everything up?  As you aren't "owning" this directory here, you don't
> know what will get added by some other patch :)

Good point. I'll change it to debugfs_remove_recursive().

> Other than that tiny nit, this series looks good to me, nice work.

Thanks!
