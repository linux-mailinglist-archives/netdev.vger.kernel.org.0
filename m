Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ABE30F30E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhBDMTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:19:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:11838 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235728AbhBDMTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 07:19:22 -0500
IronPort-SDR: RD+aLEguHrm9TgFVxs9jIYe47M9et+OYm9I9N2/7MWwtP/4srwrC0M9tF9eJ9LlfwRIAnxEEJe
 JUdZrtLcCQaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="180451530"
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="180451530"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 04:18:41 -0800
IronPort-SDR: 2D7Bk4E3/qJd7MvT3XLdlxrsThbOda5CjSA8U37igqDRj6KgKNBlziHpy5szDujq0q7CagwLTD
 P2fZd13WKQTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="397031275"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga007.jf.intel.com with ESMTP; 04 Feb 2021 04:18:38 -0800
Date:   Thu, 4 Feb 2021 13:09:22 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv17 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210204120922.GA9417@ranger.igk.intel.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210204001458.GB2900@Leo-laptop-t470s>
 <601b61a0e4868_194420834@john-XPS-13-9370.notmuch>
 <20210204031236.GC2900@Leo-laptop-t470s>
 <87zh0k85de.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zh0k85de.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 12:00:29PM +0100, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > On Wed, Feb 03, 2021 at 06:53:20PM -0800, John Fastabend wrote:
> >> Hangbin Liu wrote:
> >> > Hi Daniel, Alexei,
> >> > 
> >> > It has been one week after Maciej, Toke, John's review/ack. What should
> >> > I do to make a progress for this patch set?
> >> > 
> >> 
> >> Patchwork is usually the first place to check:
> >
> > Thanks John for the link.
> >> 
> >>  https://patchwork.kernel.org/project/netdevbpf/list/?series=421095&state=*
> >
> > Before I sent the email I only checked link
> > https://patchwork.kernel.org/project/netdevbpf/list/ but can't find my patch.
> >
> > How do you get the series number?
> 
> If you click the "show patches with" link at the top you can twiddle the
> filtering; state = any + your own name as submitter usually finds
> things, I've found.
> 
> >> Looks like it was marked changed requested. After this its unlikely
> >> anyone will follow up on it, rightly so given the assumption another
> >> revision is coming.
> >> 
> >> In this case my guess is it was moved into changes requested because
> >> I asked for a change, but then after some discussion you convinced me
> >> the change was not in fact needed.
> >> 
> >> Alexei, Daniel can probably tell you if its easier to just send a v18
> >> or pull in the v17 assuming any final reviews don't kick anything
> >> else up.
> >
> > OK, I will wait for Alexei, Daniel and see if I need to do a rebase.
> 
> I think I would just resubmit with a rebase + a note in the changelog
> that we concluded no further change was needed :)

I only asked for imperative mood in commit messages, but not sure if
anyone cares ;)

> 
> -Toke
> 
