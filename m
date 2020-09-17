Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D026E934
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgIQW6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:58:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:48053 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIQW6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 18:58:10 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 18:58:10 EDT
IronPort-SDR: StVzCcg4O3qGDFbC5hgoJfvdxEmiHXRSUq2cIa6hkTqROWCqr98KFySjPMgNSR+NYgVzF/jb2M
 FtQDTJnVhTeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="139813260"
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="139813260"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 15:50:59 -0700
IronPort-SDR: XdtVjPfX/G4suJ36MOKruBuCb4TnM1yi393VUId/ZxRWP9vC9tD0ORix2yhcL/sX+zTUu5O4eo
 vTrj+anwqgbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="307647328"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga006.jf.intel.com with ESMTP; 17 Sep 2020 15:50:57 -0700
Date:   Fri, 18 Sep 2020 00:44:36 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: Re: [PATCH v8 bpf-next 6/7] bpf: allow for tailcalls in BPF
 subprograms for x64 JIT
Message-ID: <20200917224436.GA11842@ranger.igk.intel.com>
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
 <20200916211010.3685-7-maciej.fijalkowski@intel.com>
 <CAEf4Bza908+c__590SK+_39fUuk51+O2oQnLzGNZ8jyjib5yzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza908+c__590SK+_39fUuk51+O2oQnLzGNZ8jyjib5yzw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 02:03:32PM -0700, Andrii Nakryiko wrote:
> On Wed, Sep 16, 2020 at 3:54 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > Relax verifier's restriction that was meant to forbid tailcall usage
> > when subprog count was higher than 1.
> >
> > Also, do not max out the stack depth of program that utilizes tailcalls.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> 
> Maciej,
> 
> Only patches 6 and 7 arrived (a while ago) and seems like the other
> patches are lost and not going to come. Do you mind resending entire
> patch set?

Sure. Vger lately has been giving me a hard time, thought that maybe rest
of set would eventually arrive, similarly to what Toke experienced I
guess.

> 
> [...]
