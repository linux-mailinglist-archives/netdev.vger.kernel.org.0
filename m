Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591D02A5C2A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgKDBuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgKDBuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:50:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A6B420870;
        Wed,  4 Nov 2020 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454617;
        bh=np7ao9CRiVE7dH2ACNRRQQ4C0At4/rQuLahrqhg/1q4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f64NiT1e7fGOz+34KoH7M4ppkp9si/CbKiiHM7X5+S3vH8x8VVGLqSzlbTqm8bX0n
         lokEJiw2Zy5oHFPK0MIL33CmGvzQIOcy1AosfdLYDzVwQm9bFFcrMFM3e67cIAGKwL
         eS07kHizQPvmOazAbYVH/uKlHZU+c5wv9n2rbWZ4=
Date:   Tue, 3 Nov 2020 17:50:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dev_ioctl: remove redundant initialization of
 variable err
Message-ID: <20201103175016.0070fe48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102121615.695196-1-colin.king@canonical.com>
References: <20201102121615.695196-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 12:16:15 +0000 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
