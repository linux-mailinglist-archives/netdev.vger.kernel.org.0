Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20071475FB2
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhLORrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:47:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232052AbhLORq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 12:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wEZ0+lTfI8a0MAszIs0A1GuF36x24QPM+U4kYJZN4eQ=; b=obHBnMzVIzoqMw5H9XKltxWYBa
        ZpteFhZfeuB9xN70M7J+3+7CEoW5UbbOrN6qAQAg979vJvE3M532N3Z7j4a0sMpIOLZALIwCNsYhf
        xA4cFxYqlCj+nqszWfFJk5XIhrY44PJZ845hWYXcFbn3ZerAldmygxnXp3niBfjtlgcM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxYMf-00GfkU-4j; Wed, 15 Dec 2021 18:46:53 +0100
Date:   Wed, 15 Dec 2021 18:46:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrey Eremeev <Axtone4all@yandex.ru>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED
Message-ID: <YboqDeIBwHE8+KcV@lunn.ch>
References: <20211215173032.53251-1-Axtone4all@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215173032.53251-1-Axtone4all@yandex.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 08:30:32PM +0300, Andrey Eremeev wrote:
> Debug print uses invalid check to detect if speed is unforced:
> (speed != SPEED_UNFORCED) should be used instead of (!speed).
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Andrey Eremeev <Axtone4all@yandex.ru>
> Fixes: 96a2b40c7bd3 ("net: dsa: mv88e6xxx: add port's MAC speed setter")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
