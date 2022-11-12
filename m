Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EC1626A58
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 16:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiKLPyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 10:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiKLPyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 10:54:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7ABC5C
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 07:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0aVczw7FHcnOCc/kwvT9SzyNXnfHEK3I1GDLaDQYvzQ=; b=ayQGIX+ZprI50ZwusBRNPstvZd
        JQ72VPXGgl+9NukCq6bmUBBBUAm74zjrl/JHLvGGhn7jsjou8YysExmnhyRadZGbOzLlAXa4cVx6L
        /AWBlY2H6Isd3TAQTPIzV0XWx56nPxyoH+/RZCeizb9Rcr0t5VKTmZLZ4B/Mt3vRHSgM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otsoy-002C3n-No; Sat, 12 Nov 2022 16:53:28 +0100
Date:   Sat, 12 Nov 2022 16:53:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Thompson <davthompson@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <Y2/BeNsW4EH9v+Mv@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
 <20221109224752.17664-4-davthompson@nvidia.com>
 <Y2z9u4qCsLmx507g@lunn.ch>
 <20221111213418.6ad3b8e7@kernel.org>
 <Y29s74Qt6z56lcLB@x130.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y29s74Qt6z56lcLB@x130.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The recommendation is to come up with a format for a binary file, load
> > it via FW loader and then parse in the kernel?
> 
> By FW loader you mean request_firmware() functionality ?
> 
> I am not advocating for black magic tables of course :), but how do we
> avoid them if request_firmware() will be an overkill to configure such a
> simple device? Express such data in a developer friendly c structures
> with somewhat sensible field names?

Do you think anybody other than your company has the ability to change
these values? Is there useful documentation about what they do, even
if it is under NDA? Why would somebody actually need to change them?

Is here functionally here which you don't support but the community
might like to add?

Expressing the data in a developer friendly C structure only really
make sense if there is a small collection of developers out there who
have the skills, documentation and maybe equipment to actually make
meaningful changes.

I don't like making it harder to some clever people to hack new stuff
into your drivers, but there are so few contributions from the
community to your drivers that it might as well be black magic, and
just load the values from a file.

       Andrew
