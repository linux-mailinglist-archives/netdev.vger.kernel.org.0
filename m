Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02ABF35FFDC
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhDOCJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:09:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:40919 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhDOCJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 22:09:00 -0400
IronPort-SDR: P6S8/D9WBuFEfR7UptKM45H4v+xT8Op96187DTb5eJCVVrhpN1S8vbnSByaeh5vkVsOoSNhgX7
 r2VRf6jj/gfA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="215274768"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="215274768"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 19:08:38 -0700
IronPort-SDR: 7lii/VjEuWHAT3RP9346JTNZO8RSGOm7hnPYTpW67DFX3TYpIMnFs76RVGwA9n0rp9EIoupYif
 Gu5a8LDWGMsA==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="383875358"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.19.126])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 19:08:37 -0700
Date:   Wed, 14 Apr 2021 19:08:37 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     anthony.l.nguyen@intel.com, David Miller <davem@davemloft.net>,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net v2] i40e: fix the panic when running bpf in xdpdrv
 mode
Message-ID: <20210414190837.0000085a@intel.com>
In-Reply-To: <CAL+tcoBVhD1SfMYAFVn0HxZ3ig88pxtiLoha9d6Z+62yq8bWBA@mail.gmail.com>
References: <20210412065759.2907-1-kerneljasonxing@gmail.com>
        <20210413025011.1251-1-kerneljasonxing@gmail.com>
        <20210413091812.0000383d@intel.com>
        <CAL+tcoBVhD1SfMYAFVn0HxZ3ig88pxtiLoha9d6Z+62yq8bWBA@mail.gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Xing wrote:

> On Wed, Apr 14, 2021 at 12:27 AM Jesse Brandeburg
> <jesse.brandeburg@intel.com> wrote:
> >
> > kerneljasonxing@gmail.com wrote:
> >
> > > From: Jason Xing <xingwanli@kuaishou.com>
> >
> > Hi Jason,
> >
> > Sorry, I missed this on the first time: Added intel-wired-lan,
> > please include on any future submissions for Intel drivers.
> > get-maintainers script might help here?
> >
> 
> Probably I got this wrong in the last email. Did you mean that I should add
> intel-wired-lan in the title not the cc list? It seems I should put
> this together on
> the next submission like this:
> 
> [Intel-wired-lan] [PATCH net v4]

Your v3 submittal was correct. My intent was to make sure
intel-wired-lan was in CC:

If Kuba or Dave wants us to take the fix in via intel-wired-lan trees,
then we can do that, or they can apply it directly. I'll ack it on the
v3.

