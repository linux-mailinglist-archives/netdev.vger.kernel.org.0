Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DD92DB241
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgLORLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:11:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbgLORLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 12:11:38 -0500
Date:   Tue, 15 Dec 2020 09:10:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608052258;
        bh=G2jtOvEBd3yB2yqPEyZS7PKkvMk1f3sE9MPqV6hgxSc=;
        h=From:To:Cc:Subject:From;
        b=EA3l9ONE5SF4FqkK1jn6yOOYkMI2Za6M9uI9KTOTMvc8rJ/sIWh+3BR8Hr63Fsweh
         oio6pfAxWv1rBuUzJ1fJI27yNLZAVolico0S1SXVGVmW2rCnPn0Lx9Gi0M3bkITY0G
         DCsLsQQUHFu4iweR14LHaDm89KHBb/DIlUkg+nNI08ejAcOpHA9JhpeqYVQLZA9hp6
         KHNUxenRBWmHZnUo3PFtgqpvkOh/y9NZXzuYJcfZZ2zkzmedvfRIZZVGYha51ab4Zj
         MrEEXmhRGAC4pIj9NbM9lNNj6R+qPFU6jnNJNTSMZhvOkduwmfWF92MhSM/6TfqT7l
         +Opus1hpYA/Dg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
Subject: net-next is CLOSED
Message-ID: <20201215091056.7f811c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 5.10 PR went out yesterday, you know the drill.

There are a few things (Vladimir's DSA+non-DSA bridging series, mlx5 SF
patches, Intel's S0ix fixes, Octeon multi-group RSS, threaded NAPI)
which we may include in the Thu PR if there is enough confidence.
Any other new feature should be posted as RFC at this point.


Thanks!
