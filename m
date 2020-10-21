Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F81294767
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440194AbgJUE0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407024AbgJUE0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 00:26:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F2A121BE5;
        Wed, 21 Oct 2020 04:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603254406;
        bh=2uI/mGJuDPA+u9uDaJGW+6WHfe74UZy2d+9LyDOLe+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YjHCeqOq2Dz696ih4UPrvNquZzSm3NfiLSWix4cVNISndykhKUsqcxjAO6aVkC27b
         OFCrbE7X/nY8g+VmtEHbBUlJ8uk1c3ttFmRANr97Hl/epx2t6TmD5c/020xwXBubX5
         GR88h2nX4uEbDH0Dkiy/pGc+UaHz6XNF6PoHz+RA=
Date:   Tue, 20 Oct 2020 21:26:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH net] chelsio/chtls: Utilizing multiple rxq/txq to
 process requests
Message-ID: <20201020212644.7b25b036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020194305.12352-1-vinay.yadav@chelsio.com>
References: <20201020194305.12352-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 01:13:06 +0530 Vinay Kumar Yadav wrote:
> patch adds a logic to utilize multiple queues to process requests.
> The queue selection logic uses a round-robin distribution technique
> using a counter.

What's the Fixes tag for this one?
