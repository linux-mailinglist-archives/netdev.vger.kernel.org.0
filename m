Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A0534D09D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhC2M4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:56:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52658 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhC2Mzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 08:55:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQrQt-00Dow1-OX; Mon, 29 Mar 2021 14:55:51 +0200
Date:   Mon, 29 Mar 2021 14:55:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH -next] net: phy: Correct function name
 mdiobus_register_board_info() in comment
Message-ID: <YGHOVx3F2eykwqxb@lunn.ch>
References: <20210329124046.3272207-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329124046.3272207-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 08:40:46PM +0800, Yang Yingliang wrote:
> Fix the following make W=1 kernel build warning:
> 
>  drivers/net/phy/mdio-boardinfo.c:63: warning: expecting prototype for mdio_register_board_info(). Prototype was for mdiobus_register_board_info() instead
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
