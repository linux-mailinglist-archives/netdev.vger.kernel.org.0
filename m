Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DECF4F6481
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbiDFPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiDFPyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:54:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C12E58C862
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 06:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hzz4Ns2p6Ur/Hq3YeDs/i+GMAbQj+BFKJpIDqNn8eos=; b=yWmv/4tiCl7r8e8Is8xIrU2J3o
        V962zJjI2EQpI3RJvosuNdv6OnSLUTGThrXNIpeTRzmpAflM6mhptuFk2Uq3lPJ3HBGbjyHJCOBzE
        JJpfIKkntyaUfcdUNEqSzkdVa7DsgrODNu/gXZChjUaPfhgY2R14EuV7w7SHDdb3WRe4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nc56d-00ERko-Fa; Wed, 06 Apr 2022 14:49:51 +0200
Date:   Wed, 6 Apr 2022 14:49:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Message-ID: <Yk2Mb9zUZZFaFLGm@lunn.ch>
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 10:32:12PM +0200, Lorenzo Bianconi wrote:
> Introduce support for the page_pool_get_stats API to mvneta driver.
> If CONFIG_PAGE_POOL_STATS is enabled, ethtool will report page pool
> stats.

Hi Lorenzo

There are a lot of #ifdef in this patch. They are generally not
liked. What does the patch actually depend on? mnveta has a select
PAGE_POOL so the page pool itself should always be available?

	  Andrew
