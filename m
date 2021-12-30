Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E840B481EA7
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbhL3Rkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:40:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhL3Rkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 12:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gOLlLhBtyS3xQmGRKD86PkqAOZ/izC/ka4cQqqsC15Q=; b=qzN8sDFL5oNQsVopDCxJIbq/Zs
        NMDuUjWpIlU0o2d+mWS6biAGRY81sR0FmovB6tA83n7Lfs5rdockgHIA/bse4sWbi5GGsz7tCTSBs
        cXn2itZBMiJxZMOjYRLEj9JAhPA8DWHj0fo6hpweOs2/tdnva/kNupkPGax1PHR9fTqw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n2zPh-000BEO-Bw; Thu, 30 Dec 2021 18:40:29 +0100
Date:   Thu, 30 Dec 2021 18:40:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] net/funeth: probing and netdev ops
Message-ID: <Yc3vDQ0cFE6vm0Ul@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-4-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230163909.160269-4-dmichail@fungible.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int msg_enable;
> +module_param(msg_enable, int, 0644);
> +MODULE_PARM_DESC(msg_enable, "bitmap of NETIF_MSG_* enables");
> +

Module params are not liked. Please implement the ethtool op, if you
have not already done so.

     Andrew
