Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA875AEE99
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiIFPWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiIFPWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:22:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5423898A48;
        Tue,  6 Sep 2022 07:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J0NhJH5uZ6ImJboTNtETOb2QJKe50Xb1SZoumQrYpAc=; b=bVjnnm9aOCGgcqyrqhufk45CuH
        IxlGndctEZVp/Z0fdL8vu0QA/FO/ecRCE+TbIoPpB8z5bf6BdqbAv3IUUBWB5+plsff8mGg7xGEm0
        jlld63GhsJFrMJH1O3H8/ximTLCTF6ckgszLFu4X9gOG2ArYqtomtMETE6mVqlLYaX9k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVZ9f-00Fl1O-IP; Tue, 06 Sep 2022 16:02:19 +0200
Date:   Tue, 6 Sep 2022 16:02:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <YxdS6ygF7EdS/fy/@lunn.ch>
References: <20220905101730.29951-1-Divya.Koppera@microchip.com>
 <YxX1I6wBFjzID2Ls@lunn.ch>
 <CO1PR11MB47712E1FAE109EEF5E502C5FE27E9@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB47712E1FAE109EEF5E502C5FE27E9@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We do have SQI support for 100Mbps to pair 0 only. For other pairs
> SQI values are invalid values.

And you have tested this with auto-cross over, so that the pairs get
swapped?

	Andrew
