Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FEE1F6F95
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgFKVtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 17:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgFKVtE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 17:49:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4751420760;
        Thu, 11 Jun 2020 21:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591912144;
        bh=kG9tJvQSXQuwDEKvpJKWIByUTyvPzHfBKCwYfJp9Z/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6PBGVh4qrxhz8+j4g5EwKhjPg24DwXRZv8ElOCXrDbUrhTSiluVgvBCB/16+KnKF
         qQ/hNesvQzdOOl21yfhtRmHOzODjP5JWT+aBmWildpESnGTQnR568I6OA0LWoRb+/V
         LVmmDoACpFo+yeU4/YyUUbX1bYTMiOwxxB5kN3LQ=
Date:   Thu, 11 Jun 2020 14:49:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "klassert@kernel.org" <klassert@kernel.org>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "luobin9@huawei.com" <luobin9@huawei.com>,
        "csully@google.com" <csully@google.com>,
        "kou.ishizaki@toshiba.co.jp" <kou.ishizaki@toshiba.co.jp>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "chessman@tux.org" <chessman@tux.org>
Subject: Re: [RFC 1/8] docs: networking: reorganize driver documentation
 again
Message-ID: <20200611144901.42120dfc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044986F4FAE@ORSMSX112.amr.corp.intel.com>
References: <20200611173010.474475-1-kuba@kernel.org>
        <20200611173010.474475-2-kuba@kernel.org>
        <61CC2BC414934749BD9F5BF3D5D94044986F4FAE@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 21:17:49 +0000 Kirsher, Jeffrey T wrote:
> > @@ -8626,18 +8626,18 @@ W:	http://e1000.sourceforge.net/
> >  Q:	http://patchwork.ozlabs.org/project/intel-wired-lan/list/
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue.git
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue.git
> > -F:	Documentation/networking/device_drivers/intel/e100.rst
> > -F:	Documentation/networking/device_drivers/intel/e1000.rst
> > -F:	Documentation/networking/device_drivers/intel/e1000e.rst
> > -F:	Documentation/networking/device_drivers/intel/fm10k.rst
> > -F:	Documentation/networking/device_drivers/intel/i40e.rst
> > -F:	Documentation/networking/device_drivers/intel/iavf.rst
> > -F:	Documentation/networking/device_drivers/intel/ice.rst
> > -F:	Documentation/networking/device_drivers/intel/igb.rst
> > -F:	Documentation/networking/device_drivers/intel/igbvf.rst
> > -F:	Documentation/networking/device_drivers/intel/ixgb.rst
> > -F:	Documentation/networking/device_drivers/intel/ixgbe.rst
> > -F:	Documentation/networking/device_drivers/intel/ixgbevf.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/e100.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/e1000.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/i40e.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/iavf.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/ice.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/igb.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
> > +F:	Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst  
> [Kirsher, Jeffrey T] 
> 
> With this patch, the above MAINTAIERS entries can be reduced to a single line.  This can now become:
> 
> F: Documentation/networking/device_drivers/ethernet/intel/*
> 
> No need to list out all the documented files now that I support/maintain all documentation in the above folder.

Ah, good point, the Wi-Fi is no longer there!
