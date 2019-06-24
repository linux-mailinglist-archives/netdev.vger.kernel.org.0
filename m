Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2FB651E0E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfFXWQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:16:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55366 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfFXWQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 18:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fqMB6KPOoyOYzOUiYq/oFadK/vRhI57DeJHgkMuC5EU=; b=POJNmhHI++0cxJOHzjwNQHX0jf
        Y6YIWK2yPlQbwSdlm+OJlbfCD6p6LGQc5wGn84zThKAj2mA7hCKMjxH8/jk8TU1yXl0q4EiDXKCDG
        JVZVZC6HUmR1F6WnF9YzLLRUq2v8H9yRJoZFxGeIOGK133UuXJPpqm8LdX6L71Tbt/jM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfXGV-00013X-TU; Tue, 25 Jun 2019 00:16:43 +0200
Date:   Tue, 25 Jun 2019 00:16:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/8] net: aquantia: make all files
 GPL-2.0-only
Message-ID: <20190624221643.GG31306@lunn.ch>
References: <cover.1561388549.git.igor.russkikh@aquantia.com>
 <795f0f66ddf604a91de0f4a7734d0e9b282c7a3d.1561388549.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <795f0f66ddf604a91de0f4a7734d0e9b282c7a3d.1561388549.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 03:10:51PM +0000, Igor Russkikh wrote:
> It was noticed some files had -or-later, however overall driver has
> -only license. Clean this up.
> 
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
