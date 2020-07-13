Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5968521E383
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 01:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGMXIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 19:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGMXIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 19:08:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C16392065F;
        Mon, 13 Jul 2020 23:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594681716;
        bh=h9Pw3VkY1VDTGmkKAB9QJBdvVcRuqZayaqH8bPjk9rI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TXtCAriu9l66KQTYa5AAA/rreZhRvpZJZ7CcK3VF/Y21MZy+EfpRrZ4DrQfs6+m8f
         St4KSyjpU4L1/JFBn84mLbqpYE9wsnpTWo4UIxS6EGISIgQhAf7jh1HRl5un5SKVgW
         kIqFQNCZKwPkjxZVHjCU+YKcgGXQsDI/zkuq+llo=
Date:   Mon, 13 Jul 2020 16:08:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
Message-ID: <20200713160834.1bf14e25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
        <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 12:32:16 +0100 Edward Cree wrote:
> +	if (offset > pci_resource_len(efx->pci_dev, bar) - sizeof(uint32_t) * 2) {

Please remove all the uint32_ts
