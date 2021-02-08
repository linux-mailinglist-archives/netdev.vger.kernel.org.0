Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03033313F21
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhBHTf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236233AbhBHTe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:34:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C1964E85;
        Mon,  8 Feb 2021 19:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612812854;
        bh=Hda5g27XxqDzZGVXPj20TU+wNYDR/3oc+nq5MIWbJuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hX6hakVR8/ylyM+DRkC7mcD39vnes0+aIsnHMwcyNjPwSpnrg+bhkWNiBLlWJNg6/
         P/G1MzQyq5w1c0P7N/3xigpWW4eGhZFpalNL/lJ+6iVzg5UnkwNYWiAUlySdudtLIj
         xW+RouCLlKAKV1aO1llRKtos+W1bi3sJfSQASMm32ZyPnwEB3rUT1ZLxvy/axe8eeV
         wwKmhHOF8J46XTwfEgvVibpMm8eONZbg08OUb/b8nVFR7RxoMoDbArFwKq/+2ULQqG
         avZ8CuXoCF09arzDbm1BndT0A6VabaXY96Y1qznHryFwF8mMPQ/7tfIUqTDHMkE5lc
         /aHKZoEFZFDqQ==
Date:   Mon, 8 Feb 2021 11:34:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/4] pull request for net-next: batman-adv 2021-02-08
Message-ID: <20210208113412.519c9704@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208165938.13262-1-sw@simonwunderlich.de>
References: <20210208165938.13262-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 17:59:34 +0100 Simon Wunderlich wrote:
> Hi Jakub, hi David,
> 
> here is the updated pull request of batman-adv to go into net-next. We
> have updated the first two patches as discussed (added justification
> for the first, replaced the second to remove copyright years). The other
> two patches are unchanged.
> 
> Please pull or let me know of any problem!

Pulled, thank you!
