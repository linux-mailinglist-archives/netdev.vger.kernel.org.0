Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3625E488
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 02:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgIEAKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 20:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgIEAKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 20:10:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BDD6208FE;
        Sat,  5 Sep 2020 00:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599264599;
        bh=P/6uRSKbc276FtT+BF2FCS1nLO3Isxb5xURf1YHtXCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kotxlg9gdljRKVFnlVGjSRirPUAw0VjAM2+kv2MMbw7NNr/KRAGbQ/qP+LxCx8jf1
         EBl9Y+/ANHoA6CJTtV9q8wa6gtmq3MFnyQ6/ipRCZVC3LuV2dFHY4kakkmdSPYk0Dd
         Q1p085pqITMVNoaOs7qqLD7DJwzHC4K0FBYxhSZI=
Date:   Fri, 4 Sep 2020 17:09:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH net-next 8/9] net: ethernet: ti: ale: switch to use
 tables for vlan entry description
Message-ID: <20200904170957.11a8068d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904230924.9971-9-grygorii.strashko@ti.com>
References: <20200904230924.9971-1-grygorii.strashko@ti.com>
        <20200904230924.9971-9-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 02:09:23 +0300 Grygorii Strashko wrote:
> The ALE VLAN entries are too much differ between different TI CPSW ALE
> versions. So, handling them using flags, defines and get/set functions
> became over-complicated.
> 
> This patch introduces tables to describe the ALE VLAN entries fields, which
> are different between TI CPSW ALE versions, and new get/set access
> functions. It also allows to detect incorrect access to not available ALL
> entry fields.

When building with W=1 C=1:

drivers/net/ethernet/ti/cpsw_ale.c:179:28: warning: symbol 'vlan_entry_cpsw' was not declared. Should it be static?
drivers/net/ethernet/ti/cpsw_ale.c:187:28: warning: symbol 'vlan_entry_nu' was not declared. Should it be static?
drivers/net/ethernet/ti/cpsw_ale.c:63: warning: Function parameter or member 'num_bits' not described in 'ale_entry_fld'
