Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649D1397BF8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhFAV7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 17:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234910AbhFAV7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 17:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A11560FDC;
        Tue,  1 Jun 2021 21:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622584650;
        bh=fJ6NP8UYU0ijARIBR2mILsHdNNwbEZDCoLr1vljs1GY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YPKPPAUAdaC8+qa85SwchWxDX0eVQMqg2QA3VxRfbH0qI5lTQY15MWCsdYjBRJH4c
         MZPBzAe2UxETcXTBl16pWHdK0blciCmFfQbUTM5tjKcgNyJ3Ryf9ozTM3ioitoCc1f
         BmPeOvIxEuTZRiL+IoG081MLdbYMxEPnv/xM8EyTJZW1wcEFRI1nyYIG5OPcyWsQ3q
         rH2YGgvfzPXcQlGQApM2I++2gnS1pR56jS/gPSs3n7oOu4MCCXmVMxENnODMW2i+ta
         ZQwKl96CYlV0pPYAhtVBZFQ2acfH6P/z111Hsslj6nLtdcX6vZbxTCcXxyJm/DsKCZ
         Dp9LU7ATmKFAQ==
Date:   Tue, 1 Jun 2021 14:57:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 0/2] Fix use-after-free after the TLS device goes
 down and up
Message-ID: <20210601145729.530fb257@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210601120800.2177503-1-maximmi@nvidia.com>
References: <20210601120800.2177503-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 15:07:58 +0300 Maxim Mikityanskiy wrote:
> This small series fixes a use-after-free bug in the TLS offload code.
> The first patch is a preparation for the second one, and the second is
> the fix itself.

Acked-by: Jakub Kicinski <kuba@kernel.org>
