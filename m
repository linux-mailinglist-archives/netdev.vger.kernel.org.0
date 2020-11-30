Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2818F2C8364
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 12:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgK3LkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 06:40:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:60664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727288AbgK3LkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 06:40:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15CD3AD60;
        Mon, 30 Nov 2020 11:39:28 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7CED060320; Mon, 30 Nov 2020 12:39:27 +0100 (CET)
Date:   Mon, 30 Nov 2020 12:39:27 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201130113927.tyreinlrvrav22zm@lion.mk-sys.cz>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201128221635.63fdcf69@hermes.local>
 <X8M+PuwwZZwr+pdP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8M+PuwwZZwr+pdP@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 07:22:54AM +0100, Greg KH wrote:
> On Sat, Nov 28, 2020 at 10:16:35PM -0800, Stephen Hemminger wrote:
> 
> > If someone steps up to doing this then I would be happy to merge it now
> > for 5.10. Otherwise it won't show up until 5.11.
> 
> Don't ever "rush" anything for a LTS/stable release, otherwise I am
> going to have to go back to the old way of not announcing them until
> _after_ they are released as people throw stuff that is not ready for
> a normal merge.
> 
> This looks like a new feature, and shouldn't go in right now in the
> development cycle anyway, all features for 5.10 had to be in linux-next
> before 5.9 was released.

From the context, I believe Stephen meant merging into iproute2 5.10,
not kernel.

Michal Kubecek
