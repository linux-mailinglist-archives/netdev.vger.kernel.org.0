Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD92AE287
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732133AbgKJWHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJWHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 17:07:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840C820781;
        Tue, 10 Nov 2020 22:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605046030;
        bh=dCDTcvNrJq7IW5yX1OSrzo5s5RH9c0L9VfGGbIEGwvU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B3kVs6gMA6ZCVaiG1A8sJETnyYJkaZjR+HKtPXaNjHDDt133kPU7QFTMsoA9vhJ3a
         s8jDzWH6mP0YrPtmv+oeD8neGDVmeneuKmS7ZEVLpALxZ0N1Gd1C3X9sHAs5iIbdO0
         sL9aVsJGcoiqIeWpZ6JIRBAjI8zx5jsk4kAxCxuo=
Date:   Tue, 10 Nov 2020 14:07:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] devlink: Avoid overwriting port attributes of
 registered port
Message-ID: <20201110140709.62cf1249@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110185258.30576-1-parav@nvidia.com>
References: <20201110185258.30576-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 20:52:58 +0200 Parav Pandit wrote:
> Cited commit in fixes tag overwrites the port attributes for the
> registered port.

Seems like you forgot the fixes tag you're referring to.

> Avoid such error by checking registered flag before setting attributes.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

