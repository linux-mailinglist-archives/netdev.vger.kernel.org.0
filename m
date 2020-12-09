Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C32D447A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733082AbgLIOgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:36:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730402AbgLIOgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:36:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn0ZI-00B4BY-In; Wed, 09 Dec 2020 15:35:48 +0100
Date:   Wed, 9 Dec 2020 15:35:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next] net: mv88e6xxx: convert comma to semicolon
Message-ID: <20201209143548.GH2611606@lunn.ch>
References: <20201209133938.1627-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209133938.1627-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 09:39:38PM +0800, Zheng Yongjun wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
