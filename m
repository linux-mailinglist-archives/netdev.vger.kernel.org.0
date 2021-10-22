Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05D4437B74
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhJVRI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233356AbhJVRI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A73A060E0C;
        Fri, 22 Oct 2021 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634922398;
        bh=YJqdRrfn6iO0lUbojxc3EQrA3M3RvkY93cCyifMdrN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EfnO5uu7GFrgyeyxYu5rV3VSJmbRR5SZsWwlY28Wy92ZMKT4/czgkhc3vOvy0WSTw
         f7J2EGWWAL3Gf/9vSgA5hC0jPgYf8+ySJ5rhIkIOTLMKgsEKaKHNSPWnUOImnBrFqh
         wffvu8bxq0Py0LsgdYBiWqMuAijt8PoqZsm2FNpv7K1pS1M9+fA3w0HcLEq5ZfTgx+
         lkBLETaJoVbpC2tnU9EicsP/cIgUGkZKaI0rj+Bdt4LbHLYoFa9z3vPDXZcypEVPXJ
         D9YF7o1aENVLDNnnIWQCgEMTp9VQerF7bb9UTfUf6UBr9FIvqIb02wPR+HqbIl4j1Q
         OY03JpvJoCUxg==
Date:   Fri, 22 Oct 2021 10:06:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH v2] net: phylink: Add helpers for c22 registers
 without MDIO
Message-ID: <20211022100637.566fcdb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211022160959.3350916-1-sean.anderson@seco.com>
References: <20211022160959.3350916-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Oct 2021 12:09:59 -0400 Sean Anderson wrote:
> This series depends on [2].

You should have just made it part of that series then. Now you'll have
to repost once the dependency is merged.
