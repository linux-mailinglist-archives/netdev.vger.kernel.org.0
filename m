Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDB03155E0
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhBISZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233182AbhBISW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:22:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271EC64E31;
        Tue,  9 Feb 2021 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612894902;
        bh=piOwjICgDS4VaC6eG4eNz2QSZhpyC5Ls/aSbj2BoSZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U8JBZBWfUcvs15eYXc/LByM0P/G5tmJYQKc3zMIrmPxoiYbaDApAsPhgHSEvdbJMr
         KicHxG78jlJlWeDDns/G/YBqtz2zev7yD34xOn5M4XOw5tl3GjctlwEnXrxPSA0JfB
         N3HwvbQXOolDvr/jOvsl6sQn+0gjDxclVWNIc4CoMfL6d0vQv15xLZ9eM0fwmzl3ua
         TNF0R2o6QUGI8EKOhvjqBDOnEglsEa7cJl6iiDTW1Dazoqx/JnOBBIsmAFJEaI5qQp
         ePMw7iaSJStZifM64EgpbTCbHLFMOSNRGasKyK5QQfQb0kdsxOJuQ18lUKo+RU5/Ka
         PGam50AUh4N2w==
Date:   Tue, 9 Feb 2021 10:21:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bjorn@mork.no,
        dcbw@redhat.com, carl.yin@quectel.com, mpearson@lenovo.com,
        cchen50@lenovo.com, jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com
Subject: Re: [PATCH net-next v5 0/5] Add MBIM over MHI support
Message-ID: <20210209102140.285150d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
References: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Feb 2021 10:05:53 +0100 Loic Poulain wrote:
> This patch adds MBIM decoding/encoding support to mhi-net, using
> mhi-net rx and tx_fixup 'proto' callbacks introduced in the series.

Acked-by: Jakub Kicinski <kuba@kernel.org>
