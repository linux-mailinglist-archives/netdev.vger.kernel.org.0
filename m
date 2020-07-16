Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB18B221943
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGPBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPBFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 21:05:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1AB82071B;
        Thu, 16 Jul 2020 01:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594861535;
        bh=sw5+Y6Pc2OHWl2mKtV8KEZF9TTl5q+j8uF1Y6RhA9LY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2cWUDn2wEdF45UhJNbWUrK3x2HUl3CbUZjSsXZjvbniLn9Bg52DlsN4MH/5TBuTY2
         mpS14Blj0TCLFkgQ77JPgCusD7nIOBmH+OSxmH35AGu8P1sLt9cin8n4e0Zi6wctxi
         LsgVodFolS3OLjtQA7erb5YxI1a3Rzeb5IEZJ/Ak=
Date:   Wed, 15 Jul 2020 18:05:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suraj Upadhyay <usuraj35@gmail.com>
Cc:     davem@davemloft.net, linux-decnet-user@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] decnet: dn_dev: Remove an unnecessary label.
Message-ID: <20200715180532.5297f0dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714142328.GA4630@blackclown>
References: <20200714142328.GA4630@blackclown>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 19:53:28 +0530 Suraj Upadhyay wrote:
> Remove the unnecessary label from dn_dev_ioctl() and make its error
> handling simpler to read.
> 
> Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>

Applied, thank you.
