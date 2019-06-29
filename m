Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1577C5AA38
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfF2Kgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 06:36:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfF2Kgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 06:36:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39406C04BE32;
        Sat, 29 Jun 2019 10:36:42 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAE14600C4;
        Sat, 29 Jun 2019 10:36:32 +0000 (UTC)
Date:   Sat, 29 Jun 2019 12:36:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net,
        maciejromanfijalkowski@gmail.com, brouer@redhat.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190629123630.58fc82b1@carbon>
In-Reply-To: <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Sat, 29 Jun 2019 10:36:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jun 2019 08:23:25 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> The interface only supports 1 Tx queue so locking is introduced on
> the Tx queue if XDP is enabled to make sure .ndo_start_xmit and
> .ndo_xdp_xmit won't corrupt Tx ring
> 
> - Performance (SMMU off)
> 
> Benchmark   XDP_SKB     XDP_DRV
> xdp1        291kpps     344kpps
> rxdrop      282kpps     342kpps
> 
> - Performance (SMMU on)
> Benchmark   XDP_SKB     XDP_DRV
> xdp1        167kpps     324kpps
> rxdrop      164kpps     323kpps
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

This version looks okay to me.  I don't have the hardware, so I've not
tested it...

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
