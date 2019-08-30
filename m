Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFD8A3750
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfH3M5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfH3M5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:57:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A20F306141C;
        Fri, 30 Aug 2019 12:57:37 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F403B6092D;
        Fri, 30 Aug 2019 12:57:31 +0000 (UTC)
Date:   Fri, 30 Aug 2019 14:57:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH 1/3] samples: pktgen: make variable consistent with
 option
Message-ID: <20190830145730.7588842e@carbon>
In-Reply-To: <20190828204243.16666-1-danieltimlee@gmail.com>
References: <20190828204243.16666-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 30 Aug 2019 12:57:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 05:42:41 +0900
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
