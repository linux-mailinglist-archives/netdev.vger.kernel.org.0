Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FBF28D8CB
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 05:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgJNDDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 23:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgJNDDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 23:03:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FEED21D81;
        Wed, 14 Oct 2020 03:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602644609;
        bh=UOF+zmDIyS2kNQpi+e1CPAkhCAQ1aICl6nPD8S8F8Ok=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lhC03TnKEZ+rOS0rRrHC1tj61fEvrT5svmxtRQrE8fY7XBb44S8y0Rdiln2sbBWn7
         Hvt0VU3MXGxEbr7q1mZPcmcE23J0RcCsfIgcqJyG8fmvV1mGLrG7+tqSJPGMJ0TM/m
         iYQ+O6XDBdisqxJVc97eZm+rKc7bVHhX/a1L7Uts=
Date:   Tue, 13 Oct 2020 20:03:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [pull request][net-next 0/4] mlx5 updates 2020-10-12
Message-ID: <20201013200328.0273638c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012224152.191479-1-saeedm@nvidia.com>
References: <20201012224152.191479-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 15:41:48 -0700 Saeed Mahameed wrote:
> Hi Jakub,
> 
> This small series add xfrm IPSec TX offload support to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks!
