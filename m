Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7944D9189
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343864AbiCOAaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343817AbiCOAaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:30:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C7E43EF4;
        Mon, 14 Mar 2022 17:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qQtXTU8ksUIwdmpceTImoN53WCbF2ijK28WT1MKUOjc=; b=2dc2PnDBLqfcWIsEW9s1tE3T1N
        1yhNfuCaUhKUpY86pcyE+imyZHmcArYP+LB+LdkGAQNPptXK5ZqP94qSR2x6zHqAlbd9PVn7dT1IP
        clxo5iu8TagUJ6tGGZQmTf1NeI5fRN6rpFDeNct75Oqvg4wMKu9id9sDFXyu9KTen8SM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTv2S-00AqHd-9H; Tue, 15 Mar 2022 01:27:48 +0100
Date:   Tue, 15 Mar 2022 01:27:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "huziji@marvell.com" <huziji@marvell.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "kostap@marvell.com" <kostap@marvell.com>,
        "robert.marko@sartura.hr" <robert.marko@sartura.hr>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/8] dt-bindings: pinctrl: mvebu: Document bindings
 for AC5
Message-ID: <Yi/dhK0NXg9g6J9T@lunn.ch>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-2-chris.packham@alliedtelesis.co.nz>
 <Yi/Y0iynQbIOo8C0@lunn.ch>
 <16fa529e-b1ca-11d0-f068-628c7f25a7fa@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16fa529e-b1ca-11d0-f068-628c7f25a7fa@alliedtelesis.co.nz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think it can. I vaguely remember seeing conditional clauses based on 
> compatible strings in other yaml bindings.
> 
> I started a new binding document because I expected adding significant 
> additions to the existing .txt files would be rejected. If I get some 
> cycles I could look at converting the existing docs from txt to yaml.
> 
> I'm not sure that there will be much in the way of a common 
> mvebu-pinctrl.yaml as you'd end up repeating most of the common stuff to 
> make things conditional anyway.

We should wait for Rob to comment. But is suspect you are right, there
will not be much savings.

     Andrew
