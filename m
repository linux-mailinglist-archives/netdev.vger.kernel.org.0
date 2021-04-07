Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A8356C6F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 14:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343552AbhDGMou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 08:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhDGMop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 08:44:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C8B56135D;
        Wed,  7 Apr 2021 12:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617799476;
        bh=gnFVVLuMw1XrbnmPwx8G5P4avuQB7mSzP86qLuRcJpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fDHQQ7TReibjFn8nqWoRCdeBp7Hyv74wTwIPAD9uJluSwxREqP+raeQzUq5RjXSn9
         Z7iT979kTKmAQKldAvnfc2bLBd2+xkSvz2dvkH3WgInsDtCc/vUJ6cybRu5YANGwAG
         5OFPDjZ5i2I4SrRk1P3J1KpB8d0hcaUh10sZDdjyG56V1bKlI/dTEFOklGrVuAQdBV
         RX54+FAg79buZ7q+xo0+Oy724te7w8g5IQn81f+yX8/HMfSP3hsb2ynBAFWTZyIOS7
         3gdDo02ROadZvEkRPXe4nCnBaFX/tuSJpr1SNoD1nh1DzPDncKpqQbQdAHOhsWmnk8
         usAO0dMdPfBvA==
Date:   Wed, 7 Apr 2021 15:44:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG2pMD9eIHsRetDJ@unreal>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
 <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG1qF8lULn8lLJa/@unreal>
 <MW2PR2101MB08923F19D070996429979E38BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB08923F19D070996429979E38BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 08:28:45AM +0000, Dexuan Cui wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, April 7, 2021 1:15 AM
> > > ...
> > > int gdma_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
> > > {
> > >         struct gdma_generate_test_event_req req = { 0 };
> > >         struct gdma_general_resp resp = { 0 };
> > 
> > BTW, you don't need to write { 0 }, the {} is enough.
>  
> Thanks for the suggestion! I'll use {0} in v2. 

You missed the point, "{ 0 }" change to be "{}" without 0.

Thanks
