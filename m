Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE432DC9E7
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgLQAXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:23:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgLQAXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:23:21 -0500
Date:   Wed, 16 Dec 2020 16:22:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608164560;
        bh=+k6J40LHT4luYaAKdz4GBPuGE8JtyhujMVMN+cMaiO0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=IYVCnmnVWFEbzCHLA7cZDZg5HOA1jp8kQ6MXx7K5ZMXMdO7vUuoTzcuz5GbvB+vi1
         jacXanhhgqtUUV3Oa0LE7ssa4wcbANnSa18JlO6WoomnL6NxvuS0ugYKwdq6M8yYn4
         Rv1j0FQ02y+mgbMXg/e4Sq3G7ZVXFYOQnBjy6nhvj6tgD/HZNpZoK5UNjHaD9y3QGn
         3zTl8Ac/9dV5XG986xG5k5Ri7dNCxvKZcfbcbYQiIJg2j4OaRge8qjWmnFspXuU9ut
         cSF6a2noGs+Ikj8ceflySYoTQMWanYslRLak+J+gFEQ6ntEmiULbZrN4xNjPQEN1Sp
         xHAQmPCxTWDww==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: Re: [MPTCP][PATCH net-next] mptcp: clear use_ack and use_map when
 dropping other suboptions
Message-ID: <20201216162239.4310d998@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fd9ba263-de65-75e4-d62e-8bdf9236bf5@linux.intel.com>
References: <ccca4e8f01457a1b495c5d612ed16c5f7a585706.1608010058.git.geliangtang@gmail.com>
        <fd9ba263-de65-75e4-d62e-8bdf9236bf5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 16:11:52 -0800 (PST) Mat Martineau wrote:
> On Tue, 15 Dec 2020, Geliang Tang wrote:
> 
> > This patch cleared use_ack and use_map when dropping other suboptions to
> > fix the following syzkaller BUG:

> > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > Fixes: 84dfe3677a6f (mptcp: send out dedicated ADD_ADDR packet)
> > Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> > ---
> > net/mptcp/options.c | 2 ++
> > 1 file changed, 2 insertions(+)
> >  
> 
> David or Jakub, this patch is intended for the -net tree (not net-next as 
> labeled in the subject line). If you can apply it to -net, that's great, 
> otherwise it can be resubmitted as [PATCH net].
> 
> In any case, the content is good:

Should matter all that much other than for build testing.

> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Applied, thanks!
