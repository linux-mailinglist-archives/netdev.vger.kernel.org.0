Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D33F2734B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfEWA3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:29:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEWA3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:29:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A9EC15042889;
        Wed, 22 May 2019 17:29:52 -0700 (PDT)
Date:   Wed, 22 May 2019 17:29:52 -0700 (PDT)
Message-Id: <20190522.172952.655043952831663687.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: move reset gpio parse & request to
 stmmac_mdio_register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522175752.0cdfe19d@xhacker.debian>
References: <20190522175752.0cdfe19d@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:29:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

