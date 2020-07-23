Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8326022AE28
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgGWLpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:45:05 -0400
Received: from verein.lst.de ([213.95.11.211]:59827 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgGWLpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:45:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 82EBD68AFE; Thu, 23 Jul 2020 13:44:58 +0200 (CEST)
Date:   Thu, 23 Jul 2020 13:44:58 +0200
From:   'Christoph Hellwig' <hch@lst.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-decnet-user@lists.sourceforge.net" 
        <linux-decnet-user@lists.sourceforge.net>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mptcp@lists.01.org" <mptcp@lists.01.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>
Subject: Re: [PATCH 13/26] bpfilter: switch bpfilter_ip_set_sockopt to
 sockptr_t
Message-ID: <20200723114458.GA31363@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-14-hch@lst.de> <621e193e4af74d8198ed87d6a9ce8260@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <621e193e4af74d8198ed87d6a9ce8260@AcuMS.aculab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 11:16:16AM +0000, David Laight wrote:
> From: Christoph Hellwig
> > Sent: 23 July 2020 07:09
> > 
> > This is mostly to prepare for cleaning up the callers, as bpfilter by
> > design can't handle kernel pointers.
> 
> You've failed to fix the sense of the above...

The sense still is correct.
