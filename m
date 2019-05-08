Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9A917906
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 14:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbfEHMFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 08:05:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58487 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbfEHMFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 08:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I9SBp20TR9YMdcudsmTde2Jybsa8KlVOvbp9rA9Y1q0=; b=50ie19Oq8hRumDeP1PKGF2DiZB
        PF3jzGZzZmYp2xEU4+zJocpr/BUXydmCng++AAQDaNN/UAcPpAEzRygKViKT9oVf+EMkKyCtFElA7
        fg064r4pjqI97TEPwrtmGiRXYnK2g37AnI4UCSFIpFq8g+JuPmuxrIpjgCbOcORI4Dyw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOLJi-0001A3-J4; Wed, 08 May 2019 14:04:58 +0200
Date:   Wed, 8 May 2019 14:04:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 07/11] net: stmmac: dwmac1000: Also pass control
 frames while in promisc mode
Message-ID: <20190508120458.GD30557@lunn.ch>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <c6c1449e173dc4805f5fc785f1906e4392ccc66f.1557300602.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c1449e173dc4805f5fc785f1906e4392ccc66f.1557300602.git.joabreu@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 09:51:07AM +0200, Jose Abreu wrote:
> In order for the selftests to run the Flow Control selftest we need to
> also pass control frames to the stack.

Hi Jose

Do you mean pause frames?

   Thanks
	Andrew
