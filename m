Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6B2BB151
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgKTRVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:21:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbgKTRVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:21:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4208A2225B;
        Fri, 20 Nov 2020 17:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605892876;
        bh=t2gFVll6270wCTr2602UiN5zgx9tp7VzSYrposkKHGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M9FMRGKzTgROXnPbaxaelwWDyjJYOPa3P8zHI/Yn8jaew0YCxnVGZmBbCiPYSF/vX
         Zp/xCLUnQU4FakzCEkOZgXmcBSzOt9g7tDmOIrbDNVeMYg4+PttFxZs9bTAXooJAc9
         fyh/M40lXdGU6v3io61IatTvJ3Gnb71mQVOR7hPU=
Date:   Fri, 20 Nov 2020 09:21:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <mhabets@solarflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Edward Cree <ecree@solarflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: Change Solarflare maintainers
Message-ID: <20201120092115.1207c048@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120113207.GA1605547@mh-desktop>
References: <20201120113207.GA1605547@mh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 11:32:07 +0000 Martin Habets wrote:
> Email from solarflare.com will stop working. Update the maintainers.
> A replacement for linux-net-drivers@solarflare.com is not working yet,
> for now remove it.
> 
> Signed-off-by: Martin Habets <mhabets@solarflare.com>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

You gave me a scare there with this subject, it's just email addrs :)

Applied, thanks!
