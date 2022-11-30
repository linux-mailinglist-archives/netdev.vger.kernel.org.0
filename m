Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E868C63DCEA
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiK3SRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiK3SRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:17:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3139490C;
        Wed, 30 Nov 2022 10:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qYl9eamrN/o9V2phN9Tz5nOT280TdKaFY7cXZJlG/KU=; b=PKSNyHkbpvE6kXeKbpHRWRzOIS
        Dk1jm4LTrZONw89eTbTe+U2JRFro9tEYC4aFbeEyNBTNqolJjFILGnm/VrW/9wsCkHIRFt2GWr10G
        /nB+cVXO/alzyt2e+88/D/fvDfQ8elKnEpqwKDh2c1VyaK1XfvJaLhli+T5h+cq419ng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0Raw-003zGD-KQ; Wed, 30 Nov 2022 19:14:06 +0100
Date:   Wed, 30 Nov 2022 19:14:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chester Lin <clin@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y4edbi24amZSGfFZ@lunn.ch>
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
 <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
 <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please compare v1: There is no Linux-driven clock controller here but rather
> a fluid SCMI firmware interface. Work towards getting clocks into a
> kernel-hosted .dtsi was halted in favor of (downstream) TF-A, which also
> explains the ugly examples here and for pinctrl.
> 
> Logically there are only 5 input clocks; however due to SCMI not supporting
> re-parenting today, some clocks got duplicated at SCMI level. Andrew
> appeared to approve of that approach. I still dislike it but don't have a
> better proposal that would work today. So the two values above indeed seem
> wrong and should be 11 rather than 5.

Just be aware, you are setting an ABI here. So your fluid SCMI
firmware interface must forever support this.

	 Andrew
