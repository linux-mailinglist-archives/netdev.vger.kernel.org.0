Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7A1EF59F
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgFEKrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgFEKrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 06:47:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2CFC08C5C2;
        Fri,  5 Jun 2020 03:47:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jh9sa-0003Hd-EX; Fri, 05 Jun 2020 12:47:16 +0200
Date:   Fri, 5 Jun 2020 12:47:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org
Subject: [ANNOUNCE] libnetfilter_queue 1.0.4 release
Message-ID: <20200605104716.GJ28263@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnetfilter_queue 1.0.4

Major changes in this version:
 * major updates to documentation, from Duncan Roe.
 * allow building with clan, also from Duncan.
 * add new nfq_get_skbinfo() helper.  This allows to detect when
   packet checksums have been validated already or if they will
   be filled in by tx checksum offload on transmit later on.

Notable bug fixes:
 checksum calculation fixes for UDP checksum helpers and on big endian arches,
 from Pablo Neira and Alin Nastac.

See ChangeLog that comes attached to this email for more details.

You can download it from:

https://www.netfilter.org/projects/libnetfilter_queue/downloads.html

Have fun!

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnetfilter_queue-1.0.4.txt"

Alin Nastac (1):
      checksum: Fix TCP/UDP checksum computation on big endian arches

Duncan Roe (40):
      src: Update UDP header length field after mangling
      src: doc: Miscellaneous updates
      src: Enable clang build
      src: Fix invalid conversion specifier
      src: doc: Minor fix
      src: doc: Document nfq_nlmsg_verdict_put_mark() and nfq_nlmsg_verdict_put_pkt()
      src: Eliminate useless spaces before tabs
      src: doc: Update the Main Page to be nft-focussed
      src: doc: Fix spelling of CTA_LABELS in examples/nf-queue.c
      src: doc: Eliminate doxygen warnings from ipv{4,6}.c
      src: pktb_trim() was not updating tail after updating len
      src: Make sure pktb_alloc() works for AF_INET6 since we document that it does
      src: Make sure pktb_alloc() works for IPv6 over AF_BRIDGE
      src: Fix IPv4 checksum calculation in AF_BRIDGE packet buffer
      examples: Delete code not needed since Linux 3.8
      src: Fix test for IPv6 header
      src: doc: Major re-work of user packet buffer documentation
      Minor tweak to pktb_len function description
      src: doc: Update sample code to agree with documentation
      src: doc: Fully document available verdicts
      src: Fix value returned by nfq_udp_get_payload_len()
      src: doc: udp.c: rename 1 more formal pkt arg to pktb
      src: doc: Eliminate doxygen warnings from udp.c
      src: more IPv6 checksum fixes
      src: add mangle functions for IPv6, IPv6/TCP and IPv6/UDP
      src: pktb_mangle has signed offset arg so can mangle MAC header with -ve one
      doc: whitespace: Remove trailing spaces from doxygen.cfg.in
      doc: doxygen.cfg.in: Eliminate 20 doxygen warnings
      src: doc: tcp.c: fix remaining doxygen warnings
      src: checksum.c: remove redundant 0xFFFF mask of uint16_t
      src: libnetfilter_queue.c: whitespace: remove trailing spaces
      src: doc: Eliminate doxygen warnings from libnetfilter_queue.c
      src: Always use pktb as formal arg of type struct pkt_buff
      src: doc: Final polish for current round
      src: Fix value returned by nfq_tcp_get_payload_len()
      src: Fix indenting weirdness is pktbuff.c w/out changing indent
      src: Simplify struct pkt_buff: remove head
      Simplify struct pkt_buff: remove tail
      build: doc: "make" builds & installs a full set of man pages
      src: expose nfq_nlmsg_put

Florian Westphal (3):
      src: add nfq_get_skbinfo()
      configure: fix doxygen check
      configure: prepare for 1.0.4 release

Pablo Neira Ayuso (2):
      checksum: Fix UDP checksum calculation
      doxygen: remove EXPORT_SYMBOL from the output


--6c2NcOVqGQ03X4Wi--
