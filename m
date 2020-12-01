Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271AB2CAC5C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbgLAT3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:29:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgLAT3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 14:29:44 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58BD204EC;
        Tue,  1 Dec 2020 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606850943;
        bh=5HCY0EeLPQqAcr9+1MDqs5E67oCMbxuIEyvXlfJyzuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0rxIYxedEqZVkHYrStm2IIFdREVrVpDCMDuFwhNHVe+8xN9i0vd+8rE19Y2iXw4P1
         8K7g9Y/Ct6yjdmVpg61cXIyWxvV91AdN7IIbh6RJqPLxQhYzcETrPJ3lrBAfN/BJoK
         B7S0623Z+4ylMnZQ8KI0wpl3WQoOFoxK1s9fkOaY=
Date:   Tue, 1 Dec 2020 11:29:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v13 0/4] userspace MHI client interface driver
Message-ID: <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 19:26:02 -0800 Hemant Kumar wrote:
> This patch series adds support for UCI driver. UCI driver enables userspace
> clients to communicate to external MHI devices like modem and WLAN. UCI driver
> probe creates standard character device file nodes for userspace clients to
> perform open, read, write, poll and release file operations. These file
> operations call MHI core layer APIs to perform data transfer using MHI bus
> to communicate with MHI device. Patch is tested using arm64 based platform.

Wait, I thought this was for modems.

Why do WLAN devices need to communicate with user space?
