Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66FCFAC709
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 16:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405995AbfIGOqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 10:46:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbfIGOqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 10:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SFLs9Wtw5K6HF7pbbP4w76MAtfouFt4h9mpnKSyF4Og=; b=NwMxhgpZGOv+n924F3G88DMzn1
        fOt9vYUhghodulcpr4pxkicGhYrCrBs3W98kWFfXGKnEDZHtypWaEtYGmWHJuYD1FuKC0B9PsWlmh
        t3xXNGRNzbCvmB/LJcZoTpaF4dDbQxyScoIVSfzITxcdj/BRpkW4wABWVCuzJthncz/Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6byG-0005nj-5J; Sat, 07 Sep 2019 16:45:48 +0200
Date:   Sat, 7 Sep 2019 16:45:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>, olteanv@gmail.com
Cc:     olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        richardcochran@gmail.com, weifeng.voon@intel.com,
        jiri@mellanox.com, m-karicheri2@ti.com, Jose.Abreu@synopsys.com,
        ilias.apalodimas@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190907144548.GA21922@lunn.ch>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190906.145403.657322945046640538.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906.145403.657322945046640538.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 02:54:03PM +0200, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Mon,  2 Sep 2019 19:25:29 +0300
> 
> > This is the first attempt to submit the tc-taprio offload model for
> > inclusion in the net tree.
> 
> Someone really needs to review this.

Hi Vladimir

You might have more chance getting this reviewed if you split it up
into a number of smaller series. Richard could probably review the
plain PTP changes. Who else has worked on tc-taprio recently? A series
purely about tc-taprio might be more likely reviewed by a tc-taprio
person, if it does not contain PTP changes.

    Andrew
