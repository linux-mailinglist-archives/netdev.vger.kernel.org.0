Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EDF249373
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 05:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgHSDgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 23:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgHSDgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 23:36:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0802063A;
        Wed, 19 Aug 2020 03:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597808191;
        bh=U0L92sFVYhygdyhtJCZK11dlyJQ6uNfWDlK3ZwX0WR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LSXptb0+nY133Ni2snuJtWXXkZNjZ6LcmjJH12tctCVnSKYafUpXRksHxng6QAcVl
         c6YXS/opAVvfxg9FCBiOtoL40cdkay1YU09soT0UgDIhKQgXGC5MFwigk6eY3UD5Uz
         SNHEwWNeFtHv237zW6Kn5X5VbAyvVgoUb0FOt0Ig=
Date:   Tue, 18 Aug 2020 20:36:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Patricio Noyola <patricion@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next 07/18] gve: Use link status register to report
 link status
Message-ID: <20200818203629.02b62914@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818194417.2003932-8-awogbemila@google.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-8-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 12:44:06 -0700 David Awogbemila wrote:
> +	if (link_status) {
> +		netif_carrier_on(priv->dev);
> +	} else {
> +		dev_info(&priv->pdev->dev, "Device link is down.\n");

Down message but no Up message?

> +		netif_carrier_off(priv->dev);
