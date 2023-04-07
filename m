Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052826DAED5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240621AbjDGOYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjDGOYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:24:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EC97DBF;
        Fri,  7 Apr 2023 07:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KycbUd/6x6o2XMOQ7vp0xd2R5KmHrk0z1iFYchVzsqg=; b=j6fm2Ak1KD8Kw3gq3gVDuUSzZc
        MpRIm0tUIamuAwJwXUwtwFaLJhk00G3vAAS22MqmHDNT5Fp6S7u1GZ0NjuwH83h4gIjc+iwVkwU4G
        lAh9z9xviV+I/qiIlkvHqbh27YrIgWsHe+P5M4mvJw4dcMjUZJ9/9Trmx9z52SBvijvo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkn0Y-009jHJ-Gv; Fri, 07 Apr 2023 16:24:06 +0200
Date:   Fri, 7 Apr 2023 16:24:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: fix unsigned long
 multiplication overflow
Message-ID: <ab26b875-c10a-47af-a1e9-591812d4113f@lunn.ch>
References: <20230406095953.75622-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406095953.75622-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:59:53PM +0300, Radu Pirea (OSS) wrote:
> Any multiplication between GENMASK(31, 0) and a number bigger than 1
> will be truncated because of the overflow, if the size of unsigned long
> is 32 bits.
> 
> Replaced GENMASK with GENMASK_ULL to make sure that multiplication will
> be between 64 bits values.
> 
> Cc: <stable@vger.kernel.org> # 5.15+
> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
