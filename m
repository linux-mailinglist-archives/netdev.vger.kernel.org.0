Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8CC30FD68
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbhBDTzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:55:07 -0500
Received: from mga04.intel.com ([192.55.52.120]:64649 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239524AbhBDTxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 14:53:03 -0500
IronPort-SDR: xhiiU7J+LIIjyYXnAcV9002zpXaQ0xrGz7DoMSL1awV70dg5EVcC2OCzDhkj/ZjPgymdqnoAG4
 KI1OTR5oLJ+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="178755296"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="178755296"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:52:21 -0800
IronPort-SDR: lk2OeIHmNPWbmvRojJjqR8Xtfh20RG7xmOB4Z1oM64zOBayunz7AhdCrNPMsooc6EW9bI/cxGe
 DT69vT3vA40Q==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="434088875"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.188.246])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:52:20 -0800
Date:   Thu, 4 Feb 2021 11:52:20 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RESEND v3 net-next 4/5] net: use the new
 dev_page_is_reusable() instead of private versions
Message-ID: <20210204115220.0000018d@intel.com>
In-Reply-To: <20210202133030.5760-5-alobakin@pm.me>
References: <20210202133030.5760-1-alobakin@pm.me>
        <20210202133030.5760-5-alobakin@pm.me>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin wrote:

> Now we can remove a bunch of identical functions from the drivers and
> make them use common dev_page_is_reusable(). All {,un}likely() checks
> are omitted since it's already present in this helper.
> Also update some comments near the call sites.
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

I don't know why it was missed in the series update, but:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
