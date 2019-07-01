Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35605C23E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfGARqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:46:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbfGARqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:46:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7ECF014BFEDAC;
        Mon,  1 Jul 2019 10:46:30 -0700 (PDT)
Date:   Mon, 01 Jul 2019 10:46:29 -0700 (PDT)
Message-Id: <20190701.104629.2226806311615706825.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Subject: Re: [PATCH net-next v2 00/10] net: stmmac: 10GbE using XGMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BN8PR12MB32662DA0B5733E93D88E7D7DD3F90@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
        <20190628.092415.219171929303857748.davem@davemloft.net>
        <BN8PR12MB32662DA0B5733E93D88E7D7DD3F90@BN8PR12MB3266.namprd12.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 10:46:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon, 1 Jul 2019 10:19:55 +0000

> From: David Miller <davem@davemloft.net>
> 
>> About the Kconfig change, maybe it just doesn't make sense to list all
>> of the various speeds the chip supports... just a thought.
> 
> What about: "STMicroelectronics Multi-Gigabit Ethernet driver" ?
> 
> Or, just "STMicroelectronics Ethernet driver" ?

Maybe the first one is better, I don't know.  What are the chances of there
being more STMicroelectronics ethernet NICs? :-)

