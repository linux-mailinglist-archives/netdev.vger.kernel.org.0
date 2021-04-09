Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139E835A5FC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbhDISn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhDISnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E7AB61056;
        Fri,  9 Apr 2021 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617993822;
        bh=KTMiyMN0luYY5R1RAgN++aNqE2Tb9RiuJiVlABFNVDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nVjIngZykL8xvbFtnZssMS+PUaYDi2ZU4MBiLskA8pSG01CSI1CptaJbymalFOX+D
         B5v0ZR3JlEmNF3zqjCYWjOOk+SHT8qq+t4jYGZLI89P4D8JC7GwfqIehLqMr5ZdapY
         VFA8ND/IZkx8uPPCjc165yOs5uJQmE+T1zoiTA2SFYAAYEIAboHn27WuvLCF+QDQyK
         5Xf/HiqF3nNFTLd/oBSEAggSNpYdB/arKLtPE4OnBN5cUJvQ8CZe4oLq+4HEkNQERZ
         5lrkik+kqRLPvIDvTOyiYcn24M4/FjyxTVEQVxmIoT7QwuPKYDU1ZXWAQmGnRXeIM9
         ogmbtjfFIIfJQ==
Date:   Fri, 9 Apr 2021 11:43:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH net-next 0/3] net: add new properties for
 of_get_mac_address from nvmem
Message-ID: <20210409114341.1ed508d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
References: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Apr 2021 17:07:08 +0800 Joakim Zhang wrote:
> This patch set adds new properties for of_get_mac_address from nvmem.

Apart from addressing Rob's (and potentially other comments to come)
please also make sure to rebase before posting. This series doesn't
seem to apply to net-next.
