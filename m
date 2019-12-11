Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2D11A574
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfLKHwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:52:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfLKHwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 02:52:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 161C4214AF;
        Wed, 11 Dec 2019 07:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576050763;
        bh=LBIqLK2WI1wJ48nl0OtgepNbLnIiVSjGWVS9d/AMdkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIDywd3xBb/97BHqNRljkjz3SraoayzZG068eYJ0XfnRd+u5zPQ3Qx9kR03f1FBcS
         RySU0MCh3xFryON8XsPQsodbhk2hu+cjerzM7MFxFB9XVJ79/HyBzJp/vvgJmBc7da
         cyHOUGs9TDUWK18PiYJ641r07a0JxWl8KaVcoWZ4=
Date:   Wed, 11 Dec 2019 08:52:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 103/177] rfkill: allocate static minor
Message-ID: <20191211075241.GM398293@kroah.com>
References: <20191210213221.11921-1-sashal@kernel.org>
 <20191210213221.11921-103-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210213221.11921-103-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 04:31:07PM -0500, Sasha Levin wrote:
> From: Marcel Holtmann <marcel@holtmann.org>
> 
> [ Upstream commit 8670b2b8b029a6650d133486be9d2ace146fd29a ]
> 
> udev has a feature of creating /dev/<node> device-nodes if it finds
> a devnode:<node> modalias. This allows for auto-loading of modules that
> provide the node. This requires to use a statically allocated minor
> number for misc character devices.
> 
> However, rfkill uses dynamic minor numbers and prevents auto-loading
> of the module. So allocate the next static misc minor number and use
> it for rfkill.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Link: https://lore.kernel.org/r/20191024174042.19851-1-marcel@holtmann.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/miscdevice.h | 1 +
>  net/rfkill/core.c          | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)

Not needed here :)
