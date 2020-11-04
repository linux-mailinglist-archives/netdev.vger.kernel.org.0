Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4EC2A5C6C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgKDByv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgKDByv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:54:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5F8223EA;
        Wed,  4 Nov 2020 01:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454890;
        bh=0FnDEIhCNVIg+PAvUk3GuQ8egEITq6gQO8nNLPIb7qw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eEAilex7QZsR8/IqVwWN4bBX5XRUDpEztZVtlTmcH2hPBDE35i0MY05In/VPkfFVW
         yUVDMnO6kSvaIqJms9HskyIc6cX9Ch59GawmGzqimPFWXTUqjYCyYCR+INJWxYI7W9
         dFT6MymhO0CaGcASO3FtpkQe2ChqiQzmKw2C7dDs=
Date:   Tue, 3 Nov 2020 17:54:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH net-next] chelsio/chtls: Utilizing multiple rxq/txq to
 process requests
Message-ID: <20201103175449.6063f9f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102162832.22344-1-vinay.yadav@chelsio.com>
References: <20201102162832.22344-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 21:58:33 +0530 Vinay Kumar Yadav wrote:
> patch adds a logic to utilize multiple queues to process requests.
> The queue selection logic uses a round-robin distribution technique
> using a counter.
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied thanks!
