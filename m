Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D85C6243BA
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiKJN5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiKJN5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:57:39 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A33289;
        Thu, 10 Nov 2022 05:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EmIsB172ydNoGRcUDaU8FuBEMIPOVjKKdeSSvYitlPg=; b=lrNQqTx8KkUB+EFFkbpjSvdzZ/
        xE07egZW8M5WEEkCb0oN/G3NQnkSADLSSIR+QBz5/1mqqz6Pn6LmR5KVgNKznM4S63wdy/SjIWbLp
        G2il9nQzkF9a3Ccw5YFPcH23F3T+mhcz0AGKH8qJGzXZUC7hVlOnIur5HiBilCz33ozk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot83k-0022N4-0X; Thu, 10 Nov 2022 14:57:36 +0100
Date:   Thu, 10 Nov 2022 14:57:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.co,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Add xdp support
Message-ID: <Y20DT2XTTIlU/wbx@lunn.ch>
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
 <20221110111747.1176760-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110111747.1176760-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Nice stuff! I hear time to time that XDP is for 10G+ NICs only, but
> I'm not a fan of such, and this series proves once again XDP fits
> any hardware ^.^

The Freescale FEC recently gained XDP support. Many variants of it are
Fast Ethernet only.

What i found most interesting about that patchset was that the use of
the page_ppol API made the driver significantly faster for the general
case as well as XDP.

     Andrew
