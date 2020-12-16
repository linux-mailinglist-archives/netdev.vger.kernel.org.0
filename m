Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C642E2DB93D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgLPCgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgLPCgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 21:36:51 -0500
Date:   Tue, 15 Dec 2020 18:34:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608086058;
        bh=DrVKbI1Cu2A/i5wIKUKAwE1tjxS3INOb56RKhbyX8Ng=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=q0gA14nFDeO4qOTuDYbsczOEZJZUfFqOPL6eLdKLJ0klfFy2e+pgB8wSZ+pEy+7aI
         bU9thi3ueRMfmii9LHMrBMGf6nmCkDmW1K3HLn0hw3mfAialVNwyaT7cpdbUoa7+X7
         5DazpIXVQGzwJjnwj4Bx4BEG6KS4NCfhV7EJ+tvjGtGX7G1phIjk+eUEJAD4zFFV4G
         YYzQ8je7qUBkoiYzTqym9xxDA6uMYcXf0ng5luU/+lXfi8TRqLTlaHEQE+VakCP3AZ
         S0WnxFpOmRhX4fyUvCZnFFPOfLWouDcB5JOANHDC32LXj4EuixgZSfHVFBE0xe1Xb7
         iDywdw3lm6KRg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pravin B Shelar <pbshelar@fb.com>
Cc:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        <laforge@gnumonks.org>, <jonas@norrbonn.se>, <pravin.ovn@gmail.com>
Subject: Re: [PATCH net-next v3] GTP: add support for flow based tunneling
 API
Message-ID: <20201215183417.48e7e336@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201213192943.53709-1-pbshelar@fb.com>
References: <20201213192943.53709-1-pbshelar@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Dec 2020 11:29:43 -0800 Pravin B Shelar wrote:
> Following patch add support for flow based tunneling API
> to send and recv GTP tunnel packet over tunnel metadata API.
> This would allow this device integration with OVS or eBPF using
> flow based tunneling APIs.
> 
> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>

We didn't get a review from Jonas & co in time for 5.11, please
continue the reviews and repost for applying when net-next opens.
