Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F2943CDC4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhJ0Pkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238780AbhJ0Pkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86E660E75;
        Wed, 27 Oct 2021 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635349090;
        bh=TDCryjBj+7JBE4wgrdysLMLDMBTlhW5TthS+2Rgu08g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ht3YaI0qLQd9czx/+DgYU396ckahPfwY5UvI+st7mXAmR3YyBtOjjfO+AybbiRP3x
         SLC6LtdEauPHOjGCBdyJPOff4DZ7CD4gSHYzBbUIFPVHRpz5ALuR1MdN+eRBS6+LNn
         1uTzzRVYaon+X7DtsYznNEix7aH6vRbMoRr5FkBEyO1+hKVblg5NhJVWfhnIL5p/Vt
         j4YJnq7YPbYCftEg0x2we9j+woAyxCofLCqTwhUbBRWr79wQkxFIZHlBZZK6biGtME
         bMW3P4hWfEVUC5islsax1HZBzrT2ojRs6utvRYDgiKzsJ62yxsbQkMsYbP3/6rS9Pb
         hzWGS99WgCxOg==
Date:   Wed, 27 Oct 2021 08:38:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Vamsi Attunuru <vattunuru@marvell.com>
Subject: Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to init
 and de-init serdes
Message-ID: <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1635330675-25592-2-git-send-email-sbhatta@marvell.com>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
        <1635330675-25592-2-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 16:01:14 +0530 Subbaraya Sundeep wrote:
> From: Rakesh Babu <rsaladi2@marvell.com>
> 
> The physical/SerDes link of an netdev interface is not
> toggled on interface bring up and bring down. This is
> because the same link is shared between PFs and its VFs.
> This patch adds devlink param to toggle physical link so
> that it is useful in cases where a physical link needs to
> be re-initialized.

So it's a reset? Or are there cases where user wants the link 
to stay down?
