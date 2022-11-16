Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D4B62BF55
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiKPNW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiKPNWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:22:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FC623EA1;
        Wed, 16 Nov 2022 05:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cEubFAXTxlXp4Bl5RMHL1mpPTLghpJ/m8vKWINbfjC0=; b=KbRLKJCKeyKw7SV6cIFscmYNs5
        LugG1OfVv5brn3pH5WqXqdTD7nDpRkzy5j7kv2jFIIOhsK8EKsSfZbiVOu3FSbAVmWqYr4AIwf0eU
        LgyYJZYkyCW73jpIGruke2tctc8hR8WkypR+yCiecbi4flVawilGAKK9y6B3RM481wfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovILk-002ZLK-Bt; Wed, 16 Nov 2022 14:21:08 +0100
Date:   Wed, 16 Nov 2022 14:21:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        edumazet@google.com, mw@semihalf.com, linux@armlinux.org.uk,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yusongping@huawei.com
Subject: Re: [PATCH net v4] net: mvpp2: fix possible invalid pointer
 dereference
Message-ID: <Y3TjxEd9tbsyv24v@lunn.ch>
References: <20221116020617.137247-1-tanghui20@huawei.com>
 <20221116021437.145204-1-tanghui20@huawei.com>
 <20221115202850.7beeea87@kernel.org>
 <a061d870-d0ce-a580-636d-600a9a4b006f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a061d870-d0ce-a580-636d-600a9a4b006f@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for pointing out, but should I resend it with [PATCH net v3]
> or [PATCH net v5]?

The number should always increment. It is how we tell older versions
from newer versions.

     Andrew
