Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5AB2A5898
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbgKCVwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbgKCVwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 16:52:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0660F207BB;
        Tue,  3 Nov 2020 21:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604440367;
        bh=yq0hA5mYAEbgS4k9z/Zgrv/PfNCrksXkirZCMPCdKAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dipVUpBn6fepWKOLgt8ihf92oHwmc9fsMGFIhMrRiNdXGmi1vOKRDRIdic4zZXrRd
         GEQRhbkdsuUo8YMfUuytQNIzMHT7ATfIqV3owE3M3MYM6cuSRb6htMYUfD0O80+LKa
         +OPRtFqhQlLqWXaVeY6LWCDskIKs9S1/AxayEbV0=
Date:   Tue, 3 Nov 2020 13:52:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] chelsio/chtls: fix memory leak
Message-ID: <20201103135246.273e33cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102173909.24826-1-vinay.yadav@chelsio.com>
References: <20201102173909.24826-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 23:09:10 +0530 Vinay Kumar Yadav wrote:
> Correct skb refcount in alloc_ctrl_skb(), causing skb memleak
> when chtls_send_abort() called with NULL skb.
> it was always leaking the skb, correct it by incrementing skb
> refs by one.
> 
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied the two memory leak fixes, but I had to adjust the subjects.
They were too similar.

Thanks!
