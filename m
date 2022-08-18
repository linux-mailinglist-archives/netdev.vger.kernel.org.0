Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38159913D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 01:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344190AbiHRXhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 19:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbiHRXhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 19:37:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DF5DB06F;
        Thu, 18 Aug 2022 16:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9C5KsukRVJHXGzRlbxMMEGRJtlFj7u22dMZBtqxFfaI=; b=AqJI+t9psThJvwjW2/B8Fpnx5g
        FDCqS1ROrdFqSRzTMS1wtmAT21YR+00S9SMB3I5EumaikAihXB+w/EE8gP8m6CNZ7YPd35jAX/ZN9
        0hdrVGUtxgCjVizZSxeX3ay2gLyYHA0Gnxj1kWXfz5EtL3CqQD1G5sLmyip0h7J9Tibo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOp4E-00Dr71-Hp; Fri, 19 Aug 2022 01:36:50 +0200
Date:   Fri, 19 Aug 2022 01:36:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [net-next v4 1/3] net: phy: adin1100: add PHY IDs of
 adin1110/adin2111
Message-ID: <Yv7NEv6EYjCKVLoF@lunn.ch>
References: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
 <20220817160236.53586-2-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817160236.53586-2-andrei.tachici@stud.acs.upb.ro>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 07:02:34PM +0300, andrei.tachici@stud.acs.upb.ro wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add additional PHY IDs for the internal PHYs of adin1110 and adin2111.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
