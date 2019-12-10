Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940DB11928A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLJUzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfLJUzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 15:55:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C48206EC;
        Tue, 10 Dec 2019 20:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011345;
        bh=6yTF7yMvXdzCNyAqnzkpIHtyptB+pSFVQwdyGXh/R8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pVSFRjnzq4i492eDgRTa9mtugubxPY3zS0NeF812/t21hUK6+IJoLpn/vx8N6cMVg
         /h837S4UfTcYciP+JV+MI4unWqhvKOoXFUXrWucPgYDercTubCOfjkAxLbWJAp9Zcu
         k4GCSZNRxeV1T1Edmvba21GCnbXyY30KP4LuHPoQ=
Date:   Tue, 10 Dec 2019 21:55:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aviraj CJ <acj@cisco.com>
Cc:     peppe.cavallaro@st.com, netdev@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [PATCH 1/2] net: stmmac: use correct DMA buffer size in the RX
 descriptor
Message-ID: <20191210205542.GB4080658@kroah.com>
References: <20191210170659.61829-1-acj@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210170659.61829-1-acj@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:06:58AM -0800, Aviraj CJ wrote:
> We always program the maximum DMA buffer size into the receive descriptor,
> although the allocated size may be less. E.g. with the default MTU size
> we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> memory may get corrupted.
> 
> Program DMA using exact buffer sizes.
> 
> [Adopted based on upstream commit c13a936f46e3321ad2426443296571fab2feda44
> ("net: stmmac: use correct DMA buffer size in the RX descriptor")
> by Aaro Koskinen <aaro.koskinen@nokia.com> ]

Adopted to what?

What is this patch for, it looks just like the commit you reference
here.

totally confused,

greg k-h
