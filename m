Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6448C3D16FE
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 21:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhGUSiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 14:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238552AbhGUSiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 14:38:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A176C6121F;
        Wed, 21 Jul 2021 19:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626895116;
        bh=O7RmbrWBMFYhO559U+kYd50JMQyOzBHj+hbyIeatmH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cpE+KsEcPnUnG1aTE3Tmaxv+nCquUOmfmnh7u5fppJxvkcGZNZir4yow3BRMYCllY
         n5sfWFSexnN+2fJyN92qCMx5Y6kznTbiSNMeFbcYFHHh5QNMo0EGUSWxj/BqC2CSop
         6nUAb+g91+usMkNImjP9Zg8bGQMf+WS1+O5w6M1mHtnps99mS/GINevJL4VVgifBH8
         xSrv0if/NG2LG6ln6OjQJ7s6K9xbAKkbX968K/qgANgYA4Ha7SW39V1M5y68azXLNa
         mKPjH8tRPdeG9q4ryXbvxvuuX3SgX5yMA6E6uABD2IoiJrHjM2rYrKl841WiHA8kKj
         nM32UzBanopCQ==
Date:   Wed, 21 Jul 2021 21:18:31 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210721211831.4b76c614@thinkpad>
In-Reply-To: <YPV6+PQq1fvH8aSy@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
        <20210716212427.821834-6-anthony.l.nguyen@intel.com>
        <YPIAnq6r3KgQ5ivI@lunn.ch>
        <87y2a2hm6m.fsf@kurt>
        <YPV6+PQq1fvH8aSy@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 15:15:36 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > Are there better ways to export this?  
> 
> As i said in another email, using LED triggers. For simple link speed
> indication, take a look at CONFIG_LED_TRIGGER_PHY.

Please don't use LED_TRIGGER_PHY. The way this driver works is against
the ideas of LED subsystem and we would like to deprecate it.

All network related LED control should be somehow configured via the
"netdev" trigger. I am working on extending "netdev" trigger for this
purpose. But first we need to be able to at least support offloading of
LED triggers. Hopefully I will send another version for that this week.

Marek
