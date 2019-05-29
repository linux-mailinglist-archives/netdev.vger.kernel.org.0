Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB32D2DF3C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfE2OHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:07:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfE2OHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 10:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UAtojdJrkIwBlPuRlrigouBXylzVS9m7OnOAyuYNpMo=; b=rCPdAYpH+C0iab3EZch4tZHwRA
        rblAOTOJXGrAmrwlIRp1hBX99hbQXzSUwsGeYccRuTG3J7/8VESvvf2p58cZheZLw5+Cu/Ge/qQUV
        kLyMugnWluv2+4PmrfC0zqxLEMNORA3G47jYeAJKCz/3pN+mrGUlmTTaXsos/oTG0n40=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVzEh-0007OW-Nd; Wed, 29 May 2019 16:07:23 +0200
Date:   Wed, 29 May 2019 16:07:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [PATCH net-next v3 0/5] net: stmmac: enable EHL SGMII
Message-ID: <20190529140723.GE13689@lunn.ch>
References: <1559125118-24324-1-git-send-email-weifeng.voon@intel.com>
 <78EB27739596EE489E55E81C33FEC33A0B932F7F@DE02WEMBXB.internal.synopsys.com>
 <D6759987A7968C4889FDA6FA91D5CBC81470697E@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC81470697E@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 08:39:09AM +0000, Voon, Weifeng wrote:
> > 
> > Did you rebase this series against latest net-next tree ?
> > 
> > Because you are missing MMC module in your HWIF table entry. This module
> > was recently added with the addition of selftests.
> 
> No, the base is on last Thursday. Let me rebased on the latest net-next and submit for v4.

Hi Weifeng

Anything you submit needs to be on todays net-next. If the patches
don't apply cleanly using git am, David will automatically reject
them.

If you just want review, but not merge, please prefix the subject with
"RFC".

	Andrew
