Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9745423563
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbhJFBUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236969AbhJFBUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 21:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D0E361039;
        Wed,  6 Oct 2021 01:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633483125;
        bh=jev+92Svr+eHiHQmNyBwbvYhDXVKGGNDVpk1u+yrq7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M+PN73ZD+72/nCxteJ4H4MbR+Y0e2ARO4z9wrDzjKRwzUKI3V2EUL8503bXwPhs1m
         l4rZy/dRIr0YqZtw/vuRi1hCFcKnuRkcO7SpOFM7dWncBFp6ttIQlE/gQCeICOZIHb
         wujn2EaozMCQy1MVeBrUMsbio+drFr/g4J6dzSqz6U/aOa6b58o44mm7GLLnksT/8m
         iEVVfe7v6Akzll5ePaY85XIUOzAvz9UL8Symp0lXFCkwTxS47CfW6tXRqSHyIggjRS
         RbBajU+TO2+/bDYk9VksF6lTNiSevKluilsQ9UvVZW9a94NW/If8MIhEEdkXqVE1Xx
         xpjZXwYXHHNWA==
Date:   Tue, 5 Oct 2021 18:18:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Catherine Sullivan <csully@google.com>
Subject: Re: [PATCH net 1/3] gve: Correct available tx qpl check
Message-ID: <20211005181843.35a416c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211005232823.1285684-1-jeroendb@google.com>
References: <20211005232823.1285684-1-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Oct 2021 16:28:21 -0700 Jeroen de Borst wrote:
> Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
> 
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>

No empty line between Fixes and the other tags. Please fix & repost.
