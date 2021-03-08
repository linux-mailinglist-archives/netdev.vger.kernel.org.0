Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6133112A
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 15:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCHOpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 09:45:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229690AbhCHOoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 09:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615214684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43UypbCzTnXB0x7gxN0e0ZilPKXGHB91HWB0eQzA2yw=;
        b=bUFz7whkvHFc8utb4FoaL03TFp8Vngm+Sw7Bz1NonAMQyFW/wjCmUWPmoV8f4+Y73f7h5a
        wIuM+ab0nM5cTWNV4Slkze1AqgbDaswgQzOehxSAftjYFCRmX8kP+rMA+EoVLPhIcZqbOT
        C+0xK4+i2c7mIx7TdYqSEdy5yE27cro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-OT69mG2kNrGuC3CFYXW6Ig-1; Mon, 08 Mar 2021 09:44:41 -0500
X-MC-Unique: OT69mG2kNrGuC3CFYXW6Ig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 554F519067E3;
        Mon,  8 Mar 2021 14:44:40 +0000 (UTC)
Received: from carbon (unknown [10.36.110.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7ADF69115;
        Mon,  8 Mar 2021 14:44:12 +0000 (UTC)
Date:   Mon, 8 Mar 2021 15:44:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V2 0/2] bpf: Updates for BPF-helper
 bpf_check_mtu
Message-ID: <20210308154411.764016a2@carbon>
In-Reply-To: <9e620507-6e9b-16f8-5ef9-3bbf2c2b6a3c@iogearbox.net>
References: <161364896576.1250213.8059418482723660876.stgit@firesoul>
        <20210219073638.75b3d8f3@carbon>
        <9e620507-6e9b-16f8-5ef9-3bbf2c2b6a3c@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 23:34:34 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 2/19/21 7:36 AM, Jesper Dangaard Brouer wrote:
> > On Thu, 18 Feb 2021 12:49:53 +0100
> > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >   
> >> The FIB lookup example[1] show how the IP-header field tot_len
> >> (iph->tot_len) is used as input to perform the MTU check. The recently
> >> added MTU check helper bpf_check_mtu() should also support this type
> >> of MTU check.
> >>
> >> Lets add this feature before merge window, please. This is a followup
> >> to 34b2021cc616 ("bpf: Add BPF-helper for MTU checking").  
> > 
> > Which git tree should I send this against bpf-next or bpf, to keep this
> > change together with 34b2021cc616 ("bpf: Add BPF-helper for MTU
> > checking") ?  
> 
> Given this is an api change, we'll take this into bpf tree after the
> pending pr was merged.

That sounds great, but I noticed that they have not reached bpf-tree
yet. And the patches[1][2] disappeared[0] from patchwork as they were
archived, which confuse me.

As the patchset doesn't apply cleanly (due to whitespace in comment)
against bpf-tree, I'll resend it.

[0] https://patchwork.kernel.org/project/netdevbpf/list/?series=434987
[1] https://patchwork.kernel.org/project/netdevbpf/patch/161364899856.1250213.17435782167100828617.stgit@firesoul/
[2] https://patchwork.kernel.org/project/netdevbpf/patch/161364900363.1250213.9894483265551874755.stgit@firesoul/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

