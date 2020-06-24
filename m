Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72A7206F0A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389275AbgFXIg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:36:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49219 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389042AbgFXIg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592987787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wxUFZ5mib77mHObsO3l63IepVrrXcAMLemjg0wGcyDs=;
        b=Lce+Cyoi7NgrUX991KsyA3/MrYSM2744vTbK6QCYRzGnBurk9LpJf1TZFh9UdV/TOo+xCe
        FGxsoLWL15f15V7BdZmqG4AZq2QJiZhDP6ScGSb10WqUjEGDAO+7JuwdlGS5w6jODBUKty
        FlcXu8DranEH62QmssppztJ+4a1YcQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-x6chqOo3OtSwPHe3iQrFcg-1; Wed, 24 Jun 2020 04:36:25 -0400
X-MC-Unique: x6chqOo3OtSwPHe3iQrFcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1E11107ACF2;
        Wed, 24 Jun 2020 08:36:23 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10992512FE;
        Wed, 24 Jun 2020 08:36:10 +0000 (UTC)
Date:   Wed, 24 Jun 2020 10:36:09 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 7/9] libbpf: add SEC name for xdp programs
 attached to CPUMAP
Message-ID: <20200624103609.69ccdff9@carbon>
In-Reply-To: <CAEf4BzbiZLtr8Vhwef=Zjd_=OVqKBozyg76Djae7qw3rgd7q8g@mail.gmail.com>
References: <cover.1592947694.git.lorenzo@kernel.org>
        <372755fa10bdbe9b5db4e207db6b0829e18513fe.1592947694.git.lorenzo@kernel.org>
        <CAEf4BzbiZLtr8Vhwef=Zjd_=OVqKBozyg76Djae7qw3rgd7q8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 22:49:02 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Tue, Jun 23, 2020 at 2:40 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > As for DEVMAP, support SEC("xdp_cpumap*") as a short cut for loading
                                ^^^^^^^^^^^

Maybe update desc to include the "/" ?
  
> > the program with type BPF_PROG_TYPE_XDP and expected attach type
> > BPF_XDP_CPUMAP.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---  
> 
> Thanks!
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>

I like this extra "/".

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

If we agree, I hope we can also adjust this for devmap in bpf-tree ?


> >  tools/lib/bpf/libbpf.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 18461deb1b19..16fa3b84ac38 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -6866,6 +6866,8 @@ static const struct bpf_sec_def section_defs[] = {
> >                 .attach_fn = attach_iter),
> >         BPF_EAPROG_SEC("xdp_devmap",            BPF_PROG_TYPE_XDP,
> >                                                 BPF_XDP_DEVMAP),
> > +       BPF_EAPROG_SEC("xdp_cpumap/",           BPF_PROG_TYPE_XDP,
> > +                                               BPF_XDP_CPUMAP),
> >         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
> >         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
> >         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
> > --

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

