Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A392BB22E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgKTSLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgKTSLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:11:33 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA18C2245D;
        Fri, 20 Nov 2020 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605895893;
        bh=hPlZDVlPST2ltxQgk00FBITpZQdnabglitex4eJD3ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rrRxXryNEv2Ol4tOjgzIL+fHoYT2/SZd5UkRemsAn3I3KPeZLKjnSZ0ATgGvwh2Rc
         B8nOQ5NL/0jGisRyMAZK0S1iyU2Kdam+F2hkHav6640HSSCNIx1AtQ7I95Whkua6S4
         Fiby+p3G8WVLaKl8jkGIpzDDv+AZJIKYciDJ+ers=
Date:   Fri, 20 Nov 2020 10:11:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net] bnxt_en: Release PCI regions when DMA mask setup
 fails during probe.
Message-ID: <20201120101131.5442769f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605858271-8209-1-git-send-email-michael.chan@broadcom.com>
References: <1605858271-8209-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 02:44:31 -0500 Michael Chan wrote:
> Jump to init_err_release to cleanup.  bnxt_unmap_bars() will also be
> called but it will do nothing if the BARs are not mapped yet.
> 
> Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied, thanks!
