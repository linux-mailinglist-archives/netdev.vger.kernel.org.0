Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC95AEAD7
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiIFNuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbiIFNrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:47:53 -0400
Received: from 7of9.schinagl.nl (7of9.connected.by.freedominter.net [185.238.129.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696927F26D;
        Tue,  6 Sep 2022 06:39:06 -0700 (PDT)
Received: from [10.2.11.251] (unknown [10.2.11.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by 7of9.schinagl.nl (Postfix) with ESMTPSA id C7A85186DAD3;
        Tue,  6 Sep 2022 15:38:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662471490; bh=Vyb4ajcLyZz4xan39XpNpe7VhoNNU09JJMYckg4/JK0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=pqv4otDQsZ2ugfu1Dt2lChdn/TkVukPCvRRwM/J94ENuAWlCdREQp26CkinRVsnvR
         ZjdbHM8uvn/vxBv+LmYEdEnilyZRghpddojSKjUgqkMMp8GbBxqju5Fsqw3uiJYwj5
         qPdxgA26xHUxmu+fTl8BVueo3TVYExb+y6K7BgaE=
Message-ID: <96b0d0b5-b022-4985-b88e-61e5498cfb82@schinagl.nl>
Date:   Tue, 6 Sep 2022 15:38:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] linkstate: Add macros for link state up/down
Content-Language: nl
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220906083754.2183092-1-oliver@schinagl.nl>
 <Yxc6o+6u2zlPxU3a@lunn.ch>
From:   Olliver Schinagl <oliver@schinagl.nl>
In-Reply-To: <Yxc6o+6u2zlPxU3a@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Andrew,

On 06-09-2022 14:18, Andrew Lunn wrote:
> On Tue, Sep 06, 2022 at 10:37:54AM +0200, Olliver Schinagl wrote:
>> The phylink_link_state.state property can be up or down, via 1 and 0.
>>
>> The other link state's (speed, duplex) are defined in ethtool.h so lets
>> add defines for the link-state there as well so we can use macro's to
>> define our up/down states.
> Hi Olliver
>
> The change itself is fine, but we don't add to the API without
> users. Please make use of these two new values somewhere, to show they
> are really useful.
>
>      Andrew

I actually ran into this need as I'm working on the realtek switch stuff 
over on openwrt, where I see link-states being set with 0/1. I'll search 
the kernel for these as well if that helps and can do a follow up of course.

Olliver
