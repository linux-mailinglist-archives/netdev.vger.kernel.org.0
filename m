Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC56D39033B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhEYOA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:00:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233331AbhEYOA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 10:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yk81UTHHtZAz6QPhDLpMTcZWhZ+n8sv02uF2NLJsfVo=; b=f+dvmSu3sUGAIZfUx0Fx0mD8ey
        IVHYT1wdfE3yJ4ceuek9Blm3z9f+7F4MSQEz+A/CEEMdE2covYKMqJh0+9CL/MUgxzBhsp1LSzaaw
        IQhg+P9rLMJ+ZJPR1OdEVkLIYR8IKNsH5nuGeLJEc4B/4WKTLBly1XctUI0s+rStqyzs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llXac-006BGy-D2; Tue, 25 May 2021 15:59:22 +0200
Date:   Tue, 25 May 2021 15:59:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] net: phy: fix yt8511 clang uninitialized variable
 warning
Message-ID: <YK0CujhxK0pKF9xq@lunn.ch>
References: <20210525122615.3972574-1-pgwipeout@gmail.com>
 <20210525122615.3972574-2-pgwipeout@gmail.com>
 <YKz1R2+ivmRsjAoL@lunn.ch>
 <CAMdYzYqHYu_aMw+EjeFP70HnbzJfC6md1fMT-yx0cs3MEF12ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYqHYu_aMw+EjeFP70HnbzJfC6md1fMT-yx0cs3MEF12ug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you want a v2 or will it be fixed on application?

A v2. And please remember to add the Reviewed-by tags.

  Andrew
