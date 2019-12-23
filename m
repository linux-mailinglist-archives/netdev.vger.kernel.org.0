Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E16612922C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 08:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfLWHTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 02:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfLWHTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 02:19:08 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6675C20709;
        Mon, 23 Dec 2019 07:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577085548;
        bh=coUjc3nyCvnKXY2JIYD9Ih/9Z6YPEO6I+KFoj7UNtvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=utrjAipPhuA7unBn13+xrXb7tjBBZaD/NcY5BgGQ93zKKp34vjT3n/443WKPa2W/G
         78eTP4IpI8NyENXYNgmQv+UcfDc2i0erdxTLs3Fo5ZGGuAgG2DkFAbKahTykZnxtvi
         AWiAZfBSPCiKEyGtk8q0lNPpP7CsYzXDYb/cR6JU=
Date:   Mon, 23 Dec 2019 09:19:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] dpaa_eth: fix DMA mapping leak
Message-ID: <20191223071904.GI13335@unreal>
References: <1576764528-10742-1-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576764528-10742-1-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 04:08:48PM +0200, Madalin Bucur wrote:
> From: Madalin Bucur <madalin.bucur@nxp.com>
>
> On the error path some fragments remain DMA mapped. Adding a fix
> that unmaps all the fragments.
>
> Fixes: 8151ee88bad56 (dpaa_eth: use page backed rx buffers)

This line should be
Fixes: 8151ee88bad5 ("dpaa_eth: use page backed rx buffers")

Thanks
