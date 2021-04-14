Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4666A35FE73
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbhDNXcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhDNXcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0402061131;
        Wed, 14 Apr 2021 23:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618443098;
        bh=Wq5EgiETikq97njoeqZYKcxb8kQJjI930NFEm4ZOfb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hNTlOKNXAcodUOx1mkw3TYAkg/ORQdCfdkJ69SoGpAT05nP6OfFXNPcE51mnWpeoF
         utLLb+CShV5QCQy01eVrM3WIYx5K1sSPsbx30wZcXNvw6qAd2fhgGUH1Mj6b7B6JyD
         3uTOcLDH7RA1WoINrQQmK48IIQQLLki05SfNH0A8lcaYjQm0wwxdUweqkai//GT/6M
         jytiEm2KhRYKgRhOai+baXL8soe5VkC3EYT8p7VPwEy0CXYMzDV4I2dj7D13AfkJKE
         snbaJxpLZO0sp9XjGE1IYwc20vwuSUecaWjqpzVNHm1mYZSoFSs4+a59lelaFW7v6H
         diyxBJQHmtOkA==
Date:   Wed, 14 Apr 2021 16:31:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net 0/3] mlx5 fixes 2021-04-14
Message-ID: <20210414163137.76f51162@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210414231610.136376-1-saeed@kernel.org>
References: <20210414231610.136376-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 16:16:07 -0700 Saeed Mahameed wrote:
> This series provides 3 small fixes to mlx5 driver.
> Please pull and let me know if there is any problem.

FWIW a little more info on user-visible misbehavior on patch 2 would
have helped.

Acked-by: Jakub Kicinski <kuba@kernel.org>
