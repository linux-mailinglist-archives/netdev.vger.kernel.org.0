Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D992983BD
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 22:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418954AbgJYVq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 17:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409790AbgJYVq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 17:46:29 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E4D622282;
        Sun, 25 Oct 2020 21:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603662388;
        bh=tNwCA6la6NRFuaep+cADLg5ae+gzdtW5y0TxCLjbOnI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HM1RgJXH7/htY3H9uwdo0ATHelZz5GBJW9M4EP+mHFIOL47cRbRW198wZ2nlJqSJL
         tX4fx6/ptN18SIM891Mv/8my5L1XKy94xwjfvMpQRTRQWiRgkn47l+/Fsf3nw38K4a
         axQaKXaPLxYrSPLw0vpNpnt5ed/b6dSTQdyrXj7w=
Date:   Sun, 25 Oct 2020 14:46:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [PATCH v9 3/4] docs: Add documentation for userspace client
 interface
Message-ID: <20201025144627.65b2324e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1603495075-11462-4-git-send-email-hemantk@codeaurora.org>
References: <1603495075-11462-1-git-send-email-hemantk@codeaurora.org>
        <1603495075-11462-4-git-send-email-hemantk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 16:17:54 -0700 Hemant Kumar wrote:
> +UCI driver enables userspace clients to communicate to external MHI devices
> +like modem and WLAN. UCI driver probe creates standard character device file
> +nodes for userspace clients to perform open, read, write, poll and release file
> +operations.

What's the user space that talks to this?
