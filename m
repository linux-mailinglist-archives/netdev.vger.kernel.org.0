Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9884D423F8D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhJFNpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhJFNpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 09:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92800610A4;
        Wed,  6 Oct 2021 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527809;
        bh=KJuev0J2pMMc7aExbwOClYDnBypgPGjbZxFhjujjYkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mqmzvAvSmdColvVkt3EDxX+YXYR96YM9anCDw9gDki0gmoXT9IQqSrQA6YfVWp50I
         tOwFCwoy1C5Pc7KzjJgtoZsReKYo/0n+JE1I6lYzU5l1U4EFYShgBWPlwPXTwEjsQ6
         CmJwIVmMiyUxZ53JZo3uIr4hRdD6Ae09Rw0KozNdRCRE7e2qHii42ztjX0WSv8d8eH
         nuGtmCVBvd+fK+K03694JA3yDjRgC6T1VwRKsjqGgvkn7ru46KHTnGboP72DjzoeDY
         5Vhlb4PI0JL2SNVA/G8503beaJD2xw+UfUPLZ5oIpVnEVAjDUBXeB6a/J+Xb3AJMuY
         /4ZexAzRQ5Muw==
Date:   Wed, 6 Oct 2021 06:43:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>
Subject: Re: [net-next PATCH v2 0/3] Add devlink params to vary cqe and rbuf
Message-ID: <20211006064328.28a5da0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1633504726-30751-1-git-send-email-sbhatta@marvell.com>
References: <1633504726-30751-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 12:48:43 +0530 Subbaraya Sundeep wrote:
> Octeontx2 hardware writes a Completion Queue Entry(CQE) in the
> memory provided by software when a packet is received or
> transmitted. CQE has the buffer pointers (IOVAs) where the
> packet data fragments are written by hardware. One 128 byte
> CQE can hold 6 buffer pointers and a 512 byte CQE can hold
> 42 buffer pointers. Hence large packets can be received either
> by using 512 byte CQEs or by increasing size of receive buffers.
> Current driver only supports 128 byte CQEs.
> This patchset adds devlink params to change CQE and receive
> buffer sizes which inturn helps to tune whether many small size
> buffers or less big size buffers are needed to receive larger
> packets. Below is the patches description:

nak. Stop ignoring feedback and reposting your patches.
