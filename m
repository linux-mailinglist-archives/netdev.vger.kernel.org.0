Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B79DAD0A1
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfIHUmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 16:42:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbfIHUmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 16:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QwXDVTAzTIEmbO6mkRqj9yinliGr7+s9z9v4Dam4EXQ=; b=XJ6NPqszO/x2cjMB+vINoqXTF3
        rRX0VYHp1xP4w1nJmp7+LMuDXIVp/Ly03njSNQG29lCn4NQ8X6P1nv/fua33DOiBSDHlslW4c0ClC
        lvuK8q1yJAE//jjtTOqtxLw+KBemRGjw/NbqmJe7Iua9XgBRGM8ITWaUzpiWGAADbZ5g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i740u-0001Ac-CM; Sun, 08 Sep 2019 22:42:24 +0200
Date:   Sun, 8 Sep 2019 22:42:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190908204224.GA2730@lunn.ch>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190906.145403.657322945046640538.davem@davemloft.net>
 <20190907144548.GA21922@lunn.ch>
 <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 08, 2019 at 12:07:27PM +0100, Vladimir Oltean wrote:
> I think Richard has been there when the taprio, etf qdiscs, SO_TXTIME
> were first defined and developed:
> https://patchwork.ozlabs.org/cover/808504/
> I expect he is capable of delivering a competent review of the entire
> series, possibly way more competent than my patch set itself.
> 
> The reason why I'm not splitting it up is because I lose around 10 ns
> of synchronization offset when using the hardware-corrected PTPCLKVAL
> clock for timestamping rather than the PTPTSCLK free-running counter.

Hi Vladimir

I'm not suggesting anything is wrong with your concept, when i say
split it up. It is more than when somebody sees 15 patches, they
decide they don't have the time at the moment, and put it off until
later. And often later never happens. If however they see a smaller
number of patches, they think that yes they have time now, and do the
review.

So if you are struggling to get something reviewed, make it more
appealing for the reviewer. Salami tactics.

    Andrew
