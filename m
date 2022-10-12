Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505265FCD65
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJLVk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJLVkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:40:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61D9C4C20
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=srsE+gzGPwjtQYl03G8i24hkuV1Ib9N/e5SVbRdlvwI=; b=eV
        GaJczHF/AS/PhMctElhLHKa5A6kx09ad1CZosotjIPNlKq/nr93VWGZdxAwAOdtTTSf/Gwqcb654S
        p3SlPb00VAPlzB1eQlmAznXNAh+PYMu2Gk7MDaoz37dh8PNyGbQDTxgWuI2fs07ir7JxcPAwvt94a
        bdyhLnCMicl8YS8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oijT9-001pxP-8V; Wed, 12 Oct 2022 23:40:51 +0200
Date:   Wed, 12 Oct 2022 23:40:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
Message-ID: <Y0c0Yw1FjmR0m+Cs@lunn.ch>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
 <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com>
 <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de>
 <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
 <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de>
 <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com>
 <c18b3a75-95cc-a35c-7a2c-fb4ec0b18b84@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c18b3a75-95cc-a35c-7a2c-fb4ec0b18b84@tarent.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 10:48:53PM +0200, Thorsten Glaser wrote:
> On Wed, 12 Oct 2022, Eric Dumazet wrote:
> 
> > This looks wrong (although I have not read your code)
> > 
> > I guess RTNL is not held at this point.
> > 
> > Use kfree_skb(skb) or __qdisc_drop(skb, to_free)
> 
> Ooh! Will try! That’s what I get for getting, ahem, inspiration
> from other qdiscs.

Are other qdiscs also missing RTNL, or are you just using the
inspiration in a different context?

	    Andrew
