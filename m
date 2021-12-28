Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDC0480DFC
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 00:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbhL1Xyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 18:54:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60108 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbhL1Xyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 18:54:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54B3BB808CF;
        Tue, 28 Dec 2021 23:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EEFC36AEC;
        Tue, 28 Dec 2021 23:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640735675;
        bh=Cd+vCGWXVUexZihsjOT5+/8eHjF77KFyeP2BJSmdcVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bFpNWBO6l2Zybqoz7RJPz6rNxUsOKLQEdw2w3zNSNA7JRIXcgcvGILXD+ZDBpTvAF
         OTDzuIRFeCkw6hSKPOBQ8QfGXPFfPuheX8BX3lk6OocQxNKH65vSgO+NedhWJmO+5p
         SCmqVDwjUzjvgXNW0DRdFKH/73dbOEvDdsv815TULzaWK5POSsXgvZXtw6VDVoKj32
         ieGYYgxz1n/yJ9SwVHwYotBv9TNWdcDufslXDAwxjS+QeYDYoh95HHSYdeCttpBBtK
         Vz+ETKHVbvrls6HqMAOitd7x3qVIvZF3AWGcWzWHyGgfzJiPUnddDe7Bs08kdnxuLh
         oErqVcEYd03Pw==
Date:   Tue, 28 Dec 2021 15:54:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tamir Duberstein <tamird@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: check passed optlen before reading
Message-ID: <20211228155433.3b1c71e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAJ-ks9=41PuzGkXmi0-aZPEWicWJ5s2gW2zL+jSHuDjaJ5Lhsg@mail.gmail.com>
References: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
        <CAJ-ks9=41PuzGkXmi0-aZPEWicWJ5s2gW2zL+jSHuDjaJ5Lhsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 16:02:29 -0500 Tamir Duberstein wrote:
> Errant brace in the earlier version.
> 
> From 8586be4d72c6c583b1085d2239076987e1b7c43a Mon Sep 17 00:00:00 2001
> From: Tamir Duberstein <tamird@gmail.com>
> Date: Tue, 28 Dec 2021 15:09:11 -0500
> Subject: [PATCH v2] net: check passed optlen before reading
> 
> Add a check that the user-provided option is at least as long as the
> number of bytes we intend to read. Before this patch we would blindly
> read sizeof(int) bytes even in cases where the user passed
> optlen<sizeof(int), which would potentially read garbage or fault.
> 
> Discovered by new tests in https://github.com/google/gvisor/pull/6957 .
> 
> Signed-off-by: Tamir Duberstein <tamird@gmail.com>

Your patches are corrupted by your email client.

Can you try sending the latest version with git send-email?
