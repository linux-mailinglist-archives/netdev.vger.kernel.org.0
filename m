Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905E1290F98
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436699AbgJQFry convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 17 Oct 2020 01:47:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:18877 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436487AbgJQFry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 01:47:54 -0400
IronPort-SDR: ezfPq2NVEQtG34h4lvN7NdsEwplNtqdtUN5YFayp42ApqDPtN8a4Z4oqqwKPdqdsMkK8WU4din
 sOtA8IOJ4MMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="230907706"
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="230907706"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 17:44:32 -0700
IronPort-SDR: E8C4rzlUrHyV6mrpiCN1JXjFw9DZVJo8QeuTPvdZGuMq881aEJNOWVTurKLaJksMrtIVOG58uz
 uKguTcMpvCDg==
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="331326685"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 17:44:32 -0700
Date:   Fri, 16 Oct 2020 17:44:31 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     zhudi <zhudi21@huawei.com>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, rose.chen@huawei.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201016174431.00003979@intel.com>
In-Reply-To: <20201016224502.wztzj45gxepygzqd@skbuf>
References: <20201016020238.22445-1-zhudi21@huawei.com>
        <20201016143625.00005f4e@intel.com>
        <20201016224502.wztzj45gxepygzqd@skbuf>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean wrote:

> On Fri, Oct 16, 2020 at 02:36:25PM -0700, Jesse Brandeburg wrote:
> > > Signed-off-by: zhudi <zhudi21@huawei.com>
> > 
> > Kernel documentation says for you to use your real name, please do so,
> > unless you're a rock star and have officially changed your name to
> > zhudi.

I apologize for seeming off-putting, my goal was to add a little levity
here, but I know that email does a bad job of transmitting my intent,
and I will do better.

> 
> Well, his real name is probably 朱棣, and the pinyin transliteration
> system doesn't really insist on separating 朱 (zhu) from 棣 (di), or on
> capitalizing any of twose words, so I'm not sure what your point is.
> Would you prefer his sign-off to read 朱棣 <zhudi21@huawei.com>?

Ah, thanks Vladimir for explaining the difference. If this is common
parlance for commit messages from our Chinese developers, please forgive
me, I'm trying to balance obvious correctness against typical usage.

I'll adjust my expectations for single word names, thanks!

Jesse
