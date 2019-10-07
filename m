Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DB9CDD13
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 10:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfJGIT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 04:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfJGIT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 04:19:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FB7610C0929;
        Mon,  7 Oct 2019 08:19:27 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5E695D6D0;
        Mon,  7 Oct 2019 08:19:20 +0000 (UTC)
Date:   Mon, 7 Oct 2019 10:19:19 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next v5 4/4] samples: pktgen: allow to specify
 destination IP range (CIDR)
Message-ID: <20191007101919.13c7f4cc@carbon>
In-Reply-To: <20191005082509.16137-5-danieltimlee@gmail.com>
References: <20191005082509.16137-1-danieltimlee@gmail.com>
        <20191005082509.16137-5-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 07 Oct 2019 08:19:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Oct 2019 17:25:09 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> Currently, kernel pktgen has the feature to specify destination
> address range for sending packet. (e.g. pgset "dst_min/dst_max")
> 
> But on samples, each pktgen script doesn't have any option to achieve this.
> 
> This commit adds the feature to specify the destination address range with CIDR.
> 
>     -d : ($DEST_IP)   destination IP. CIDR (e.g. 198.18.0.0/15) is also allowed
> 
>     # ./pktgen_sample01_simple.sh -6 -d fe80::20/126 -p 3000 -n 4
>     # tcpdump ip6 and udp
>     05:14:18.082285 IP6 fe80::99.71 > fe80::23.3000: UDP, length 16
>     05:14:18.082564 IP6 fe80::99.43 > fe80::23.3000: UDP, length 16
>     05:14:18.083366 IP6 fe80::99.107 > fe80::22.3000: UDP, length 16
>     05:14:18.083585 IP6 fe80::99.97 > fe80::21.3000: UDP, length 16
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
