Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F80E2BC2B0
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgKUXpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgKUXpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:45:50 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF75220575;
        Sat, 21 Nov 2020 23:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606002350;
        bh=XWcSu9/Gyk26dxXsxoozhLOo7s7+nWjCKfCDGyIRh/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kWfsjPdsGzqPUc5zXhXU8hHnD9Od61lMDR/ljyJF6esAU4L0rPTzKSoBXA9NOua4D
         77u97i/1Nk3Mn8uJYegT6mZ9M+x5hTVaKlJk0G1GeaSH1ILz6CxQr2AiW5QbGmcPW9
         wzHhAJAuO+WblPKmP9taH+BhnaIM49VkCI0NjRhs=
Date:   Sat, 21 Nov 2020 15:45:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 15/15] ibmvnic: add some debugs
Message-ID: <20201121154549.10f6fb7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120224049.46933-16-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
        <20201120224049.46933-16-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 16:40:49 -0600 Lijun Pan wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> We sometimes run into situations where a soft/hard reset of the adapter
> takes a long time or fails to complete. Having additional messages that
> include important adapter state info will hopefully help understand what
> is happening, reduce the guess work and minimize requests to reproduce
> problems with debug patches.

This doesn't qualify as a bug fix, please send it to net-next.

> +	netdev_err(adapter->netdev,
> +		   "[S:%d FRR:%d WFR:%d] Done processing resets\n",
> +		   adapter->state, adapter->force_reset_recovery,
> +		   adapter->wait_for_reset);

Does reset only happen as a result of an error? Should this be a
netdev_info() instead?
