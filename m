Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376762A39F4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgKCBgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbgKCBgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:36:35 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEAC6206CA;
        Tue,  3 Nov 2020 01:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604367395;
        bh=/q6xkJlzQfXkuDijHsgH2Li1Y3fubsXhtQT3gtnOuBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lvMgvJQs3itkfnlerQrwVAWCa8MrzY7rbJ6fDcoJR43/HZrcyOdUeHgRlqT7GBepQ
         M1pG6U9hOlE9rhOg3xwo2CcjaddR5KfO2MGneoRCiUZf5Hs3U5X7X4wpvQ1aEvrIzN
         zEXugNJHi1YakABctzdLVCESdvwREEP28M6tzXkw=
Date:   Mon, 2 Nov 2020 17:36:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] liquidio: cn68xx: Remove duplicated include
Message-ID: <20201102173633.45099078@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031024744.39020-1-yuehaibing@huawei.com>
References: <20201031024744.39020-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 10:47:44 +0800 YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks!
