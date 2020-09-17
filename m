Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059F626E388
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgIQS2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgIQSUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 14:20:52 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4794E22205;
        Thu, 17 Sep 2020 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600366795;
        bh=2pwwJ4Upk04rkn9OLezqXf4FB3addo3MJZSkO6+25k4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BCq7SwxgNZmRZdrcrQCeEu2U5YIVPm2ddd82GoqgWfrh9fuFIkQ7Xi6PrpevbbcpH
         m7yFTwhy+hEwr1R6N/0jLI11hgGLeMtzOZFoLaX6FXLM0qfiJw/B7tCD/G3BSpGDFp
         pSMa4ufMOwYNJpB+MeKNi8eZbzJKg6zZhkBCanmw=
Message-ID: <f586df06845201f483a4e33003c67fb3e2320338.camel@kernel.org>
Subject: Re: [PATCH net-next] net: remove comments on struct rtnl_link_stats
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Date:   Thu, 17 Sep 2020 11:19:54 -0700
In-Reply-To: <20200917175132.592308-1-kuba@kernel.org>
References: <20200917175132.592308-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 10:51 -0700, Jakub Kicinski wrote:
> We removed the misleading comments from struct rtnl_link_stats64
> when we added proper kdoc. struct rtnl_link_stats has the same
> inline comments, so remove them, too.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks Jakub!

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


