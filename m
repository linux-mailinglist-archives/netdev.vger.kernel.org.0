Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D5D27474B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgIVRNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVRNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 13:13:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 265282085B;
        Tue, 22 Sep 2020 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794791;
        bh=6NKhcnsMqDGfV9GHyKKn9MlFT3BioP4w42diOia3BLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wy9Y4HLQ3sC6EwPMjI9wLar9Nr45+d7Vl+v7Bs3fFh75JP4DxvOsN28Y7nypRlgBk
         M+PiYkGdqO4W+zDcxmLunB+O7Kp/2DZ+XiqpVnX/lATQx2hKE81QapNwHby6fbvkAt
         99H360/0Vy212jDDn0abMonppY6gF8DcpB2DKTnw=
Date:   Tue, 22 Sep 2020 10:13:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <george.cherian@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH 0/2] Add support for VLAN based flow
 distribution
Message-ID: <20200922101309.3004c021@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922130727.2350661-1-george.cherian@marvell.com>
References: <20200922130727.2350661-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 18:37:25 +0530 George Cherian wrote:
> This series add support for VLAN based flow distribution for octeontx2
> netdev driver. This adds support for configuring the same via ethtool.
> 
> Following tests have been done.
> 	- Multi VLAN flow with same SD
> 	- Multi VLAN flow with same SDFN
> 	- Single VLAN flow with multi SD
> 	- Single VLAN flow with multi SDFN
> All tests done for udp/tcp both v4 and v6

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
