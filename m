Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15D4380B4
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhJVXkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhJVXkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D34861038;
        Fri, 22 Oct 2021 23:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634945914;
        bh=5t4bxJ/FRB12hBwvAhH4kRLNWoviMpetiQwlY3jS10s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jT9Ap08cr99WYnJjnDR+hIukywT7Mm602xMflUHg0DHsODfbHFVnmqrQmfbut7pF/
         ETmMo2z7B8Xhrz5qejNuva84FZTVqzlfQruHUidpEgofuytl+uAJh1qrIZk/ZGFjfD
         MBkc1aY1Gpo0BW1pI2W9aPNc3i++ScZuR+HEcviE2eCKnBtZ6iaq+tOPT0I/v0UlZB
         O49uhcoqr59cw7irkDoM2txLsnaWprBNXvVg9S7JEHrHg7gy9kxMI97ZmohgJyhfRf
         rMU5p6kXYxdpL1LkgOUeWUkVwDeh3Dx6kOuS9oc4MKSBZQO0iAiGWdbNVWOIEDvBW7
         vCRjPbTaAv3yA==
Date:   Fri, 22 Oct 2021 16:38:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        linux-sctp@vger.kernel.org, michael.tuexen@lurchi.franken.de
Subject: Re: [PATCH net 0/7] sctp: enhancements for the verification tag
Message-ID: <20211022163833.432e90e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXIXwWOkUYhazR4R@t14s.localdomain>
References: <cover.1634730082.git.lucien.xin@gmail.com>
        <YXIXwWOkUYhazR4R@t14s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 22:45:37 -0300 Marcelo Ricardo Leitner wrote:
> On Wed, Oct 20, 2021 at 07:42:40AM -0400, Xin Long wrote:
> > This patchset is to address CVE-2021-3772:
> > 
> >   A flaw was found in the Linux SCTP stack. A blind attacker may be able to
> >   kill an existing SCTP association through invalid chunks if the attacker
> >   knows the IP-addresses and port numbers being used and the attacker can
> >   send packets with spoofed IP addresses.
> > 
> > This is caused by the missing VTAG verification for the received chunks
> > and the incorrect vtag for the ABORT used to reply to these invalid
> > chunks.
> > 
> > This patchset is to go over all processing functions for the received
> > chunks and do:
> >   
> ...
> > 
> > This patch series has been tested with SCTP TAHI testing to make sure no
> > regression caused on protocol conformance.  
>  
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thanks.
