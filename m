Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EA12E3EF0
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 15:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505169AbgL1Oe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 09:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392124AbgL1OeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 09:34:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B120E2053B;
        Mon, 28 Dec 2020 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166001;
        bh=6RGno5ibxsEVrCmP0hIDVmZGDPl9aM9x8/+n66dQOeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ftJGlQMJdFuHikam5nxgu3/0l15k6TLy9khePWtaQpGSkwj8k7DTE9qEWsFl90GeG
         KW/m4VgVfDVC1qNmqAnk7MK6E4GC8YQX4njZnTEWYJzpmU8trqFy6HdnQGX1fBvPT+
         ojtRlYVAw10W90tYIt0VwtE3E23pXZIEoYu4yano=
Date:   Mon, 28 Dec 2020 15:07:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel West <daniel.west.dev@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Daniel West <daniel.s.west.dev@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Removed duplicate word in comment.
Message-ID: <X+nmlde/B1Y3cAuj@kroah.com>
References: <20201219014829.362810-1-daniel.west.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219014829.362810-1-daniel.west.dev@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 05:48:29PM -0800, Daniel West wrote:
> This patch fixes the checkpatch warning:
> 
> WARNING: Possible repeated word: 'and'
> 
> Signed-off-by: Daniel West <daniel.s.west.dev@gmail.com>

signed-off-by does not match From: line, so I can't take this :(

Please fix up and resend.

thanks,

greg k-h
