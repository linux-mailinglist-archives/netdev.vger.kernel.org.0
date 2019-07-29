Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B127903B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfG2QC4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jul 2019 12:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfG2QC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:02:56 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7D155D66B;
        Mon, 29 Jul 2019 16:02:55 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57CB16031A;
        Mon, 29 Jul 2019 16:02:45 +0000 (UTC)
Date:   Mon, 29 Jul 2019 18:02:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v5 2/6] xdp: Refactor devmap allocation code
 for reuse
Message-ID: <20190729180244.76f561cc@carbon>
In-Reply-To: <156415721358.13581.4862146144828700187.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
        <156415721358.13581.4862146144828700187.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 29 Jul 2019 16:02:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 18:06:53 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The subsequent patch to add a new devmap sub-type can re-use much of the
> initialisation and allocation code, so refactor it into separate functions.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
