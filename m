Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743F4394891
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhE1WPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhE1WPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 18:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C066128B;
        Fri, 28 May 2021 22:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622240021;
        bh=4t3bTBnmw2j3cFgTgpLqUFrdn1rsAkOR9rikoDksBF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nfQHvRL0/V64gnFRYckBl7mDDkzBzBomv5eMTTfYTZVh7BcV/eul6fK6Q4UbenchD
         AhRWwKoic9HYS7q6n2gs6do6muPtAAN6vR80b039sDnWr0c+7yFDonjpovrFzW+8ro
         5yc5mJZkBeEorUkS2awLSgXBwxpkc5n6K7K8BF5C9CI/Z3YCBRf9vCVz9LdsT180Xi
         h2Gv6B4LQzSYfiqTuPZKU1LbveZFHIf9lfzRfbfz7jzTwNxuGPTRtQF42neV/9wpGO
         j8J32W5FwYjHhr/+TBksF1CPKu5BXyWVSCTFIihJpjxw5c7RE/q5rrPCNIzNGbMU+B
         5AbcuU5S2foqA==
Date:   Fri, 28 May 2021 15:13:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/11] nfc: fdp: drop ftrace-like debugging messages
Message-ID: <20210528151340.7ea69c15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 10:53:20 -0400 Krzysztof Kozlowski wrote:
> Now that the kernel has ftrace, any debugging calls that just do "made
> it to this function!" and "leaving this function!" can be removed.
> Better to use standard debugging tools.
> 
> This allows also to remove several local variables and entire
> fdp_nci_recv_frame() function (whose purpose was only to log).
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Hi! Would you mind reposting these 11 fixes? build bots don't
understand series dependencies and the last patch here depends 
on the previous clean up set.
