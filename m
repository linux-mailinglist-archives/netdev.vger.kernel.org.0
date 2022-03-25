Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8294E794F
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376490AbiCYQxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377028AbiCYQwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:52:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA6C12EC
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 09:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lTwCYNgPrhqR52IEGTa8uE6YBn/Le91sR/qveWMwou8=; b=otvBq7aIptAXdFSUgOGndP1mgm
        oHSBiy6ayIV/8F43ImGfS+eTYs/DHrEps485SEPDAkjcN28u/iaqdse4TMygZfv35oVOtjDXBopjr
        wNh0QhHbFb/j/G6SoouwYma3bdargPUALTC9FGEoUA9r+9VJylW4wBQOuw8rx9J1PJnE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXn9c-00Cexi-Em; Fri, 25 Mar 2022 17:51:12 +0100
Date:   Fri, 25 Mar 2022 17:51:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "shenjian (K)" <shenjian15@huawei.com>, davem@davemloft.net,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com,
        alexandr.lobakin@intel.com, saeed@kernel.org, leon@kernel.org,
        netdev@vger.kernel.org, linuxarm@openeuler.org,
        lipeng321@huawei.com
Subject: Re: [RFCv5 PATCH net-next 01/20] net: rename net_device->features to
 net_device->active_features
Message-ID: <Yj3zADjjWCc9H50X@lunn.ch>
References: <20220324154932.17557-1-shenjian15@huawei.com>
 <20220324154932.17557-2-shenjian15@huawei.com>
 <20220324175832.70a7de9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220324180331.77a818c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2c493855-4084-8b5d-fed8-6faf8255faae@huawei.com>
 <20220324183549.10ba1260@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yj3lPVqrN1APvp1X@lunn.ch>
 <20220325085858.21176341@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325085858.21176341@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 08:58:58AM -0700, Jakub Kicinski wrote:
> On Fri, 25 Mar 2022 16:52:29 +0100 Andrew Lunn wrote:
> > > Here _hw_ makes sense. But i think we need some sort of
> > > consistency. Either drop the _active_ from the function name, or
> > > rename the netdev field active_features.  
> > 
> > So i suggested an either/or. In retrospect, the or seems like a bad
> > idea, this patch will be enormous. So i would suggest the other
> > option, netdev_set_active_features() gets renamed to
> > netdev_set__features()
> 
> SGTM! Just clarify if you meant the double underscore or it's a
> coincidence? :)

TypO.

	Andrew
