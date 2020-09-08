Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B145261CE5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbgIHT2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732205AbgIHT17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:27:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECBC12087D;
        Tue,  8 Sep 2020 19:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599593279;
        bh=9bd9aoV9ybGyDWcgwihcOL7TEtxFl3giP/oVfmg3fFg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bBpJ3QXRdwj/vkf6sZdB1M+4NTPTQA9sFkK/+29E8htMJaZjeNfy+6CYP/FmUHliC
         AuVxTftYcrq9eJARKfPyUjLh9jwVd4gx/9pU2ozN/obOV6hgxoXpoMFIMjSj8Z7izE
         zDuwqVOUbbDptmKpR5msQUBwzlJJygmvmRXFTEm4=
Date:   Tue, 8 Sep 2020 12:27:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Patricio Noyola <patricion@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v3 8/9] gve: Use link status register to report
 link status
Message-ID: <20200908122757.303196fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908183909.4156744-9-awogbemila@google.com>
References: <20200908183909.4156744-1-awogbemila@google.com>
        <20200908183909.4156744-9-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 11:39:08 -0700 David Awogbemila wrote:
> +		dev_info(&priv->pdev->dev, "Device link is up.\n");
> +		netif_carrier_on(priv->dev);
> +	} else {
> +		dev_info(&priv->pdev->dev, "Device link is down.\n");
> +		netif_carrier_off(priv->dev);

These should be netdev_info()
