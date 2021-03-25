Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC6B348961
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCYGvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:51:44 -0400
Received: from verein.lst.de ([213.95.11.211]:39733 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYGvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 02:51:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7517468B05; Thu, 25 Mar 2021 07:51:15 +0100 (CET)
Date:   Thu, 25 Mar 2021 07:51:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Auger Eric <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Li Yang <leoyang.li@nxp.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "freedreno@lists.freedesktop.org" <freedreno@lists.freedesktop.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 15/17] iommu: remove DOMAIN_ATTR_NESTING
Message-ID: <20210325065115.GB25678@lst.de>
References: <20210301084257.945454-1-hch@lst.de> <20210301084257.945454-16-hch@lst.de> <3e8f1078-9222-0017-3fa8-4d884dbc848e@redhat.com> <20210314155813.GA788@lst.de> <3a1194de-a053-84dd-3d6a-bff8e01ebcd3@redhat.com> <MWHPR11MB188688125518D050E384658F8C629@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188688125518D050E384658F8C629@MWHPR11MB1886.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 06:12:37AM +0000, Tian, Kevin wrote:
> Agree. The vSVA series is still undergoing a refactor according to Jason's
> comment thus won't be ready in short term. It's better to let this one
> go in first.

Would be great to get a few more reviews while we're at it :)
