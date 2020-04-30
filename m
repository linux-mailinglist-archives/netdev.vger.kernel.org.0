Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5C01C09A8
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgD3VvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgD3VvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 17:51:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5AE020731;
        Thu, 30 Apr 2020 21:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588283473;
        bh=FDEBpQb4Nf9/XEQ0pOjeekGMcpLDY7vPY5Tj7IpgyM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZlralPaNf9wp5UZLfQEx+2lAEr5BLDKwTZOsNWfBQqJI90lPPI4L0mGfG4xxzF1Ai
         yJyGGI1BkMx1xHyfznQWmOCwtLTbwBzjXqTxP0jfL9z+bRU1vuTbSfpLZ8lgbSzoIj
         RRRsAVM96CdInY3NwLuFwvQXnKLhL/TXoEimNbeg=
Date:   Thu, 30 Apr 2020 14:51:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/7] r8169: refactor and improve interrupt
 coalescing
Message-ID: <20200430145110.0ce8f89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 21:54:43 +0200 Heiner Kallweit wrote:
> Refactor and improve interrupt coalescing.

Looks like a nice clean up!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
