Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE862747C6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgIVRwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:52:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:45249 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgIVRwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 13:52:12 -0400
IronPort-SDR: ddcOIDm69ZzICYcxq2RnKZ8qRhnrXeOq5/sX/FQ0A8SwW9ic2B+N12FAgam0gSu8OSPIQT3VB3
 Vgp1hclaBYFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="140153337"
X-IronPort-AV: E=Sophos;i="5.77,291,1596524400"; 
   d="scan'208";a="140153337"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 10:52:12 -0700
IronPort-SDR: hzGM7ZD/TLaivxNqob4cD0Y2BbYb0rbiuqA54mVS/DQldSC8tI27QcHr3AkXn3MwS/VtAnY3kk
 teMxcet2SI5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,291,1596524400"; 
   d="scan'208";a="290475502"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga007.fm.intel.com with SMTP; 22 Sep 2020 10:52:06 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 22 Sep 2020 20:52:06 +0300
Date:   Tue, 22 Sep 2020 20:52:06 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix Kernel-doc warnings introduced on next-20200921
Message-ID: <20200922175206.GY6112@intel.com>
References: <cover.1600773619.git.mchehab+huawei@kernel.org>
 <a2c0d1ac02fb4bef142196d837323bcde41e9427.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2c0d1ac02fb4bef142196d837323bcde41e9427.camel@redhat.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 01:39:41PM -0400, Lyude Paul wrote:
> For patches 2 and 3:
> 
> Reviewed-by: Lyude Paul <lyude@redhat.com>
> 
> I'll go ahead and push these to drm-intel-next-queued (since drm-misc-next
> doesn't have these patches in yet, and the commits these fix were originally
> merged through drm-intel-next-queued anyway). thanks!

Mea culpa. My doc test build was foiled by the sphinx 2 vs. 3
regression and I was too lazy to start downgrading things.
Any ETA for getting that fixed btw?

> 
> On Tue, 2020-09-22 at 13:22 +0200, Mauro Carvalho Chehab wrote:
> > A few new warnings were added at linux-next. Address them, in order for us
> > to keep zero warnings at the docs.
> > 
> > The entire patchset fixing all kernel-doc warnings is at:
> > 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=doc-fixes
> > 
> > Mauro Carvalho Chehab (3):
> >   net: fix a new kernel-doc warning at dev.c
> >   drm/dp: fix kernel-doc warnings at drm_dp_helper.c
> >   drm/dp: fix a kernel-doc issue at drm_edid.c
> > 
> >  drivers/gpu/drm/drm_dp_helper.c | 5 +++++
> >  drivers/gpu/drm/drm_edid.c      | 2 +-
> >  net/core/dev.c                  | 4 ++--
> >  3 files changed, 8 insertions(+), 3 deletions(-)
> > 
> -- 
> Cheers,
> 	Lyude Paul (she/her)
> 	Software Engineer at Red Hat

-- 
Ville Syrjälä
Intel
