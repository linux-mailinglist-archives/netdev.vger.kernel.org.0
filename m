Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCC6488113
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiAHDWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:22:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54778 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiAHDWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:22:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91F9D6201E
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59DAC36AE0;
        Sat,  8 Jan 2022 03:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641612123;
        bh=4GzIY0ljv9AW6N0UClYd6kKAdCa39eEYRz4EIA8wuoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pYXyuaorg1QeDc+dopbONhWLc/VQ/NyIrSlUqtnFGBjQLsu6rv9sZaZnN2N7SfDT9
         tfnznOdv8H3ChHZgRMmCTDmhsB22xkiqrpfdqNYpwUtlz1aIK4+7dee1iJGUNHYT0i
         jGBgZf6gBJ7D0ADL6BNKODLkZtmlS08TSHFQUwGbpYWzSBkzPxrVHYx4fqF4xgGDK9
         VQSg3qfHnvq4wFgxGYYobF7Q+A4Hnx88qeRfW452+7iEfgtxheBQam9tWQBJbctmBY
         qSjK3tHCKgjx9xFzud/xOAW7NMk+9V1AoAuujbB3yTPK9flQKKWvYg0HW9j/gmUEu1
         v1e/wf0M8LcSg==
Date:   Fri, 7 Jan 2022 19:22:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux-oxnas@groups.io,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 0/3] ARM: ox810se: Add Ethernet support
Message-ID: <20220107192201.56136f10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104145646.135877-1-narmstrong@baylibre.com>
References: <20220104145646.135877-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jan 2022 15:56:43 +0100 Neil Armstrong wrote:
> This adds support for the Synopsys DWMAC controller found in the
> OX820SE SoC, by using almost the same glue code as the OX820.
> 
> Patch 1 & 2 are for net branch, patch 3 will be queued to arm-soc.
> 
> Changes since v1:
> - correctly update value read from register
> - add proper tag on patch 3 for arm-soc tree

Waiting for Rob's ack, I just noticed you haven't CCed him directly.
Adding his address now, but not sure if that's enough...
