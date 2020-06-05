Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB61EF4E0
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgFEKBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgFEKBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 06:01:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 380692075B;
        Fri,  5 Jun 2020 10:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591351270;
        bh=48Upx4rF4WwJ0UA83rqCVWDAC3h9jo9L5UtC6lcdR8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p4lMgdCbIzYDHLr2bBl6o3Bd+7iXG0SkHok3544WIA4LMiHCNHt6JBncyxSwSt+oh
         QlKg2t77XAr7xhcLvshyFhAZIaQ3TctyDAstnnkTasdp0ky5spyhih06SyCH/P2Jh0
         3rd5n0ABLc886PL5UJtV1SyIbD8lW9sXXXU2tKZw=
Date:   Fri, 5 Jun 2020 12:01:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net] esp: select CRYPTO_SEQIV
Message-ID: <20200605100103.GA2398749@kroah.com>
References: <20200604192322.22142-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604192322.22142-1-ebiggers@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 12:23:22PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since CRYPTO_CTR no longer selects CRYPTO_SEQIV, it should be selected
> by INET_ESP and INET6_ESP -- similar to CRYPTO_ECHAINIV.
> 
> Fixes: f23efcbcc523 ("crypto: ctr - no longer needs CRYPTO_SEQIV")
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>


Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

