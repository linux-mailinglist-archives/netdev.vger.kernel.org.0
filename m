Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD642BA197
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 05:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKTE5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 23:57:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKTE5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 23:57:50 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 055662236F;
        Fri, 20 Nov 2020 04:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605848270;
        bh=5l+yBiOCrE6YbebNU/Iv7XTpl332n88sDeBXs+5md+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qSYRlUjMA3GjAadYsPvIB1KwK+JfFPiER8RWNH9P+jQNS0GB5oPTOJwJI8JVm/gQe
         XEQEfWsTaQBxIYw7i/WJa92MXWWGUI7jizUuJwQkg9JWYxZkqTJ4Jod7GMcHVbVjoj
         5FIcA8Y4tMcSQT0IbV6bPJKDfs9P8ZhChZWABmTc=
Date:   Thu, 19 Nov 2020 20:57:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     nusiddiq@redhat.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v2] net: openvswitch: Be liberal in tcp
 conntrack.
Message-ID: <20201119205749.0c3eaf8b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201116130126.3065077-1-nusiddiq@redhat.com>
References: <20201116130126.3065077-1-nusiddiq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 18:31:26 +0530 nusiddiq@redhat.com wrote:
> From: Numan Siddique <nusiddiq@redhat.com>
> 
> There is no easy way to distinguish if a conntracked tcp packet is
> marked invalid because of tcp_in_window() check error or because
> it doesn't belong to an existing connection. With this patch,
> openvswitch sets liberal tcp flag for the established sessions so
> that out of window packets are not marked invalid.
> 
> A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
> sets this flag for both the directions of the nf_conn.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Numan Siddique <nusiddiq@redhat.com>

Florian, LGTY?
