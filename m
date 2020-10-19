Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAA7292F97
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 22:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731055AbgJSUkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 16:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgJSUkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 16:40:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2E54223EA;
        Mon, 19 Oct 2020 20:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603140051;
        bh=Uw6z0L+vbpRHU1EORPmt0ZY0vv0X5pRrlNUeifp5qyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bk2f+AkhiG3y/v0+VBUoC4vhpjsi0qG02mroI4Hte7txqcWnTW14nin9Wx5mvw7ZD
         QIcqBv80EOyHYqU830qa9ee3fim4O4xrrj/HC2kaRw/YyhmeuVpUVmQi+JTxmQ/D5j
         iEdofx+d1lbgwpYzotdIllt3u3A4imb7VepOvXNM=
Date:   Mon, 19 Oct 2020 13:40:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 0/2] init ahmac and port of
 mptcp_options_received
Message-ID: <20201019134048.11c75c9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7766357d-0838-1603-9967-8910aa312f65@tessares.net>
References: <cover.1603102503.git.geliangtang@gmail.com>
        <7766357d-0838-1603-9967-8910aa312f65@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 18:27:55 +0200 Matthieu Baerts wrote:
> Hi Geliang,
> 
> On 19/10/2020 12:23, Geliang Tang wrote:
> > This patchset deals with initializations of mptcp_options_received's two
> > fields, ahmac and port.
> > 
> > Geliang Tang (2):
> >    mptcp: initialize mptcp_options_received's ahmac
> >    mptcp: move mptcp_options_received's port initialization  
> 
> Thank you for these two patches. They look good to me except one detail: 
> these two patches are for -net and not net-next.
> 
> I don't know if it is alright for Jakub to apply them to -net or if it 
> is clearer to re-send them with an updated subject.
> 
> If it is OK to apply them to -net without a re-submit, here is my:
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Thanks, I can apply to net.

> Also, if you don't mind and while I am here, I never know: is it OK for 
> you the maintainers to send one Acked/Reviewed-by for a whole series -- 
> but then this is not reflected on patchwork -- or should we send one tag 
> for each patch?

It's fine, we propagate those semi-manually, but it's not a problem.
Hopefully patchwork will address this at some point :(
