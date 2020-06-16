Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EDF1FBC1F
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgFPQvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730107AbgFPQvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 12:51:43 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5664E208B8;
        Tue, 16 Jun 2020 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592326303;
        bh=bcTWOAf7zPCXSBV37uZcFWSbRMGaPbOWaRO9c4SVFRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BNa+go6Lc/R3sWbALlAYLKI3cUCz1oh6tfMTxaepZAQ0sWFyCQJiR+xqDIBgmz/bu
         nBtkywDQBIqt7Ou0mazk75eDjq0TfaBkwIoA9UR9r4dwql8CmZq/ghISAmUkgwPGdO
         m6AXu2KdTT/4Jk/F75AfzbSyTBcAA6swAjdFp65w=
Date:   Tue, 16 Jun 2020 09:51:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net v5 0/3] esp, ah: improve crypto algorithm selections
Message-ID: <20200616165141.GA40729@gmail.com>
References: <20200615221318.149558-1-ebiggers@kernel.org>
 <20200616060257.GT19286@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616060257.GT19286@gauss3.secunet.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 08:02:58AM +0200, Steffen Klassert wrote:
> On Mon, Jun 15, 2020 at 03:13:15PM -0700, Eric Biggers wrote:
> > This series consolidates and modernizes the lists of crypto algorithms
> > that are selected by the IPsec kconfig options, and adds CRYPTO_SEQIV
> > since it no longer gets selected automatically by other things.
> > 
> > See previous discussion at
> > https://lkml.kernel.org/netdev/20200604192322.22142-1-ebiggers@kernel.org/T/#u
> > 
> > Changed v4 => v5:
> >   - Rebased onto latest net/master to resolve conflict with
> >     "treewide: replace '---help---' in Kconfig files with 'help'"
> 
> The target trees for IPsec patches is the ipsec and ipsec-next tree.
> I have the v4 patchset already in the testing branch of the ipsec tree
> and plan to merge it to master. This conflict has to be resolved
> when the ipsec tree is merged into the net tree.
> 

Okay, great!  I didn't know about the ipsec tree or that you had already applied
the patches.

- Eric
