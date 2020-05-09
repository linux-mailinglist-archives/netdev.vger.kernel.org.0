Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73D61CBDDF
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgEIFsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgEIFsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:48:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C2E21582;
        Sat,  9 May 2020 05:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589003301;
        bh=yPR1hDX3lS/n/86YXS4Dtq2lp4bvr1liML0v6J5wlvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B8+Ls+sFDyE1zf2vxm8L9ts88dJIRmgsbnb0X0v9shz6eeikFWi9CE0Hz27bxoODz
         /O2KE2kFff7eytUSUI9jXymmvRAFgs8hwTi92io2LSMsP3xjAHtSiLiT9Y8bNKJsdv
         O7v/VuDHR1F7SzvvNRcG+Yph0d0S6Fl+KXBo0CJo=
Date:   Fri, 8 May 2020 22:48:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cnic: remove redundant assignment to variable ret
Message-ID: <20200508224819.0855e74c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508224026.483746-1-colin.king@canonical.com>
References: <20200508224026.483746-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 23:40:26 +0100 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being assigned with a value that is never read,
> the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you!
