Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFAE30E626
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 23:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhBCWhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 17:37:51 -0500
Received: from michaelblizek.twilightparadox.com ([193.238.157.55]:55746 "EHLO
        michaelblizek.twilightparadox.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232483AbhBCWhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 17:37:50 -0500
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2021 17:37:50 EST
Received: from localhost ([127.0.0.1] helo=grml)
        by michaelblizek.twilightparadox.com with esmtp (Exim 4.92)
        (envelope-from <michi1@michaelblizek.twilightparadox.com>)
        id 1l7QWH-0001my-Rb; Wed, 03 Feb 2021 23:21:06 +0100
Date:   Wed, 3 Feb 2021 23:21:10 +0100
From:   michi1@michaelblizek.twilightparadox.com
To:     kernelnewbies@kernelnewbies.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jakub@cloudflare.com, pabeni@redhat.com
Subject: Re: UDP implementation and the MSG_MORE flag
Message-ID: <20210203222054.6zhq47o7rzjstpdq@grml>
References: <20210126141248.GA27281@optiplex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126141248.GA27281@optiplex>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On 15:12 Tue 26 Jan     , Oliver Graute wrote:
> Some UDP packets send via the loopback interface are dropped in the
> kernel on the receive side when using sendto with the MSG_MORE flag.
> Every drop increases the InCsumErrors in /proc/self/net/snmp. Some
> example code to reproduce it is appended below.
> 
> In the code we tracked it down to this code section. ( Even a little
> further but its unclear to me wy the csum() is wrong in the bad case)

I think it is unlikely that the error is on the receiving side. I recommend to
capture the data that is being sent with a sniffer and see if there is
anything wrong. You may also want to try disabling hardware acceleration on
your network devices, because the checksum is sometimes done in hardware.

	-Michi
-- 
programing a layer 3+4 network protocol for mesh networks
see http://michaelblizek.twilightparadox.com
