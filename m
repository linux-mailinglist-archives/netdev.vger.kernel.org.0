Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C581C30184D
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbhAWUP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbhAWUPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 15:15:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0B4422B43;
        Sat, 23 Jan 2021 20:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611432880;
        bh=yQY0ZU2W2juvyghuv5Vg/gZ0L6Ph7tHiMt2JkJaDxCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NGnhRS1LHV9ZXAS3NU3TmBBsI9FON0NGL696DoqjsKUFgT3AhyyeewRe1H7RDtGh1
         sKUGPFmqn4OvDH3y2dixCPUEsbl5XzAxHVlCilK0ZpkctId7lUFU9djN8uTnG8ndlC
         BkTvym8JDUC+tJ8ke7AjahaqtQrIsTH4ItDRqRlqb5ld3gRs/JqzNjU9mEgF2r2Ir9
         e9SrUWQXzMIf4/4qF0QmhCDCuozVQJsBB4Seng2QkikCP19Of4kog2kJ3ylx4Davdz
         ufWzUUI08UD2ntBQr4Jkd/j/0gx9VaITvlF7RUJyTad9Aem9n2mfglvufXygbdcD0x
         MfYkhsjqYJeqQ==
Date:   Sat, 23 Jan 2021 12:14:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Message-ID: <20210123121439.4290b002@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123160348.GB2799851@shredder.lan>
References: <AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
        <20210123160348.GB2799851@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 18:03:48 +0200 Ido Schimmel wrote:
> 	[DEVLINK_ATTR_STATS_RX_DROPPED]

nit: maybe discarded? dropped sounds like may have been due to an
overflow or something
