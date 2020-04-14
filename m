Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1151A7922
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438969AbgDNLJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438931AbgDNLJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 07:09:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5AB02072D;
        Tue, 14 Apr 2020 11:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586862554;
        bh=bhaVzEjbn+naoG3O8G8BJQNHZoao6Y+7hqmCCONe65A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QG6MXD5/6mHfnahu2B4g7KI0tclG+kxRs006zvjLkbM8Oj5x/RcdYoqhRS/DN4f3v
         cLVDMMUP4KrBO8gFcfziDYME/u3lqa7mpAq5hcNpjXG3B9pLP2V3DenVxl2RmDQDse
         1chDrx+0aMm5nOFuneI0aqhmvax6oSEjT6l8eyzk=
Date:   Tue, 14 Apr 2020 13:09:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200414110911.GA341846@kroah.com>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 01:22:59PM +0300, Or Gerlitz wrote:
> IMHO - I think it should be the other way around, you should get approval
> from sub-system maintainers to put their code in charge into auto-selection,
> unless there's kernel summit decision that says otherwise, is this documented
> anywhere?

No, we can't get make this a "only take if I agree" as there are _many_
subsystem maintainers who today never mark anything for stable trees, as
they just can't be bothered.  And that's fine, stable trees should not
take up any extra maintainer time if they do not want to do so.  So it's
simpler to do an opt-out when asked for.

thanks,

greg k-h
