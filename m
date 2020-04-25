Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECCF1B82E0
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgDYAsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgDYAsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 20:48:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AD932076C;
        Sat, 25 Apr 2020 00:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587775716;
        bh=75r/ntqonVIjNMYF0oPTE8nkeWDhk4HI+J/uXpvJk/I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KkNyHcR5BSUx1jyUT8fCv+J/9JDvufQIG035NiiFZ8GKLQd17TxXtN6g/u6TxmgXC
         4j/JEEM3FCQJQt89q21IILM4bLTxWadsqVR1A56jXmwwEzRaYLNC44H1Vxspe1/Ego
         WJ9idGmrCOSd3Dt1sAABASGnSQg32THZD8M0cMZc=
Date:   Fri, 24 Apr 2020 17:48:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>
Subject: Re: [PATCH net-next 16/17] net: atlantic: basic A2 init/deinit
 hw_ops
Message-ID: <20200424174834.655b2bc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200424072729.953-17-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
        <20200424072729.953-17-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Apr 2020 10:27:28 +0300 Igor Russkikh wrote:
> +	hw_atl2_rpf_rss_hash_type_set(self, 0x1FFU);
> +
> +	/* RSS Ring selection */
> +	hw_atl_reg_rx_flr_rss_control1set(self, cfg->is_rss ? 0xB3333333U :
> +							      0x00000000U);

nit: magic constants
