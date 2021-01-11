Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9392F24F0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405398AbhALAZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403931AbhAKXOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 18:14:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4074A22D07;
        Mon, 11 Jan 2021 23:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610406835;
        bh=idxc8SY9FmX0KVOtHuxclrVLf4zIKWofRoBT7jepBi4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cJgG3tWndHQjqBnaq7PnuDU4TENZMxYCsygQer0fBuKseKiggcDYKtXfeC1gq6eO5
         ZkXtcDKHTa8w/3duCd/c8d62O/mn3ki1XS0RvQHAjg9R6SxqkLSnhQRGckWJlHeBpX
         H0fkeIZqhDt05qZLFwhhAF9cAAy/Z/pNAib/WfrFiUeEoa4AsDRSwuCuo3oiMFfaXY
         8VeMde1sgN3Y8kYF3LqEE2dWuF5JFQ3bPH8j56jCxi5fWKGoL/uNJW7PZzt1Jr/ON3
         vq+GSB4pgppT5PD38x2JMcGDJ2ClsezlSxJ2rsOOQoAMH5KBrU9G6BYXjHQZiW25Cc
         RREKvfWeArcoA==
Date:   Mon, 11 Jan 2021 15:13:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Atish Patra <atish.patra@wdc.com>
Cc:     linux-kernel@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [PATCH] net: macb: Add default usrio config to default gem
 config
Message-ID: <20210111151354.7aec0780@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111195553.3745008-1-atish.patra@wdc.com>
References: <20210111195553.3745008-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 11:55:53 -0800 Atish Patra wrote:
> There is no usrio config defined for default gem config leading to
> a kernel panic devices that don't define a data. This issue can be
> reprdouced with microchip polar fire soc where compatible string
> is defined as "cdns,macb".
> 
> Fixes: edac63861db7 ("add userio bits as platform configuration")
> 
> Signed-off-by: Atish Patra <atish.patra@wdc.com>

Fixes tag needs work:

Fixes tag: Fixes: edac63861db7 ("add userio bits as platform configuration")
Has these problem(s):
	- empty line after the tag
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'

Please put [PATCH net] as subject prefix, to indicate this 
is a networking fix.

You can also CC Andrew Lunn like get_maintainer.pl suggests,
but drop linux-kernel from the CC/To.
