Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B15731982A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBLCCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhBLCCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:02:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A984D64DB1;
        Fri, 12 Feb 2021 02:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613095285;
        bh=bjSmt4LcyaNgriplnN4Wf43bH+zYvXujX+y93awse0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e32EY8WIPUY9JdiSsg5LSGBrQ5ZFlFW2jq90sEbbmhvEyDpEUyYyTfTHNLrYlY7nl
         CPLka4ZEwq5A3R1RvWjtWcvCTQrcfI+90z8JYi44SES3zLo5sIJy5/AeYBM1iblWmW
         P3j6qkrl+AbJ9wvLDGwdvcRkszrSnboCoGG/a8dUcrF/KuddJTxrQbCHAiAuH246GS
         S9Quy+KltMZ+Ix/AtgvnYM4gMlV9T/ih0jq/UTrvm336PgcPy7Ef/ljlGfBQhmyydL
         0/F4Gh4HMBYMFy2yCwK6lv3qSBKiTOWUixN0IOT2ZWJfzTzt0MEa0hFpWkVPfirU+I
         SUzwPuQk/aRvQ==
Date:   Thu, 11 Feb 2021 18:01:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next 0/3] Compile-flag for sock RX queue mapping
Message-ID: <20210211180123.12f508b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210211113553.8211-1-tariqt@nvidia.com>
References: <20210211113553.8211-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Feb 2021 13:35:50 +0200 Tariq Toukan wrote:
> Socket's RX queue mapping logic is useful also for non-XPS use cases.
> This series breaks the dependency between the two, introducing a new
> kernel config flag SOCK_RX_QUEUE_MAPPING.
> 
> Here we select this new kernel flag from TLS_DEVICE, as well as XPS.

Acked-by: Jakub Kicinski <kuba@kernel.org>
