Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0600B628EE3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiKOBGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKOBGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:06:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5897FBF64
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fom2+lhS8uDc1XwFBswwmLnXIDTPUoFwtuNqRxDtBQc=; b=dYQoDawk05304mfJ7whPXzhl66
        M80NZ4j1l3G81TsTrdeSyJNfp0qYkMtlu78MDQHV8Rfa0IMEfqSOYTGBIqbg9L7yz/BaEtWIF/fs5
        Qw9MK9JIPRITwoE17fHeCuk+uggioVTuo9Ao2Li+rPZt+uVis0bSnVFsBtKpdys7ijTU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oukP5-002Ogp-18; Tue, 15 Nov 2022 02:06:19 +0100
Date:   Tue, 15 Nov 2022 02:06:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        David Thompson <davthompson@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <Y3LmC7r4YP++q8fa@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
 <20221109224752.17664-4-davthompson@nvidia.com>
 <Y2z9u4qCsLmx507g@lunn.ch>
 <20221111213418.6ad3b8e7@kernel.org>
 <Y29s74Qt6z56lcLB@x130.lan>
 <20221114165046.43d4afbf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114165046.43d4afbf@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  > I am not advocating for black magic tables of course :), but how do we
> > avoid them if request_firmware() will be an overkill to configure such a
> > simple device? Express such data in a developer friendly c structures
> > with somewhat sensible field names?
> 
> I don't feel particularly strongly but seems like something worth
> exploring. A minor advantage is that once the init is done the tables
> can be discarded from memory.

I wondered about that, but i'm not sure initdata works for modules,
and for hot pluggable devices like PCIe, you never know when another
one might appear and you need the tables.

    Andrew
