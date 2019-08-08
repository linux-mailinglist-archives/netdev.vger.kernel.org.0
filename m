Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6283F86B12
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404197AbfHHUFj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 16:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403798AbfHHUFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:05:39 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E2A13073A23;
        Thu,  8 Aug 2019 20:05:39 +0000 (UTC)
Received: from carbon (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88CBB194BB;
        Thu,  8 Aug 2019 20:05:18 +0000 (UTC)
Date:   Thu, 8 Aug 2019 22:05:16 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Y Song <ys114321@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@gmail.com>, Yonghong Song <yhs@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next v5 0/6] xdp: Add devmap_hash map type
Message-ID: <20190808220516.1adeca9a@carbon>
In-Reply-To: <CAH3MdRWk_bZVpBUZ8=xsMNw2hUwnQ3Yv-otu9M+7f1Cwr-t1UA@mail.gmail.com>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
        <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com>
        <87k1bnsbds.fsf@toke.dk>
        <CAH3MdRWk_bZVpBUZ8=xsMNw2hUwnQ3Yv-otu9M+7f1Cwr-t1UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 08 Aug 2019 20:05:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Aug 2019 12:57:05 -0700
Y Song <ys114321@gmail.com> wrote:

> On Thu, Aug 8, 2019 at 12:43 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >  
> > > On Fri, Jul 26, 2019 at 9:06 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:  
> > >>
> > >> This series adds a new map type, devmap_hash, that works like the existing
> > >> devmap type, but using a hash-based indexing scheme. This is useful for the use
> > >> case where a devmap is indexed by ifindex (for instance for use with the routing
> > >> table lookup helper). For this use case, the regular devmap needs to be sized
> > >> after the maximum ifindex number, not the number of devices in it. A hash-based
> > >> indexing scheme makes it possible to size the map after the number of devices it
> > >> should contain instead.
> > >>
> > >> This was previously part of my patch series that also turned the regular
> > >> bpf_redirect() helper into a map-based one; for this series I just pulled out
> > >> the patches that introduced the new map type.
> > >>
> > >> Changelog:
> > >>
> > >> v5:
> > >>
> > >> - Dynamically set the number of hash buckets by rounding up max_entries to the
> > >>   nearest power of two (mirroring the regular hashmap), as suggested by Jesper.  
> > >
> > > fyi I'm waiting for Jesper to review this new version.  
> >
> > Ping Jesper? :)  
> 
> Toke, the patch set has been merged to net-next.
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=d3406913561c322323ec2898cc58f55e79786be7
> 

Yes, and I did review this... :-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
