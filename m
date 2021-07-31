Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB423DC6E4
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 18:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhGaQXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 12:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhGaQXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 12:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5958B60EB2;
        Sat, 31 Jul 2021 16:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627748590;
        bh=191/84+0rTJdsFr5LCCBl9qrYtdVVFfE5JHLy/y0B/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=piS13HvHnC0M7hdsZkWFvVluW7UQXE/1OEDO1TxW2ltjBzdzYLElnEruJemHRVjeH
         /Gi3yOBboXYVRKvvKVvzsunXYz3jEoO35+HMTQw11DWwKtFwytxAb8VKl493AVqT2Y
         RTDLzP0c2irFJDmiAL5NsKvcIi52qT7UYRaIx/1c4GI9wqDd8s8cit0cBkaiTpLm/W
         moa0oFMHjdKKVr7SqVQXAONYqBoThn+JIAarf6FPjQYGLW/tPX7013umJUAhh1H1Vl
         +RTI/c5mDdnGBYckS81thTlSdUAc2FZKhZsV7v2TBqmwzx8P8CRHxoKEtFe8oGII+G
         dq5p7S+pYcYFQ==
Date:   Sat, 31 Jul 2021 09:23:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Hao Chen <chenhaoa@uniontech.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [net,v7] net: stmmac: fix 'ethtool -P' return -EBUSY
Message-ID: <20210731092309.487bc793@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8d1b5896-da9f-954f-6d43-061b75863961@gmail.com>
References: <20210731050928.32242-1-chenhaoa@uniontech.com>
        <8d1b5896-da9f-954f-6d43-061b75863961@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Jul 2021 11:35:58 +0200 Heiner Kallweit wrote:
> If there's an agreement that this makes sense in general then we may add
> this to core code, by e.g. runtime-resuming netdev->dev.parent (and maybe
> netdev->dev if netdev has no parent).

Sounds very tempting to me.
