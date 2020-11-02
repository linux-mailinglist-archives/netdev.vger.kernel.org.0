Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D12A3713
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgKBXWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgKBXWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:22:38 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C65E22268;
        Mon,  2 Nov 2020 23:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604359358;
        bh=p7hRaeJ7MBCpIPJ6kNQ06Tfoq61AemIyJEEcKqliNg0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MiifzfsgYFrNrgUqp/Gm+c2hGpogn7sTDrwpiPg6yX3rl2X8g6dDsUImrlljlE3ba
         e8C21BSVu+81YPNX4MSgEWf/KQGAAqZyHR5Q77N/RAw7RJ7Rbbd39spjRAuryx7uUB
         nKcbcr7goPfRQz0Hbt7CkHeAXpBL22R2F3Pp1ago=
Date:   Mon, 2 Nov 2020 15:22:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 net-next] selftests: add test script for bareudp
 tunnels
Message-ID: <20201102152237.07e08859@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <8abc0e58f8a7eeb404f82466505a73110bc43ab8.1604088587.git.gnault@redhat.com>
References: <8abc0e58f8a7eeb404f82466505a73110bc43ab8.1604088587.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 21:10:54 +0100 Guillaume Nault wrote:
> Test different encapsulation modes of the bareudp module:
>   * Unicast MPLS,
>   * IPv4 only,
>   * IPv4 in multiproto mode (that is, IPv4 and IPv6),
>   * IPv6.
> 
> Each mode is tested with both an IPv4 and an IPv6 underlay.
> 
> v2:
>   * Add build dependencies in config file (Willem de Bruijn).
>   * The MPLS test now uses its own IP addresses. This minimises
>     the amount of cleanup between tests and simplifies the script.
>   * Verify that iproute2 supports bareudp tunnels before running the
>     script (and other minor usability improvements).
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks!
