Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E93222AFB
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgGPSYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgGPSYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 14:24:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D609D2074B;
        Thu, 16 Jul 2020 18:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594923874;
        bh=lUrKAN9yNahYk7DUhEVFApBsMcGwcqcB0K958hQove4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UKdl1ElnQFjpW7KDv9qP3KZasaypvi6rKGvuPkI8JqV+ITm+nFBjSBFQRNZfzwQKS
         dNlgdYtJt9Op41llLbthsSk6EKgovcbOAQHzR/PsMB14FIJEfSAkN4JDS0dHAFABJr
         8HcJS1TtQEihKUgASpgn6ZLKpELaumP4Xm1AxQKE=
Date:   Thu, 16 Jul 2020 11:24:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200716112432.127b9d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714162802.11926-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200714162802.11926-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 19:28:02 +0300 Sergey Organov wrote:
> Fix support for external PTP-aware devices such as DSA or PTP PHY:
> 
> Make sure we never time stamp tx packets when hardware time stamping
> is disabled.
> 
> Check for PTP PHY being in use and then pass ioctls related to time
> stamping of Ethernet packets to the PTP PHY rather than handle them
> ourselves. In addition, disable our own hardware time stamping in this
> case.
> 
> Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Acked-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> 
> v3:
>   - Fixed SHA1 length of Fixes: tag
>   - Added Acked-by: tags
> 
> v2:
>   - Extracted from larger patch series
>   - Description/comments updated according to discussions
>   - Added Fixes: tag

FWIW in the networking subsystem we like the changelog to be part of the
commit.

Applied, and added to the stable queue, thanks!
