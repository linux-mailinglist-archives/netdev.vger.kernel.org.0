Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F0067B170
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 12:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbjAYLer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 06:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbjAYLeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 06:34:25 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEFE29E38;
        Wed, 25 Jan 2023 03:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674646462; x=1706182462;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=08uSAz9IGIV2NFGRJPWT7DES35ILstPMqGOpt+Go8nU=;
  b=dlq4HGrcBbkSon/uX9m7cEGOgogs42bdLj7FonhaRvU48Rx9WIOHkA83
   nmW4CEM49kXRJp9q4KkS5BmDbBemVobz+xTLv73PwgZojwGcJZEL45Yj/
   nPlkxYpIRTjfMfB9mHiDJgoBnLtgo9SJHaBYyNWFHnaS/jYvvoUXoAyLz
   0jCoTU85DGHyNNRTCXT+yWWp/VA2Em2b9pUYSJt44i2PpDd9w+8/IiSHS
   +dmzcGl76SBLtHz9gIVDNklliZarj9tieJTZauVP18xfn+vyN3H5qsUmu
   /6b2AhJhFqVoCMRPNopLB581N37KRrduCbRML8F5Uab20rLfMY0lxYYDE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="325207935"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="325207935"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 03:34:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="694711234"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="694711234"
Received: from rbgutie-mobl1.amr.corp.intel.com ([10.251.210.131])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 03:34:08 -0800
Date:   Wed, 25 Jan 2023 13:34:07 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 5/5] net: wwan: t7xx: Devlink documentation
In-Reply-To: <c9f0eca7-99e8-62a5-9790-1230c43e1817@linux.intel.com>
Message-ID: <9b6f9537-59eb-3ec-2895-e43f55771f7@linux.intel.com>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com> <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com> <20230124205142.772ac24c@kernel.org> <c9f0eca7-99e8-62a5-9790-1230c43e1817@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023, Kumar, M Chetan wrote:

> On 1/25/2023 10:21 AM, Jakub Kicinski wrote:
> > On Sat, 21 Jan 2023 19:03:58 +0530 m.chetan.kumar@linux.intel.com wrote:
> > > +In fastboot mode the userspace application uses these commands for
> > > obtaining the
> > > +current snapshot of second stage bootloader.
> > 
> > I don't know what fastboot is, and reading this doc I see it used in
> > three forms:
> >   - fastboot protocol
> >   - fastboot mode
> >   - fastboot command & response
> 
> The fastboot is sort of a tool. It implements the protocol for programming the
> device flash or getting device information. The device implements the fastboot
> commands and host issue those commands for programming the firmware to device
> flash or to obtain device information. Inorder to execute those commands,
> first the device needs to be put into fastboot mode.
> 
> More details on fastboot can be found in links [1].
> 
> > In the end - I have no idea what the devlink param you're adding does.
> 
> "fastboot" devlink param is used to put the device into fastboot mode
> to program firmware to device flash or to obtain device information.
> 
> 
> [1]
> https://en.wikipedia.org/wiki/Fastboot
> https://android.googlesource.com/platform/system/core/+/refs/heads/master/fastboot/README.md

Make sure to improve the documentation too so that the next reader won't 
have the same problem in understanding. I hope this was obvious but just 
in case it wasn't, your true audience is the ones reading the doc later
and if a reviewer cannot understand your doc, the chances are the person 
reading the doc understands even less. And they won't have your reply to
the reviewer available so enough information should go into the 
documentation itself.


-- 
 i.

