Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AA679091
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfG2QQv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jul 2019 12:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfG2QQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:16:51 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D138307D91E;
        Mon, 29 Jul 2019 16:16:51 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DC7F5C219;
        Mon, 29 Jul 2019 16:16:41 +0000 (UTC)
Date:   Mon, 29 Jul 2019 18:16:40 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v5 4/6] tools/include/uapi: Add devmap_hash BPF
 map type
Message-ID: <20190729181640.6a3e9e7c@carbon>
In-Reply-To: <156415721611.13581.17123668393574840124.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
        <156415721611.13581.17123668393574840124.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 29 Jul 2019 16:16:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 18:06:56 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This adds the devmap_hash BPF map type to the uapi headers in tools/.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
