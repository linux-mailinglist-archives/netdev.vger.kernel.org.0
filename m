Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DD1CDC6D
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfJGHda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfJGHda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 03:33:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4111E30860D3;
        Mon,  7 Oct 2019 07:33:30 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 921836012C;
        Mon,  7 Oct 2019 07:33:23 +0000 (UTC)
Date:   Mon, 7 Oct 2019 09:33:22 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next v5 1/4] samples: pktgen: make variable
 consistent with option
Message-ID: <20191007093322.319f0657@carbon>
In-Reply-To: <20191005082509.16137-2-danieltimlee@gmail.com>
References: <20191005082509.16137-1-danieltimlee@gmail.com>
        <20191005082509.16137-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 07 Oct 2019 07:33:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Oct 2019 17:25:06 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> This commit changes variable names that can cause confusion.
> 
> For example, variable DST_MIN is quite confusing since the
> keyword 'udp_dst_min' and keyword 'dst_min' is used with pg_ctrl.
> 
> On the following commit, 'dst_min' will be used to set destination IP,
> and the existing variable name DST_MIN should be changed.
> 
> Variable names are matched to the exact keyword used with pg_ctrl.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
