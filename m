Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A1026B1CC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgIOWg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbgIOWgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:36:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36822C061788;
        Tue, 15 Sep 2020 15:36:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A81F713757C20;
        Tue, 15 Sep 2020 15:19:22 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:36:09 -0700 (PDT)
Message-Id: <20200915.153609.180837989360811070.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     oded.gabbay@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        f.fainelli@gmail.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915213735.GG3526428@lunn.ch>
References: <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com>
        <20200915213735.GG3526428@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:19:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 15 Sep 2020 23:37:35 +0200

>> I understand your point of view but If my H/W doesn't support the
>> basic requirements of the RDMA infrastructure and interfaces, then
>> really there is nothing I can do about it. I can't use them.
> 
> It is up to the RDMA people to say that. They might see how the RDMA
> core can be made to work for your hardware.

+1
