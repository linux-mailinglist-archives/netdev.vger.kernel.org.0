Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E62566ED5
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiGENAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiGEM73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 08:59:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08D6193F5;
        Tue,  5 Jul 2022 05:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657024147; x=1688560147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8FlJh0epwKQ67CHp0E3CBrim4PYDVOsRrhLi+D6nts8=;
  b=bQzeTaRheEfWdES2Gydl7h3out8cOyuO3Q0pGgm+o+hs8BHVjsz11Wqf
   15bzvBe9N8GCyC5iYtKJfgxO0TN2xTXN7uGmpB5pkauVofRqh23wSV13g
   71TL/WIjMZc4EyETQSQgF47mIs4fwTYEteMF94wZISwJ6he9wEYR1A4i/
   wr+eFxTOX8TMoQkdF/7xZfAe6ggo8FezGwyzGcZ5cpQeQf6xb6zXa0InJ
   bAJ9UGZ1AK2KxieZlw/WCWcZHq1TWJ65U/bOhnSlcPPqhfxxVv9Tpzm+p
   EbKWbH6aC28+Iifa529LJ2Z4hyH4mtTEudNlV+Y3qo3xJsNPQym2U//DC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="284452646"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="284452646"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 05:27:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="660538993"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jul 2022 05:27:42 -0700
Date:   Tue, 5 Jul 2022 14:27:41 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: adjust XDP SOCKETS after file movement
Message-ID: <YsQuPS1p/2AiJQh/@boxer>
References: <20220701042810.26362-1-lukas.bulwahn@gmail.com>
 <Yr7mcjRq57laZGEY@boxer>
 <CAJ8uoz16yGJqYX2xOcczTGKFnG4joh8+f1uPGMAP4rmm3feYDQ@mail.gmail.com>
 <Yr78Md1Nqpj+peO0@boxer>
 <c9c2d7b3-7d29-252d-6070-77d562ee4c3b@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9c2d7b3-7d29-252d-6070-77d562ee4c3b@iogearbox.net>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 02:01:06PM +0200, Daniel Borkmann wrote:
> On 7/1/22 3:52 PM, Maciej Fijalkowski wrote:
> > On Fri, Jul 01, 2022 at 03:13:36PM +0200, Magnus Karlsson wrote:
> > > On Fri, Jul 1, 2022 at 2:38 PM Maciej Fijalkowski
> > > <maciej.fijalkowski@intel.com> wrote:
> > > > 
> > > > On Fri, Jul 01, 2022 at 06:28:10AM +0200, Lukas Bulwahn wrote:
> > > > > Commit f36600634282 ("libbpf: move xsk.{c,h} into selftests/bpf") moves
> > > > > files tools/{lib => testing/selftests}/bpf/xsk.[ch], but misses to adjust
> > > > > the XDP SOCKETS (AF_XDP) section in MAINTAINERS.
> > > > > 
> > > > > Adjust the file entry after this file movement.
> > > > > 
> > > > > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > > > > ---
> > > > > Andrii, please ack.
> > > > > 
> > > > > Alexei, please pick this minor non-urgent clean-up on top of the commit above.
> > > > > 
> > > > >   MAINTAINERS | 2 +-
> > > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index fa4bfa3d10bf..27d9e65b9a85 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -22042,7 +22042,7 @@ F:    include/uapi/linux/xdp_diag.h
> > > > >   F:   include/net/netns/xdp.h
> > > > >   F:   net/xdp/
> > > > >   F:   samples/bpf/xdpsock*
> > > > > -F:   tools/lib/bpf/xsk*
> > > > > +F:   tools/testing/selftests/bpf/xsk*
> > > > 
> > > > Magnus, this doesn't cover xdpxceiver.
> > > > How about we move the lib part and xdpxceiver part to a dedicated
> > > > directory? Or would it be too nested from main dir POV?
> > > 
> > > Or we can just call everything we add xsk* something?
> > 
> > No strong feelings. test_xsk.sh probably also needs to be addressed.
> > That's why I proposed dedicated dir.
> 
> Could one of you follow-up on this for bpf-next tree? Maybe for selftests something
> similar as in case of the XDP entry could work.

Yes, sorry. Let's do:

F:	tools/testing/selftests/bpf/*xsk*

then s/xdpxceiver/xskxceiver. I can send a follow-up and add Lukas as a
reporter.

Sounds good?

> 
> Thanks,
> Daniel
