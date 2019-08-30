Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BDAA2BFC
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfH3A4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:56:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:32915 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfH3A4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 20:56:30 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:56:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="332700916"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.13.128])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2019 17:56:27 -0700
Date:   Fri, 30 Aug 2019 09:00:51 +0800
From:   Philip Li <philip.li@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     lkp@intel.com, wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cheng.lin130@zte.com.cn,
        kbuild-all@01.org, xue.zhihong@zte.com.cn, kuznet@ms2.inr.ac.ru
Subject: Re: [kbuild-all] [PATCH] ipv6: Not to probe neighbourless routes
Message-ID: <20190830010051.GB857@intel.com>
References: <1566896907-5121-1-git-send-email-wang.yi59@zte.com.cn>
 <201908300657.DY647BSw%lkp@intel.com>
 <20190829.163742.2109211377942652910.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829.163742.2109211377942652910.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 04:37:42PM -0700, David Miller wrote:
> 
> So yeah, this is one instance where the kbuild test robot's report is
> making more rather than less work for us.
sorry for the inconvenience caused. We monitor the lkml, and as you
point out, we will continuously improve to provide faster response.

> 
> We identified the build problem within hours of this patch being
> posted and the updated version was posted more than 24 hours ago.
> 
> The kbuild robot should really have a way to either:
> 
> 1) Report build problems faster, humans find the obvious cases like
>    this one within a day or less.
thanks, we will continue working on this to speed up

> 
> 2) Notice that a new version of the patch was posted or that a human
>    responded to the patch pointing out the build problem.
thanks, we will enhance the patch testing to consider these ideas.

> 
> Otherwise we get postings like this which is just more noise to
> delete.
> 
> Thanks.
> _______________________________________________
> kbuild-all mailing list
> kbuild-all@lists.01.org
> https://lists.01.org/mailman/listinfo/kbuild-all
