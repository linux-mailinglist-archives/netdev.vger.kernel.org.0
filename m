Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9883A457B11
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 05:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhKTEXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 23:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235264AbhKTEXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 23:23:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 063E160D42;
        Sat, 20 Nov 2021 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637382008;
        bh=BSHgo0hSx0fO026NmtYZ2hEkkND1MNRPALGR5GncJ34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uBbyTLyzstG3FIYgnDKgabtfmKHxypAvOKELqdrskomYPLkXWZnGfIZYGGKBxOkzL
         njNQgG1FWVNDVWQyAond8yfWiqe3nzlJOx37Gu/AdWJ3qxwxY5sixlAIJHZG7g0FsQ
         3jiQ+ISdXu+BrukFHrWO2BJIcpOO6Jo5p7iyBvaQ7feZTDe8LaFBPELXahSGWDr1tW
         yn7WxClxeJcZCpsQbZaYaxnC9vftIHGNbAgFv/5y84q7VVzGeKwqoZt1m8IOUprtep
         d0ZH69MYg2ej4HXvCD5rMAlUeW2mTbe1DJlqC8vUIfR1l3TfXqCnJsyZ+GX0NuvRQd
         t4bG+yAFrls9w==
Date:   Fri, 19 Nov 2021 20:20:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
Subject: Re: [PATCH V2 net-next 1/2] net: wwan: common debugfs base dir for
 wwan device
Message-ID: <20211119202007.077a1656@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119100720.1112978-2-m.chetan.kumar@linux.intel.com>
References: <20211119100720.1112978-1-m.chetan.kumar@linux.intel.com>
        <20211119100720.1112978-2-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 15:37:19 +0530 M Chetan Kumar wrote:
> +struct dentry *wwan_get_debugfs_dir(struct device *parent)
> +{
> +	struct wwan_device *wwandev;
> +
> +	if (WARN_ON(!parent))
> +		return ERR_PTR(-EINVAL);

defensive programming, please drop this check

> +	wwandev = wwan_dev_get_by_parent(parent);
> +

please drop empty lines before calls and error checks

> +	if (IS_ERR(wwandev))
> +		return ERR_CAST(wwandev);
> +
> +	return wwandev->debugfs_dir;
> +}
> +EXPORT_SYMBOL_GPL(wwan_get_debugfs_dir);
