Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FD02B6EF9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbgKQTm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgKQTm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:42:26 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EBBF22240;
        Tue, 17 Nov 2020 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605642146;
        bh=YbJvILkvf8lCXj8XwrKNQtfr2sGjPnWQ8m4G2jFh55A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VP+wv2YC26no7HSFhvoxh7DkR+FmYoSWFxTA+h/2Eb0q6FLKKQqB6bOZXaWdXr990
         a9MNuGAvUtSmfST3Zm7bIsZIz3bMcPt95dni0+F+sSWFyrqWlVOuVP8f/HYVEYlPtR
         ZlD3/pWn3T0Dj6iA9yqUHbKFIsvojC8FiySNyQIE=
Date:   Tue, 17 Nov 2020 11:42:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V4 net-next 0/4] net: hns3: updates for -next
Message-ID: <20201117114224.297162ee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1605514854-11205-1-git-send-email-tanhuazhong@huawei.com>
References: <1605514854-11205-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 16:20:50 +0800 Huazhong Tan wrote:
> There are several updates relating to the interrupt coalesce for
> the HNS3 ethernet driver.
> 
> #1 adds support for QL(quantity limiting, interrupt coalesce
>    based on the frame quantity).
> #2 queries the maximum value of GL from the firmware instead of
>    a fixed value in code.
> #3 adds support for 1us unit GL(gap limiting, interrupt coalesce
>    based on the gap time).
> #4 renames gl_adapt_enable in struct hns3_enet_coalesce to fit
>    its new usage.
> 
> change log:
> V4 - remove #5~#10 from this series, which needs more discussion.
> V3 - fix a typo error in #1 reported by Jakub Kicinski.
>      rewrite #9 commit log.
>      remove #11 from this series.
> V2 - reorder #2 & #3 to fix compiler error.
>      fix some checkpatch warnings in #10 & #11.

Applied, thanks!
