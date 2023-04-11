Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1547D6DDB39
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjDKMwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDKMve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:51:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E204C3598;
        Tue, 11 Apr 2023 05:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uxJTfwv0wdpQbFZJ9k0V/nSq1aA6F2nbYse/qTU2knQ=; b=FoeV8lsvAPH8vCnfNmz79pmXFa
        FI/gIlS6KHBXm2rg1ONSVv6qEbeK5Mii43rKzYSYAVueVBcHN1A4dl4u7Xz5ZEPIv7mJEF3F3Myz3
        9q+NLmqnSRNm65gAKaqvTDYXHUDuLHS3jeLhD/2vPyhIvgS5bLcpa4WQoFiyPu0zLoPo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmDT8-009zQ8-RF; Tue, 11 Apr 2023 14:51:30 +0200
Date:   Tue, 11 Apr 2023 14:51:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 1/6] net: txgbe: Add software nodes to
 support phylink
Message-ID: <822ebdc2-3f3e-40e9-a41e-dcce1c4773b2@lunn.ch>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411092725.104992-2-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:27:20PM +0800, Jiawen Wu wrote:
> Register software nodes for GPIO, I2C, SFP and PHYLINK. Define the
> device properties.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
