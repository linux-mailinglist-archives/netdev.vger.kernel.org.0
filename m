Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085AF221D08
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 09:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgGPHIk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 03:08:40 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45981 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPHIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 03:08:40 -0400
Received: from sogo10.sd4.0x35.net (sogo10.sd4.0x35.net [10.200.201.60])
        (Authenticated sender: pbl@bestov.io)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPA id 8D7CB1C0004;
        Thu, 16 Jul 2020 07:08:38 +0000 (UTC)
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
In-Reply-To: <CAD=hENcYJwkL-mjgJd5OZ0B4tHz2Q9kuqQ8iHid=9TWgyvR=+Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
Date:   Thu, 16 Jul 2020 09:08:38 +0200
Cc:     "netdev" <netdev@vger.kernel.org>
To:     "Zhu Yanjun" <zyjzyj2000@gmail.com>
MIME-Version: 1.0
Message-ID: <773f-5f0ffd00-eb-de520b0@96800578>
Subject: =?utf-8?q?Re=3A?= Bonding driver unexpected behaviour
User-Agent: SOGoMail 4.3.2
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Zhu Yanjun,
 
On Thursday, July 16, 2020 05:41 CEST, Zhu Yanjun <zyjzyj2000@gmail.com> wrote: 

> 
> Please check this
> https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels/#gre
> 
> Perhaps gretap only forwards ip (with L2 header) packets.

That does not seem to be the case.
E.g.
root@fo-exit:/home/user# tcpdump -i intra16
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on intra16, link-type EN10MB (Ethernet), capture size 262144 bytes
09:05:12.619206 IP 10.88.16.100 > 10.88.16.200: GREv0, length 46: ARP, Request who-has 10.42.42.200 tell 10.42.42.100, length 28
09:05:12.619278 IP 10.88.16.200 > 10.88.16.100: GREv0, length 46: ARP, Reply 10.42.42.200 is-at da:9d:34:64:cb:8d (oui Unknown), length 28
09:05:14.054026 IP 10.88.16.200 > 10.88.16.100: GREv0, length 46: ARP, Request who-has 10.42.42.100 tell 10.42.42.200, length 28
09:05:14.107143 IP 10.88.16.100 > 10.88.16.200: GREv0, length 46: ARP, Reply 10.42.42.100 is-at d6:49:e5:19:52:16 (oui Unknown), length 28
^C

> 
> Possibly "arp -s" could help to workaround this.

Riccardo P. Bestetti

