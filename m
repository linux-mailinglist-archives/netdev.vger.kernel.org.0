Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B178FA4
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbfG2PnB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jul 2019 11:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32189 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387476AbfG2PnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 11:43:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1074E308FC23;
        Mon, 29 Jul 2019 15:43:01 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A66385D6A5;
        Mon, 29 Jul 2019 15:42:53 +0000 (UTC)
Date:   Mon, 29 Jul 2019 17:42:51 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v5 1/6] include/bpf.h: Remove map_insert_ctx()
 stubs
Message-ID: <20190729174251.702a833b@carbon>
In-Reply-To: <156415721232.13581.13120224208737507294.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
        <156415721232.13581.13120224208737507294.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 29 Jul 2019 15:43:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 18:06:52 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> When we changed the device and CPU maps to use linked lists instead of
> bitmaps, we also removed the need for the map_insert_ctx() helpers to keep
> track of the bitmaps inside each map. However, it seems I forgot to remove
> the function definitions stubs, so remove those here.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
