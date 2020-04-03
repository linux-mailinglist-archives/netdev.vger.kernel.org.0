Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E085819E15B
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgDCXOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:14:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCXOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:14:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8596121938E8;
        Fri,  3 Apr 2020 16:14:14 -0700 (PDT)
Date:   Fri, 03 Apr 2020 16:14:14 -0700 (PDT)
Message-Id: <20200403.161414.635525483978443770.davem@davemloft.net>
To:     christophe.roullier@st.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, mripard@kernel.org,
        martin.blumenstingl@googlemail.com, alexandru.ardelean@analog.com,
        narmstrong@baylibre.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 0/2] Convert stm32 dwmac to DT schema
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200403140415.29641-1-christophe.roullier@st.com>
References: <20200403140415.29641-1-christophe.roullier@st.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Apr 2020 16:14:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Roullier <christophe.roullier@st.com>
Date: Fri, 3 Apr 2020 16:04:13 +0200

> Convert stm32 dwmac to DT schema
> 
> v1->v2: Remarks from Rob

I am assuming that the DT folks will pick this up.
