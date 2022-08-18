Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9A7597B6D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242714AbiHRCTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 22:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiHRCTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 22:19:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922705AA0A
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 19:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xvFV9mDbC+6XIIPZ6fGxYqPoxuHHIEm3AawSJkUaPdY=; b=kIiWgiaB3MGeyXRR0du07t3pHZ
        39chriwBsHsCCIPENtMlxk6LUnOKhMo5FKq3vK4Z8OYTqXpPs4NFvyczrflxvWCxnOLOA9qQEpsiQ
        rcG0AmtG8ns8u6DP1+wxIAMZdZ1ZFocG1P9hUJZHOBrBj8CfptBluaDNEUjU+ArVuYBk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOV7e-00DhBs-8I; Thu, 18 Aug 2022 04:19:02 +0200
Date:   Thu, 18 Aug 2022 04:19:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Feiyang Chen <chris.chenfeiyang@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, Feiyang Chen <chenfeiyang@loongson.cn>,
        zhangqing@loongson.cn, chenhuacai@loongson.cn,
        netdev@vger.kernel.org, loongarch@lists.linux.dev
Subject: Re: [PATCH] stmmac: pci: Add LS7A support for dwmac-loongson
Message-ID: <Yv2hlkIpd8A66+iP@lunn.ch>
References: <20220816102537.33986-1-chenfeiyang@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816102537.33986-1-chenfeiyang@loongson.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 06:25:37PM +0800, Feiyang Chen wrote:
> Current dwmac-loongson only support LS2K in the "probed with PCI and
> configured with DT" manner. We add LS7A support on which the devices
> are fully PCI (non-DT).

Please could you break this patch up into a number of smaller
patches. It is very hard to follow what you are changing here.

Ideally you want lots of small patches, each with a good commit
message, which are obviously correct.

      Andrew
