Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4139D3750A5
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 10:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhEFIVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 04:21:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:49620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhEFIVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 04:21:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8D492AE37;
        Thu,  6 May 2021 08:19:49 +0000 (UTC)
Date:   Thu, 6 May 2021 10:19:47 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
Message-ID: <20210506081947.GD6564@kitsune.suse.cz>
References: <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
 <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com>
 <YIbkR6z6mxdNSzGO@krava>
 <YIcRlHQWWKbOlcXr@krava>
 <20210505135612.GZ6564@kitsune.suse.cz>
 <5a225970-32a2-1617-b264-bc40a2179618@kernel.org>
 <09399b84-0ee3-bd18-68ed-290851bc63f6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09399b84-0ee3-bd18-68ed-290851bc63f6@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 07:54:27AM +0200, Jiri Slaby wrote:
> On 06. 05. 21, 6:31, Jiri Slaby wrote:
> > > > > this one was reported by Jesper and was fixed by upgrading pahole
> > > > > that contains the new function generation fixes (v1.19)
> > > 
> > > It needs pahole 1.21 here, 1.19 was not sufficient. Even then it
> > > regressed again after 5.12 on arm64:
> > 
> > Could you try against devel:tools? I've removed the ftrace filter from
> > dwarves there (sr#890247 to factory).
> 
> Yes, works for me.
Yes, that fixes the problem with 5.13 rc

Thanks

Michal
