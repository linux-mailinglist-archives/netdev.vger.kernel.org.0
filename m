Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D3D2735F0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgIUWrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727447AbgIUWrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:47:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1E023A63;
        Mon, 21 Sep 2020 22:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600728423;
        bh=e1IDb5cTO+mpJP2Kh45jNp+tk59TDjCN0Jr/1Sy3Uio=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O1DMsaa+cztc3XvWaVNsbXo5P6fo4H1hi1Xp8Bq2VQS+l8/u4zXLRdw9Yl7YQOwEn
         l4FOnRHVJ8igUxN/UZ7HuBgYlrjhLX2kWIiDYo+Zb9LIH8JfLBl8CUOa0f9lsX5y7B
         2PGfHO5mH5fLSBCGG1mmLOPiq5IM6x2AVK6Cw9pg=
Date:   Mon, 21 Sep 2020 15:47:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] devlink: Use nla_policy to validate range
Message-ID: <20200921154701.0e8792ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200921164130.83720-1-parav@nvidia.com>
References: <20200921164130.83720-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 19:41:28 +0300 Parav Pandit wrote:
> This two small patches uses nla_policy to validate user specified
> fields are in valid range or not.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
