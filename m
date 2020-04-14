Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310D71A8C98
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633253AbgDNUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633231AbgDNUhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 16:37:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD442076A;
        Tue, 14 Apr 2020 20:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586896633;
        bh=yI5VzEtJik+w0LE16sobkPNy9+v88OcEbqLTrk1m3r8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=coGYEIte38bf6SCi4UXgYRhDfCIoXemWbXY58WiLIccSFdvBYZTeRuGzGpkedOD1u
         hWTNtCm0SR42Pm9fqAemOI4gpalY1U/rS2d4s40vJaGPuIMyQ2gFjnoLX9a/oFbXCM
         iwQKzngOMV6VmcpJpSnxLwPmxn416G2JM/pHJAyc=
Date:   Tue, 14 Apr 2020 13:37:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@mellanox.com>,
        Borislav Petkov <bp@suse.de>, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 3/4] net/nfp: Update driver to use global
 kernel version
Message-ID: <20200414133711.7b405101@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200414155732.1236944-4-leon@kernel.org>
References: <20200414155732.1236944-1-leon@kernel.org>
        <20200414155732.1236944-4-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Apr 2020 18:57:31 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Change nfp driver to use globally defined kernel version.
> 
> Reported-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
