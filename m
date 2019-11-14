Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019DFFD061
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKNVeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:34:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfKNVeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:34:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3E3D14A6F3BD;
        Thu, 14 Nov 2019 13:34:10 -0800 (PST)
Date:   Thu, 14 Nov 2019 13:34:08 -0800 (PST)
Message-Id: <20191114.133408.708754856568136468.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] net: stmmac: CPU Performance Improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BN8PR12MB326648DB784332302BD0D7A3D3710@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
        <BN8PR12MB326648DB784332302BD0D7A3D3710@BN8PR12MB3266.namprd12.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 13:34:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Thu, 14 Nov 2019 10:59:14 +0000

> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Date: Nov/13/2019, 15:12:01 (UTC+00:00)
> 
>> CPU Performance improvements for stmmac. Please check bellow for results
>> before and after the series.
> 
> Please do not apply this. I found an issue with patch 1/7 and I have 
> some more changes that reduce even more the CPU usage.

Ok.
