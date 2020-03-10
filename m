Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5171E180AC2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbgCJVpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgCJVpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 17:45:54 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A453A20578;
        Tue, 10 Mar 2020 21:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583876753;
        bh=C7kX0tWs+WV4XCVdaZd0w/72UR3+5XNbTn8FahAb76A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fypldyL5xXDe7Q9TS7XPVAAZiTy/faqfAHWupabfKbcEm9lhHkOc3CfFnm84/SA/a
         XvHWX/u2K8Khq6U1A7JewdIyVcOfBf9fLWDXak7Bq+F2eHJXHfkwhCC+bK5rLfBJnG
         jQEl+dPk00g2FZFf7pnEtZvoj4T83ZC2HaPrbhQQ=
Date:   Tue, 10 Mar 2020 14:45:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
Message-ID: <20200310144551.177ddb0e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
        <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 00:17:23 +0530 sunil.kovvuri@gmail.com wrote:
> +static const struct ethtool_ops otx2vf_ethtool_ops = {

Please specify .supported_coalesce_params

> +	.get_link		= otx2_get_link,
> +	.get_drvinfo		= otx2vf_get_drvinfo,
> +	.get_strings		= otx2vf_get_strings,
> +	.get_ethtool_stats	= otx2vf_get_ethtool_stats,
> +	.get_sset_count		= otx2vf_get_sset_count,
> +	.set_channels		= otx2_set_channels,
> +	.get_channels		= otx2_get_channels,
> +	.get_rxnfc		= otx2_get_rxnfc,
> +	.set_rxnfc              = otx2_set_rxnfc,
> +	.get_rxfh_key_size	= otx2_get_rxfh_key_size,
> +	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
> +	.get_rxfh		= otx2_get_rxfh,
> +	.set_rxfh		= otx2_set_rxfh,
> +	.get_ringparam		= otx2_get_ringparam,
> +	.set_ringparam		= otx2_set_ringparam,
> +	.get_coalesce		= otx2_get_coalesce,
> +	.set_coalesce		= otx2_set_coalesce,
> +	.get_msglevel		= otx2_get_msglevel,
> +	.set_msglevel		= otx2_set_msglevel,
> +	.get_pauseparam		= otx2_get_pauseparam,
> +	.set_pauseparam		= otx2_set_pauseparam,
> +};
