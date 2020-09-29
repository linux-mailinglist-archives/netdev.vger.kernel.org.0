Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF45527D334
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgI2P4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgI2P4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 11:56:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E9032074F;
        Tue, 29 Sep 2020 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601394961;
        bh=NvlXqJ6kaOpYTfqei/zS8YtZLpsopLIn9sgcK/GqrRY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f/IMmA6VDPZdI1hXqGcZ5KEqFiessFLqm96+lBKcu7WIKGqkljhrSW7Di3jMLFyRf
         bbpEid+iuArI6Znb6Q13OozlKcNq3kavwBQ7Ekpi07as49aKvt24Zy7yvqPXM8peJJ
         DiSYPoyNv22x89F0qRLAOp03D0fI4k45eVeTBUBc=
Date:   Tue, 29 Sep 2020 08:55:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     bjorn.andersson@linaro.org, davem@davemloft.net,
        netdev@vger.kernel.org, clew@codeaurora.org,
        manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH 2/2] net: qrtr: Allow non-immediate node routing
Message-ID: <20200929085559.0ee3564c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601386397-21067-2-git-send-email-loic.poulain@linaro.org>
References: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
        <1601386397-21067-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 15:33:17 +0200 Loic Poulain wrote:
> +	if (cb->type == QRTR_TYPE_NEW_SERVER) {
> +		/* Remote node endpoint can bridge other distant nodes */
> +		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
> +		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));

checkpatch says:

WARNING: Missing a blank line after declarations
#47: FILE: net/qrtr/qrtr.c:501:
+		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
