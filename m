Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD15B2A121B
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgJaApi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaApi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:45:38 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E9A2076D;
        Sat, 31 Oct 2020 00:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604105138;
        bh=1hGSb4CafMz9/k4Qo46M2ahq+VXXi4ZWL0rJqd2GL+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g5XkTs2budbiQ77LZGWderiDIP+wbHurijnfKNivnu1YprE9iPiIaIUoUwaw2eNe+
         3lq3sc2c7HwVocZUOXOD+eGFJmrYULied8I7FZe2ndTBtn8+tvUcieuciBMZylWzkD
         tZyZf/BFj6fsFj3GVxHzOvY6Vs8bcQ7EkuPJrr1w=
Date:   Fri, 30 Oct 2020 17:45:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] sfc: EF100 TSO enhancements
Message-ID: <20201030174537.7fec9ae4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 20:41:21 +0000 Edward Cree wrote:
> Support TSO over encapsulation (with GSO_PARTIAL), and over VLANs
>  (which the code already handled but we didn't advertise).  Also
>  correct our handling of IPID mangling.
> 
> I couldn't find documentation of exactly what shaped SKBs we can
>  get given, so patch #2 is slightly guesswork, but when I tested
>  TSO over both underlay and (VxLAN) overlay, the checksums came
>  out correctly, so at least in those cases the edits we're making
>  must be the right ones.
> Similarly, I'm not 100% sure I've correctly understood how FIXEDID
>  and MANGLEID are supposed to work in patch #3.

Applied, thanks everyone!
