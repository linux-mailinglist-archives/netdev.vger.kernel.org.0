Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2650E436A59
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhJUSS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:18:26 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35048 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhJUSSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 14:18:25 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6E3ED63F37;
        Thu, 21 Oct 2021 20:14:25 +0200 (CEST)
Date:   Thu, 21 Oct 2021 20:16:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][net-next] netfilter: ebtables: use array_size() helper
 in copy_{from,to}_user()
Message-ID: <YXGuY2LjiBb5M+jn@salvia>
References: <20210928200647.GA266402@embeddedor>
 <202110210958.6626A30@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202110210958.6626A30@keescook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 10:00:34AM -0700, Kees Cook wrote:
> On Tue, Sep 28, 2021 at 03:06:47PM -0500, Gustavo A. R. Silva wrote:
> > Use array_size() helper instead of the open-coded version in
> > copy_{from,to}_user().  These sorts of multiplication factors
> > need to be wrapped in array_size().
> > 
> > Link: https://github.com/KSPP/linux/issues/160
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Thanks!
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> I see that this is marked "Awaiting Upstream" (for an ebtables
> maintainer ack?)
> https://patchwork.kernel.org/project/netdevbpf/patch/20210928200647.GA266402@embeddedor/

I'll route this through the netfilter tree, thanks.
