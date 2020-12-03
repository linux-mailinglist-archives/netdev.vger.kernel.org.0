Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F30F2CD9D5
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbgLCPHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbgLCPHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:07:15 -0500
Date:   Thu, 3 Dec 2020 16:07:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607007995;
        bh=va1RiIcGrtGAwqbASYW0M6+mbOZHmFTt3mNNh9Ch5iQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=QdVrPJNwIfDHYEwriD9hcsbD4TLQXPHf6uVHdig0bwu1AfgCqBZ6I7ABUVUSQ9x5D
         GjYr/rdjl0XI9Q7aiTiXSNQPGEJ5fcBgDAReWYV5p4YOWKpDs85c5WPCg1LWMblHp8
         pAnYnBY8MS4kKW9YncbPVUrsDJ3sme6Ura+E6jTU=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <X8j/PgVDii3Jthzx@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> PS: Greg I know I promised some review on newcomer patches to help with
> your queue, unfortunately Intel-internal review is keeping my plate
> full. Again, I do not want other stakeholder to be waiting on me to
> resolve that backlog.

Ah, but it's not only you that should be helping out here.  Why isn't
anyone else who is wanting this patch merged willing to also help out
with patch review and bug fixes that have higher priority than adding
new features like this one?

It's not your fault by any means, but the lack of anyone else willing to
do this is quite sad :(

greg k-h
