Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF8E12A073
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 12:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLXLZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 06:25:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfLXLZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 06:25:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RlgHb21b1QROs2UcIgO+a02Y6c38zuK0+5BmDk4rpWk=; b=a634Z6nfsEg2DuTjgk0y38H9Aj
        eHijwgzBFVvP96OpECb5Qi7CryXjfxc8xCZzbzQ8aKE0zIlh1L2GIM57KkQ8BwqI2QUtgHxvll7BL
        o7m6Tg/te4WWhrENOytd67H6kHwxSAZsw1moLIcICSws6yrouXMsJ4y8bRpMA4UrGKgE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijiJP-0002Ib-2P; Tue, 24 Dec 2019 12:25:15 +0100
Date:   Tue, 24 Dec 2019 12:25:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, linux@rempel-privat.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: drop pointless static qualifier in
 ar9331_sw_mbus_init
Message-ID: <20191224112515.GE3395@lunn.ch>
References: <20191224024059.184847-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224024059.184847-1-maowenan@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 10:40:59AM +0800, Mao Wenan wrote:
> There is no need to have the 'T *v' variable static

What does 'T *v' mean?

The patch itself looks O.K, but the description should be better, and
the subject line.

    Andrew
