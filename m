Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E83A6937FA
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 16:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBLPjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 10:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLPjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 10:39:48 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BA7CA38;
        Sun, 12 Feb 2023 07:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6O+UuieJiqrqN8b+Jb4GL1MHOB3Fu+wejYkm3MKiKZs=; b=zVqRPIHa7Fd8aBKSeDGdpJrwuU
        nnpM2/LLxyc0jo150A976XoGkGIxo/Uf0HLi4TmqXPAIgnmkxe9ElLSPRjfuwbTF0dJPRAv7Ypvm4
        hktdh6pFGaDcHi1g6EYBPP0IV1BSyvZ74CW4F2SYfyEC2Iz/PlMxUecV2fM9AZype0fo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRERq-004lM2-VO; Sun, 12 Feb 2023 16:39:26 +0100
Date:   Sun, 12 Feb 2023 16:39:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Janne Grunau <j@jannau.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/4] dt-bindings: net: Add network-class schema for
 mac-address properties
Message-ID: <Y+kILknqMmR6+GXO@lunn.ch>
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
 <20230203-dt-bindings-network-class-v2-1-499686795073@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203-dt-bindings-network-class-v2-1-499686795073@jannau.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  max-frame-size:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Maximum transfer unit (IEEE defined MTU).

Do you have a reference you can include here to a clause in an IEEE
802 document? We need this unambiguously defined otherwise more DT
blobs are going to use the wrong value.

      Andrew
