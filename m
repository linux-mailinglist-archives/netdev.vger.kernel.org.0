Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C128229457A
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410636AbgJTXj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:39:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410628AbgJTXjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:39:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31FF21707;
        Tue, 20 Oct 2020 23:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603237165;
        bh=n9aCd2Cgavm3YeJuDMiF/B+SgeCWyVYaIMdIW8LaJ3g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FO1ZbEFM74JbSXV3TjmN9Tu9CGSB2EHb2FIqoGJYOtlnei696feJb9C9ADcrvrYDJ
         ETLri0gnA37TWUgUp1Gp34zyOzZc8X/eUDS/ykDColRTsB2+aqDcD9jF0F49H8AX3u
         T3Od7wKtZR48Ys8GI70CR+vBBySx6GNG8XfzStls=
Date:   Tue, 20 Oct 2020 16:39:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 0/2] init ahmac and port of
 mptcp_options_received
Message-ID: <20201020163923.6feef9ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1603102503.git.geliangtang@gmail.com>
References: <cover.1603102503.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 18:23:14 +0800 Geliang Tang wrote:
> This patchset deals with initializations of mptcp_options_received's two
> fields, ahmac and port.

Applied, but two extra comments:
 - please make sure the commit messages are in imperative form
   e.g. "Initialize x..." rather than "This patches initializes x.."
 - I dropped the Fixes tag from patch 2, and only queued patch 1 for 
   stable - patch 2 is a minor clean up, right?

Thanks!
