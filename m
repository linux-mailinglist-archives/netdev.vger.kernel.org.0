Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC36844E07
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbfFMVC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:02:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbfFMVCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:02:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7779149B35BB;
        Thu, 13 Jun 2019 14:02:24 -0700 (PDT)
Date:   Thu, 13 Jun 2019 14:02:24 -0700 (PDT)
Message-Id: <20190613.140224.1206764737513427353.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next 0/3] net: stmmac: Convert to phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1560266175.git.joabreu@synopsys.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 14:02:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue, 11 Jun 2019 17:18:44 +0200

> [ Hope this diff looks better (generated with --minimal) ]
> 
> This converts stmmac to use phylink. Besides the code redution this will
> allow to gain more flexibility.

Series applied, thank you.
