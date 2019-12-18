Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB299124569
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLRLLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:11:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27383 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfLRLLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:11:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576667506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7XzD5ev6iIeajtEJ8QU1QYPQhlO4elODv38UFwEHGc=;
        b=HcKFkj/wHS4jalS94jLsKSML5fztkfNh20j8l/k0YCf9FkzQ1UhuzrKWFbebaWPtRB/6CE
        B0Wbr88QUuNgOnhPy1ROixAqIgYjA28MdyG4d4+dzNyNdlUaZOAwbKoHau2ukINpQ8dCzi
        hzgEgSzpJT7tXG+nZq/+YZInmQY17+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-5yVgNrTaP-aue4WSK1GGMg-1; Wed, 18 Dec 2019 06:11:42 -0500
X-MC-Unique: 5yVgNrTaP-aue4WSK1GGMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B043A19057B2;
        Wed, 18 Dec 2019 11:11:40 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E4CF6888B;
        Wed, 18 Dec 2019 11:11:34 +0000 (UTC)
Date:   Wed, 18 Dec 2019 12:11:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Message-ID: <20191218121132.4023f4f1@carbon>
In-Reply-To: <20191218105400.2895-1-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 11:53:52 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

>   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
>  =20
>   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
>   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
>   XDP-RX          20      7723038        0           0
>   XDP-RX          total   7723038        0
>   cpumap_kthread  total   0              0           0
>   redirect_err    total   0              0
>   xdp_exception   total   0              0

Hmm... I'm missing some counters on the kthread side.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

