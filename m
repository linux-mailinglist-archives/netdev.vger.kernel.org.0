Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C5866CB
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403849AbfHHQRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:17:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfHHQRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 12:17:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54A4E4E93D;
        Thu,  8 Aug 2019 16:17:38 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-48.brq.redhat.com [10.40.200.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0AB910016E9;
        Thu,  8 Aug 2019 16:17:33 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 996063002D55F;
        Thu,  8 Aug 2019 18:17:32 +0200 (CEST)
Subject: [bpf-next v3 PATCH 0/3] bpf: improvements to xdp_fwd sample
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        ys114321@gmail.com, Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Thu, 08 Aug 2019 18:17:32 +0200
Message-ID: <156528102557.22124.261409336813472418.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 08 Aug 2019 16:17:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V3: Hopefully fixed all issues point out by Yonghong Song

V2: Addressed issues point out by Yonghong Song
 - Please ACK patch 2/3 again
 - Added ACKs and reviewed-by to other patches

This patchset is focused on improvements for XDP forwarding sample
named xdp_fwd, which leverage the existing FIB routing tables as
described in LPC2018[1] talk by David Ahern.

The primary motivation is to illustrate how Toke's recent work
improves usability of XDP_REDIRECT via lookups in devmap. The other
patches are to help users understand the sample.

I have more improvements to xdp_fwd, but those might requires changes
to libbpf.  Thus, sending these patches first as they are isolated.

[1] http://vger.kernel.org/lpc-networking2018.html#session-1

---

Jesper Dangaard Brouer (3):
      samples/bpf: xdp_fwd rename devmap name to be xdp_tx_ports
      samples/bpf: make xdp_fwd more practically usable via devmap lookup
      samples/bpf: xdp_fwd explain bpf_fib_lookup return codes


 samples/bpf/xdp_fwd_kern.c |   39 ++++++++++++++++++++++++++++++---------
 samples/bpf/xdp_fwd_user.c |   35 +++++++++++++++++++++++------------
 2 files changed, 53 insertions(+), 21 deletions(-)

--
