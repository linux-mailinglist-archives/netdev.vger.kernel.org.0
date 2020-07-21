Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44412228929
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgGUTbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgGUTbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:31:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE59E20717;
        Tue, 21 Jul 2020 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595359879;
        bh=MNvVzIEdaZu1xtvtvEhKCAgoe9Ey0Nt5/vyodyNzxno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HDqpqbTUFT9zdLx6EeCgpsxslXAeYjtuXVfvbuGP/mrKCtyEPtkxg0/WJgzGofnvW
         xZsUPCkMuol5SlPttxqmvA4XiiYUzm87Djh0001DP5oUU1GJsYYrRDEZsV3E6Mh+C8
         JvVyj3346QDO6VNPYClf4tVatVz6hlKHLSBE3Kj4=
Date:   Tue, 21 Jul 2020 12:31:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: add support for TBF offload
Message-ID: <20200721123117.3eca460f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721163825.9462-1-ioana.ciornei@nxp.com>
References: <20200721163825.9462-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 19:38:22 +0300 Ioana Ciornei wrote:
> This patch set adds support for TBF offload in dpaa2-eth.
> The first patch restructures how the .ndo_setup_tc() callback is
> implemented (each Qdisc is treated in a separate function), the second
> patch just adds the necessary APIs for configuring the Tx shaper and the
> last one is handling TC_SETUP_QDISC_TBF and configures as requested the
> shaper.


Reviewed-by: Jakub Kicinski <kuba@kernel.org>
