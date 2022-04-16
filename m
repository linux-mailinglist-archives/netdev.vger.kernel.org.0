Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0A750370A
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 16:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiDPOPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 10:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiDPOPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 10:15:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE92D22BFF;
        Sat, 16 Apr 2022 07:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zm2yFV2VwgH65tCV5Rk2TxjgewNSgK3t1gG4Iq5BCRg=; b=dJqtS7kzsDpnj59SZIr+57C8WM
        LxFu4O9+H8k6pV8wocsFTasNDvECqI71OO9gH7yKw/o6YvDlBYYs/3T8HnGhAF1GKzkBuJbTImBs8
        CsGaJNeDm/EAa3Ki+rz30xW7NWGTLJBMGiL+U/o/OEtuiosJQ4p7Xxio5Bzh4CWA9X78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nfjAb-00G6o2-BN; Sat, 16 Apr 2022 16:13:01 +0200
Date:   Sat, 16 Apr 2022 16:13:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Message-ID: <YlrO7Q/a9bK0pWIA@lunn.ch>
References: <20220416062504.19005-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220416062504.19005-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 03:25:03AM -0300, Luiz Angelo Daros de Luca wrote:
> Compatible strings are used to help the driver find the chip ID/version
> register for each chip family. After that, the driver can setup the
> switch accordingly. Keep only the first supported model for each family
> as a compatible string and reference other chip models in the
> description.

It would be good to mention here that these compatible strings have
never been used in a released kernel, so it is safe to remove them.

That is the sort of information which makes the job of reviewing
patches simpler. It is great to have the answers to questions you
cannot see directly from the code in the commit message.

       Andrew
