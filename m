Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FD42BA214
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgKTFzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbgKTFzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 00:55:35 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4AEF22256;
        Fri, 20 Nov 2020 05:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605851735;
        bh=OVGbqnwRuRqF+fnbblqTgJRIYZ4swPbdDzRcw52EsDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=knqjotXzauVgMJ0z1QUc9zgVxAy2KO7V+QBb2BpNRATTEY5p3LSlUqPc/Fj8ev6Dm
         dHwU/8wiAmt7RTH2d6g94VkGYhnbGnpYXnDFIRAJzUuljwQ1tPGfStc3X1hIMkK5qi
         iEs5A20sIts3WN31l4jH1XdRM2QJ8UWDhqZR/R7c=
Date:   Thu, 19 Nov 2020 21:55:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next] mptcp: update rtx timeout only if
 required.
Message-ID: <20201119215533.1dff6751@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CA+G9fYstUYSeXh=w2YSmytHfBg2=tnwyAx_hCJtn2Dfi_Ts91g@mail.gmail.com>
References: <1a72039f112cae048c44d398ffa14e0a1432db3d.1605737083.git.pabeni@redhat.com>
        <d69c8138-311b-f94e-74b8-1e759846eec0@linux.intel.com>
        <CA+G9fYstUYSeXh=w2YSmytHfBg2=tnwyAx_hCJtn2Dfi_Ts91g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 19:49:16 +0530 Naresh Kamboju wrote:
> > > We must start the retransmission timer only there are
> > > pending data in the rtx queue.
> > > Otherwise we can hit a WARN_ON in mptcp_reset_timer(),
> > > as syzbot demonstrated.
> > >
> > > Reported-and-tested-by: syzbot+42aa53dafb66a07e5a24@syzkaller.appspotmail.com
> > > Fixes: d9ca1de8c0cd ("mptcp: move page frag allocation in mptcp_sendmsg()")
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> >
> > Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>  
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Applied, thanks!
