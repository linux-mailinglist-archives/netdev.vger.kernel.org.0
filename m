Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E1C26482F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgIJOqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgIJOkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:40:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12E6720720;
        Thu, 10 Sep 2020 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599748849;
        bh=WHknBI+/uvnrKWBaBtTxA8PK3a2mGjbqxDWmtIr6flg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zZUttjwbSweGR26v9xA+eQvCQxkWcKia8yy3XoMJJib8Dd9bpLGYhnY6jwby4gw/y
         2AQxoIBao2u/UQM+VQEL3PBvtDgQElhOzNRmKtExnf2T/qIRniaMGfSWHU/Uo5WiAu
         ZMHFGuTff7Mdm6uhRfy5w8HVThALMyjSnxf4NuV8=
Date:   Thu, 10 Sep 2020 07:40:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 2/5] dpaa2-eth: define a global ptp_qoriq structure
 pointer
Message-ID: <20200910074047.046583a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910093835.24317-3-yangbo.lu@nxp.com>
References: <20200910093835.24317-1-yangbo.lu@nxp.com>
        <20200910093835.24317-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 17:38:32 +0800 Yangbo Lu wrote:
> Define a global ptp_qoriq structure pointer, and export to use.
> The ptp clock operations will be used in dpaa2-eth driver.
> For example, supporting one step timestamping needs to write
> current time to hardware frame annotation before sending and
> then hardware inserts the delay time on frame during sending.
> So in driver, at least clock gettime operation will be needed
> to make sure right time is written to hardware frame annotation
> for one step timestamping.

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:34:18: warning: symbol 'dpaa2_ptp' was not declared. Should it be static?
