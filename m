Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEF747C823
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhLUUL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:11:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233679AbhLUULz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 15:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H6WiCsTBF0Mj/1BBGZ/QIUoU5L9v1U+PUEzb9y+rAB0=; b=0JmHQtMJckzi8OSsuRaLuYpt2w
        x5Co1tuRleJeA5OrFjM+YPITSPNuUM8p8CdXqx7BaPqZVNZVq7SE24Uy7dt6PJPQNNTV/kBLuc45p
        U8HZ/cwUk4+bQE9l03UbOoiwb/IjCFBvHh+jiMGMbM8xP9cBPEt5uh4mQNq3aJm4yrsY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzlUE-00HAIG-08; Tue, 21 Dec 2021 21:11:50 +0100
Date:   Tue, 21 Dec 2021 21:11:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        robert.foss@collabora.com, freddy@asix.com.tw,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] asix: fix wrong return value in
 asix_check_host_enable()
Message-ID: <YcI1Ba/j9mgubGKo@lunn.ch>
References: <8966e3b514edf39857dd93603fc79ec02e000a75.1640117288.git.paskripkin@gmail.com>
 <ecd3470ce6c2d5697ac635d0d3b14a47defb4acb.1640117288.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecd3470ce6c2d5697ac635d0d3b14a47defb4acb.1640117288.git.paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 11:10:43PM +0300, Pavel Skripkin wrote:
> If asix_read_cmd() returns 0 on 30th interation, 0 will be returned from
> asix_check_host_enable(), which is logically wrong. Fix it by returning
> -ETIMEDOUT explicitly if we have exceeded 30 iterations
> 
> Also, replaced 30 with #define as suggested by Andrew
> 
> Fixes: a786e3195d6a ("net: asix: fix uninit value bugs")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
