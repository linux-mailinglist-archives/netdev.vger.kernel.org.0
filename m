Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980A92E6C66
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgL1Wzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgL1Urh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 15:47:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39C65222B3;
        Mon, 28 Dec 2020 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609188417;
        bh=25yN/qnpHEzSUSFo8TBh/SUoGe7R9b0MzO4XneeLIfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F+9H8GIjZdIs1Q137DJwys8Bsn1MeZffRxyTAR8bOYywjX92HOfVfCwiviyoKtf1J
         51kj27Lp611LhS9Z2+LpTsu5ivuFWSNz2dYTW4g3162eWAHtByi66zyZZAAEFmm9Hw
         vwxmoTLvzkCg3o408GpwbrceYYZ9W1WMfaVncsUkRQHtkcZ6hXDS9wwTfOQfZrz7Ue
         uvLvhw7QokR16D2OGJ9GHxYO3nSTSBw3fQF3MlRxJjPG2LCv3WlDrOYw4gm0grUbUl
         gm70TNCn/lXr5Df5BpvOjet9nPvQ3d6oU6ZHYqrPHSfCJTPyc3M7sFaCPU1ABZkWU0
         AbQ9IRfBVzReg==
Date:   Mon, 28 Dec 2020 12:46:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] fsl/fman: Add MII mode support.
Message-ID: <20201228124650.40260dcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201226105956.147025-1-fido_max@inbox.ru>
References: <20201226105956.147025-1-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Dec 2020 13:59:56 +0300 Maxim Kochetkov wrote:
> Set proper value to IF_MODE register for MII mode.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Please repost in a few days - the net-next is still closed:

http://vger.kernel.org/~davem/net-next.html

Please tag the patch with [PATCH net-next].

Thanks!
