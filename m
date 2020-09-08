Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54129261C48
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731496AbgIHTR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731756AbgIHTRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:17:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F08E02076C;
        Tue,  8 Sep 2020 19:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599592625;
        bh=vZujyYXl3Ehp7qCYpINwc2XazcT5xcTsvD5idNj0Lis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h8OeMc5xC4SmSkna3KgyaGZQXuQB+Qk/V/s6+W9pw5ty8MfWn5z7uNWStnDFYJZpH
         G0T1U8hCXOWlFbNanxYITUInJ/qoi2f6ddDC0PcK25iWmQl0rY7+nvcpoUlqk2aBZF
         XELrnMUd2bvH/4BPiIEXi44g2SGmLAS4M/sDVbgU=
Date:   Tue, 8 Sep 2020 12:17:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v3 5/9] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
Message-ID: <20200908121703.24517604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908183909.4156744-6-awogbemila@google.com>
References: <20200908183909.4156744-1-awogbemila@google.com>
        <20200908183909.4156744-6-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 11:39:05 -0700 David Awogbemila wrote:
> @@ -213,6 +235,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  	} else {
>  		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
>  	}
> +
>  	/* walk TX rings */
>  	if (priv->tx) {
>  		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
> @@ -235,6 +258,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
>  	} else {
>  		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
>  	}
> +

Again, these white space changes don't belong in this patch.
