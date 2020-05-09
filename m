Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5671CBDC1
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgEIFaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgEIFaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:30:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB97821775;
        Sat,  9 May 2020 05:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589002201;
        bh=kRn4BxjT6lLjk7lCqyOQBmQUNvBOZktWpwcch9JwfVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQmjTCHS5KgmwjltNV+Yn4u+K8u9xWI6ZY0ZGs09ekLjVCVnoVsRb0jXIgM8y1Bmb
         ZI5qoqkDP9sv0WjJV63N0c0sk52En5AkQ6z/wbIffU8991CgPfYOVi9v4+0wp0E7b9
         E5HB6i7MSvh9rI/paKce5KQQegIvJS9UJ4LJbMHg=
Date:   Fri, 8 May 2020 22:29:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: vsc73xx: convert to
 devm_platform_ioremap_resource
Message-ID: <20200508222958.19e127d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508101114.2331-1-weiyongjun1@huawei.com>
References: <20200508101114.2331-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 10:11:14 +0000 Wei Yongjun wrote:
> Use the helper function that wraps the calls to platform_get_resource()
> and devm_ioremap_resource() together.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied, thank you!
