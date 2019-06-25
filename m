Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D21528FB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfFYKF7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jun 2019 06:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfFYKF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 06:05:59 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EAC1D821EF;
        Tue, 25 Jun 2019 10:05:54 +0000 (UTC)
Received: from carbon (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C54845C231;
        Tue, 25 Jun 2019 10:05:45 +0000 (UTC)
Date:   Tue, 25 Jun 2019 12:05:43 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     brouer@redhat.com, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] samples: bpf: make the use of xdp samples consistent
Message-ID: <20190625120543.12b25184@carbon>
In-Reply-To: <878stqdoc9.fsf@toke.dk>
References: <20190625005536.2516-1-danieltimlee@gmail.com>
        <878stqdoc9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 25 Jun 2019 10:05:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 11:08:22 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> "Daniel T. Lee" <danieltimlee@gmail.com> writes:
> 
> > Currently, each xdp samples are inconsistent in the use.
> > Most of the samples fetch the interface with it's name.
> > (ex. xdp1, xdp2skb, xdp_redirect_cpu, xdp_sample_pkts, etc.)
> >
> > But some of the xdp samples are fetching the interface with
> > ifindex by command argument.
> >
> > This commit enables xdp samples to fetch interface with it's name
> > without changing the original index interface fetching.
> > (<ifname|ifindex> fetching in the same way as xdp_sample_pkts_user.c does.)
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> > Changes in v2:
> >   - added xdp_redirect_user.c, xdp_redirect_map_user.c  
> 
> Great, thanks!
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>

Great you basically solved one of our TODOs:
- TODO Change sample programs to accept ifnames as well as indexes

https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#next-change-sample-programs-to-accept-ifnames-as-well-as-indexes

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
