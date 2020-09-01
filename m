Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7D225A11E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgIAWCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:02:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgIAWCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 18:02:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDELo-00Cotb-4m; Wed, 02 Sep 2020 00:02:00 +0200
Date:   Wed, 2 Sep 2020 00:02:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Kevin(Yudong) Yang" <yyd@google.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH ethtool] ethtool: add support show/set-hwtstamp
Message-ID: <20200901220200.GB3050651@lunn.ch>
References: <20200901212009.1314401-1-yyd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901212009.1314401-1-yyd@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 05:20:09PM -0400, Kevin(Yudong) Yang wrote:
> Before this patch, ethtool has -T/--show-time-stamping that only
> shows the device's time stamping capabilities but not the time
> stamping policy that is used by the device.

Hi Kavin

How does this differ from hwstamp_ctl(1)?

    Andrew
