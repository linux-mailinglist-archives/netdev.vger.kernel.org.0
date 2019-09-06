Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0656DABACB
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394423AbfIFOY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:24:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731142AbfIFOY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/3kJslcsbLFpzXlWoY8tRFbsCSBonRCniOnFy3oERXU=; b=gJhYEymzraY57EbVrvakhHIUWv
        arbMFbEonMimoz0+VsPCJoCh4ykhpTdMavMdX/8Zjeo2h3qszYihuTy+u+l6Py1W+YWL8odC3lI+q
        jk9K4gg2kIaPhboA/dJDTK3oZyzWewdjW3PfHqKSlkZqPdIgAy7HWZ+ucQjQ6jTtZ2Qo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6FAM-0007mj-6u; Fri, 06 Sep 2019 16:24:46 +0200
Date:   Fri, 6 Sep 2019 16:24:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v3 net-next] net: stmmac: Add support for MDIO interrupts
Message-ID: <20190906142446.GA29611@lunn.ch>
References: <1567685130-8153-1-git-send-email-weifeng.voon@intel.com>
 <BN8PR12MB3266D427D1AB8E41B13441B6D3BA0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266D427D1AB8E41B13441B6D3BA0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 01:31:14PM +0000, Jose Abreu wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> Date: Sep/05/2019, 13:05:30 (UTC+00:00)
> 
> > DW EQoS v5.xx controllers added capability for interrupt generation
> > when MDIO interface is done (GMII Busy bit is cleared).
> > This patch adds support for this interrupt on supported HW to avoid
> > polling on GMII Busy bit.
> 
> Better leave the enabling of this optional because the support for it is 
> also optional depending on the IP HW configuration.

Hi Jose

If there a register which indicates if this feature is part of the IP?

   Andrew
