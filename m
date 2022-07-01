Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175415634B6
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiGANwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiGANwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:52:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E766B286ED;
        Fri,  1 Jul 2022 06:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656683572; x=1688219572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=hU5wtGG6cfmkysoPoL41jEdZ2gEmdJViRKm4NPb0bgE=;
  b=EPv9QJTRepvHoM7RXJmoPC5ZR27AzQALETHdqoOUviwUbxg0lG6oWoIf
   7M2gL+VrXfoRv8iKiG3m3vVuWM9aRkosYgJq90ZTP4AmkYq5z4iJ55E4Y
   lWk3nofR4Kd4Lh+aCu3bsmqEaFdfAK+ni6wKlFntltEiJBcRAJM0OMk39
   K5p3+GV30anucBwafxKe+bz0wG1SBJcDd3mVaCKYfYz4wyo1PVYU6hv30
   nxe7sG5zC3sXuQruNX8mEAW/zhF53X23As4GoqNbolOqRVjG61JT0Mqdc
   RE3A6ahiex3I/ykaxOZxe1ziSJyRIQR+Ra5QjQsSvW3SOHtryJNmtKt0y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="280207482"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="280207482"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:52:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="694515095"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jul 2022 06:52:50 -0700
Date:   Fri, 1 Jul 2022 15:52:49 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: adjust XDP SOCKETS after file movement
Message-ID: <Yr78Md1Nqpj+peO0@boxer>
References: <20220701042810.26362-1-lukas.bulwahn@gmail.com>
 <Yr7mcjRq57laZGEY@boxer>
 <CAJ8uoz16yGJqYX2xOcczTGKFnG4joh8+f1uPGMAP4rmm3feYDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ8uoz16yGJqYX2xOcczTGKFnG4joh8+f1uPGMAP4rmm3feYDQ@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 03:13:36PM +0200, Magnus Karlsson wrote:
> On Fri, Jul 1, 2022 at 2:38 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Fri, Jul 01, 2022 at 06:28:10AM +0200, Lukas Bulwahn wrote:
> > > Commit f36600634282 ("libbpf: move xsk.{c,h} into selftests/bpf") moves
> > > files tools/{lib => testing/selftests}/bpf/xsk.[ch], but misses to adjust
> > > the XDP SOCKETS (AF_XDP) section in MAINTAINERS.
> > >
> > > Adjust the file entry after this file movement.
> > >
> > > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > > ---
> > > Andrii, please ack.
> > >
> > > Alexei, please pick this minor non-urgent clean-up on top of the commit above.
> > >
> > >  MAINTAINERS | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index fa4bfa3d10bf..27d9e65b9a85 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -22042,7 +22042,7 @@ F:    include/uapi/linux/xdp_diag.h
> > >  F:   include/net/netns/xdp.h
> > >  F:   net/xdp/
> > >  F:   samples/bpf/xdpsock*
> > > -F:   tools/lib/bpf/xsk*
> > > +F:   tools/testing/selftests/bpf/xsk*
> >
> > Magnus, this doesn't cover xdpxceiver.
> > How about we move the lib part and xdpxceiver part to a dedicated
> > directory? Or would it be too nested from main dir POV?
> 
> Or we can just call everything we add xsk* something?

No strong feelings. test_xsk.sh probably also needs to be addressed.
That's why I proposed dedicated dir.

> 
> > >
> > >  XEN BLOCK SUBSYSTEM
> > >  M:   Roger Pau Monné <roger.pau@citrix.com>
> > > --
> > > 2.17.1
> > >
