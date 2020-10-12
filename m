Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A288028C3C7
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbgJLVHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbgJLVHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 17:07:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB0B2206CA;
        Mon, 12 Oct 2020 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602536869;
        bh=nsc/0B/+C92oHrZsEO9olnO9pqRG5a5XfkepZ2l/RUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KBsC76aZBghbh0ORKTdxl7MNFO9Znf/gsue8NhN8c9nEj7OXUoJSbnfXUsXgvbU4G
         QK4s/UpqbKH2GDbIVCrVdG+NE8OZk4sAEFVoGvcycw55qQHELsgAE5xhOxYDMDgd/4
         0S9Bzt5J9c7buoRYFzNPa4jouHR+P9kMtvlMt7L4=
Date:   Mon, 12 Oct 2020 14:07:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        saeedm@nvidia.com, tariqt@nvidia.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] mlx4: handle non-napi callers to napi_poll
Message-ID: <20201012140747.06e4c2dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALkJObfWR-7igG5JOwx42AQHPD6MA69+Gi_uaWgJ4AbzUZ=G_g@mail.gmail.com>
References: <20201008184526.3196768-1-jonathan.lemon@gmail.com>
        <20201011113529.23a26766@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALkJObfWR-7igG5JOwx42AQHPD6MA69+Gi_uaWgJ4AbzUZ=G_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 09:40:51 +0300 Tariq Toukan wrote:
> On Mon, 12 Oct 2020 at 05:47, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 8 Oct 2020 11:45:26 -0700 Jonathan Lemon wrote:  
> > > From: Jonathan Lemon <bsd@fb.com>
> > >
> > > netcons calls napi_poll with a budget of 0 to transmit packets.
> > > Handle this by:
> > >  - skipping RX processing
> > >  - do not try to recycle TX packets to the RX cache
> > >
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>  
> >
> > Tariq, Saeed - how does this look to you?  
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Applied, thanks!
