Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DADD2FACB6
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437986AbhARVcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394627AbhARVcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:32:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC50822CB1;
        Mon, 18 Jan 2021 21:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611005511;
        bh=kTjX1VZm1DWWauWsV+mUEXbzgKqcO9yZ0x/rHJpGZeA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CLdb+2nUgmBA35IQuSRFAAMoVtCsF2TSja834nkhc604qeaLNQNcAoTvf//dWvZAu
         NVGCa6Sv3hmS4rjG90WHFJfuY7qCnFL+jX9ydbS4KC4W/onDoC3Vu5zZpyxVBXNchZ
         aSbFQI8lF8B9Z+lH5ZXIBli8vUhBhrFYC8HxPSxK/9BZCHRtanyz/3lWMw59YDj7Oy
         nASpU3lanZ0y9wBEYnQl8yEaTdKYz2GsBccfcGSjoycdg6U+SNlLOHxrR7QfDm3Ukt
         N1CFPZx6MYXJtx35Gs4pz0WtP6IdRcG68gwummKdA3kwcabJjXme/6l3EEFyLGVDBP
         nN+fmU8KA78bA==
Date:   Mon, 18 Jan 2021 13:31:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net] net: nfc: nci: fix the wrong NCI_CORE_INIT
 parameters
Message-ID: <20210118133149.22f2fef1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACwDmQDxa6WKq4UwCfk2sxC8JukV+CcnuSqrCdhSWSjJ9ppwOg@mail.gmail.com>
References: <20210118205522.317087-1-bongsu.jeon@samsung.com>
        <20210118130154.256b3851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACwDmQDxa6WKq4UwCfk2sxC8JukV+CcnuSqrCdhSWSjJ9ppwOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 06:19:23 +0900 Bongsu Jeon wrote:
> On Tue, Jan 19, 2021 at 6:01 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 19 Jan 2021 05:55:22 +0900 Bongsu Jeon wrote:  
> > > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > >
> > > Fix the code because NCI_CORE_INIT_CMD includes two parameters in NCI2.0
> > > but there is no parameters in NCI1.x.
> > >
> > > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>  
> >
> > What's the Fixes tag for this change?  
> Sorry to miss the Fixes tag.
> This is the Fixes tag ( Fixes: bcd684aace34 ("net/nfc/nci: Support NCI
> 2.x initial sequence") )
> Could I resend this patch after adding that tag?

It's fine no need to repost, I can add the tag when applying the patch,
let's wait for reviews. Let me just place it on a line of its own,
patchwork is supposed to pick that up automatically:

Fixes: bcd684aace34 ("net/nfc/nci: Support NCI 2.x initial sequence")
