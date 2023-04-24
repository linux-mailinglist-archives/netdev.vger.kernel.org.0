Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47376ECBAC
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDXL5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjDXL5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:57:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27F344B5;
        Mon, 24 Apr 2023 04:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ubpfDfIh4kmtwLmedEndw8F2mUty4/nfxyWX37tZIYE=; b=I+GV7Op+X7Mpo2LHpvmvchZ6z3
        nnc89B5vc+QtEtfov1op9iJUPNaDxYy8BhMPoecSdherN1BvB2Vda6B7viBicNVLwDTwunMxP/eEF
        hLxxcA5NH6MfHbzhcFl/pvq3/z8dLj3+a+424qGrxm1bx0b1ih7Q0z3yOS3z/8I0Gmnw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pquon-00B5DN-18; Mon, 24 Apr 2023 13:57:17 +0200
Date:   Mon, 24 Apr 2023 13:57:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     wuych <yunchuan@nfschina.com>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: phy: dp83867: Remove unnecessary (void*) conversions
Message-ID: <51b3c551-52af-41ab-98d0-5a23fa2fd97d@lunn.ch>
References: <20230424101550.664319-1-yunchuan@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424101550.664319-1-yunchuan@nfschina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 06:15:50PM +0800, wuych wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
