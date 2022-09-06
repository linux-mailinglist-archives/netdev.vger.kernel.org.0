Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B860E5AEF52
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiIFPr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbiIFPrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:47:14 -0400
Received: from 7of9.schinagl.nl (7of9.connected.by.freedominter.net [185.238.129.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8E5861D3;
        Tue,  6 Sep 2022 07:57:31 -0700 (PDT)
Received: from [10.2.11.251] (unknown [10.2.11.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by 7of9.schinagl.nl (Postfix) with ESMTPSA id E981C186DB58;
        Tue,  6 Sep 2022 16:57:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662476249; bh=26S2U724s7f4DM/gBAKidyozMiGXmfCW23f0ZmJvOfc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=NZ1CkwwnEW3KQfVpLyAMOhrPw3FwVbqMS7aDMSwJAPl1ooCYDbpwuUXfW3M3rYILG
         WzfMmtGas74EMQtEh6EN2zdf1AsHZC9+HVL9iADniXlX58SJGamOLBIBsav6VHymAO
         z4QdrI5appMZCbcwiUKSRjdN49rYRl13Fwj0GQQ4=
Message-ID: <098a4abd-32fa-ce02-7d6d-aa3db6c7fceb@schinagl.nl>
Date:   Tue, 6 Sep 2022 16:57:28 +0200
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

So I've found quite a lot of users, which I suppose is good. I've since 
decided to turn it into an enum, and refer in the structs as `enum 
phy_linkstate link:1` (is this even legal?) Would that ok for v2?


Olliver

