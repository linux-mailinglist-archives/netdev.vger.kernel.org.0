Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1202C6D20EE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjCaMxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjCaMxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:53:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E79220DBF;
        Fri, 31 Mar 2023 05:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+Oc7fnMhQHzNj0HXIXXoSdujcdt4segVEP7/1Tk5JuY=; b=wgKJnhLgc6yB0txSCPwANSQaW8
        A2uYtnOrIDgGg8ZDFO9aURsO8ypjTIKS3yJKWK/zQlD4awrh5quqpom4IrLUarU3XRkrTSuk7BWGX
        XlJl7Dqic9hh7VQFrA9fbmEd9A3B5yRvjyuLOT0aqaPUvRd91XCL5+N1Tuze7TwpSBmE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1piEF0-0091oo-KR; Fri, 31 Mar 2023 14:52:26 +0200
Date:   Fri, 31 Mar 2023 14:52:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] net: phy: introduce phy_reg_field interface
Message-ID: <da3937bc-8ea7-4f44-85d7-ed452d93ba9b@lunn.ch>
References: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 03:32:59PM +0300, Radu Pirea (OSS) wrote:
> Some PHYs can be heavily modified between revisions, and the addresses of
> the registers are changed and the register fields are moved from one
> register to another.
> 
> To integrate more PHYs in the same driver with the same register fields,
> but these register fields were located in different registers at
> different offsets, I introduced the phy_reg_fied structure.
> 
> phy_reg_fied structure abstracts the register fields differences.

Hi Radu

You should always include a user of a new API. It makes it easier to
understand and review if you see both sides of an API.

Please turn this into a patchset, and make use of this new functions
in a driver.

	Andrew
