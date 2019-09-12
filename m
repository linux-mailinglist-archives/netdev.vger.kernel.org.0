Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72960B1283
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 17:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbfILP7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 11:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfILP7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 11:59:32 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CB2D307D847;
        Thu, 12 Sep 2019 15:59:32 +0000 (UTC)
Received: from carbon (ovpn-200-47.brq.redhat.com [10.40.200.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D36806092D;
        Thu, 12 Sep 2019 15:59:23 +0000 (UTC)
Date:   Thu, 12 Sep 2019 17:59:21 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [v2 2/3] samples: pktgen: add helper functions for IP(v4/v6)
 CIDR parsing
Message-ID: <20190912175921.02bcd3b6@carbon>
In-Reply-To: <20190911184807.21770-2-danieltimlee@gmail.com>
References: <20190911184807.21770-1-danieltimlee@gmail.com>
        <20190911184807.21770-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 12 Sep 2019 15:59:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 03:48:06 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> This commit adds CIDR parsing and IP validate helper function to parse
> single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)

One question: You do know that this expansion of the CIDR will also
include the CIDR network broadcast IP and "network-address", is that
intentional?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
