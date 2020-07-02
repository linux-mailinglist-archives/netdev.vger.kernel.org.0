Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4072B212156
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgGBKcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbgGBKcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 06:32:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D622073E;
        Thu,  2 Jul 2020 10:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593685944;
        bh=3uzJdXDmT8FY4gyQ3T1UaSqZ+EEfCJDFv/7k1CeXfD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IGUBpkAPA0NkoiCzhPgZFHqDh6lfLSNQu4VZJ8IBc9WLGvJ3w8qytgEiD0tCh6YTn
         tmEFrv2Og4IT6Zb2Jkwq0lJQtp1NTNZ66IueddDwUe78HyBiePV4Dc5He5iDLRbify
         DT1TVhrdVF+rP3XO/V/DRmoYcLqXFNdaqYK0QSI0=
Date:   Thu, 2 Jul 2020 12:32:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-nfs@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: Re: [RFC PATCH 1/7] staging/rtl8192e: switch to RC4 library interface
Message-ID: <20200702103227.GB1238594@kroah.com>
References: <20200702101947.682-1-ardb@kernel.org>
 <20200702101947.682-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702101947.682-2-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 12:19:41PM +0200, Ard Biesheuvel wrote:
> Switch to the ARC4 library interface, to remove the pointless
> dependency on the skcipher API, from which we will hopefully be
> able to drop ecb(arc4) skcipher support.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
