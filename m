Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD31A3234B2
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 01:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhBXArY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 19:47:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234615AbhBXABP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 19:01:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B005A64ED0;
        Tue, 23 Feb 2021 23:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614123832;
        bh=SNsZKNr4Bb2ht6/RUX3DxZzTI304h9E/HR1F5juGLTI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QciuLl3hVAAgTWm+9Xljpc8gPJ4GL2sFx/1qgWSiJf7J1/5VqAp7z1lGAZg/fy3sy
         3p+0UJWLeOIxpVcXMNvvGYKMsNQee/sWRMQBLUWkYCMufi3yKwRKz88UMreOZfB1K5
         A/tP/GTdqNFP8OuEceinz40olToppQc7VpjusSopviz4JTFQJaWsLJpuv627eW240T
         l+92GACl6F0sgWcGKJKzd2IMk/x8qgawexhEtv1IfYNhSOaEu2x9yjfNy6LeuGS6vU
         OQY2m+ldWaR+Y6wkC7Hod5SKlLGRxyzSlqbMVwStyyXlEVCzCD3/LjTt3vURgnSbjl
         UZKz3YLPLClYA==
Date:   Tue, 23 Feb 2021 15:43:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] atl1c: switch to napi_gro_receive
Message-ID: <20210223154349.103c34cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222014045.1425-1-liew.s.piaw@gmail.com>
References: <20210222014045.1425-1-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 09:40:45 +0800 Sieng Piaw Liew wrote:
> Changing to napi_gro_receive() improves efficiency significantly. Tested
> on Intel Core2-based motherboards and iperf3.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

net-next is currently closed (see the note below). Would you mind
resending this change in a week or two?


# Form letter - net-next is closed

We have already sent the networking pull request for 5.12 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.12-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
