Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81D0653878
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 23:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiLUWVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 17:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLUWVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 17:21:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40C6F03A
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 14:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uNgUn2Ex+dDtmB/zyQyEP6zX9Vq79c779U8rsIOYejI=; b=DdBnqWcruDAfXCRSdYpYWLzMGk
        WjugOjLF04sBOeWEKZA/zcqn5EssJguXLAhfuICxhv7wI/WXZ+cm2E2q6BQElc48rPNkSAtWH6mUA
        PV0wg6kygG6SjqAb6WSwD50t5K+3PAZ47QAbB5dvkN4CbODuqiMnbfwMCnaoUXuqsU/A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p87SM-000DRu-7N; Wed, 21 Dec 2022 23:20:58 +0100
Date:   Wed, 21 Dec 2022 23:20:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, f.fainelli@gmail.com, rdunlap@infradead.org
Subject: Re: [PATCH net 0/2] netdev doc de-FAQization
Message-ID: <Y6OGyrmLKqy51k6K@lunn.ch>
References: <20221221184007.1170384-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221184007.1170384-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 10:40:05AM -0800, Jakub Kicinski wrote:
> I've been tempted to do this for a while. I think that we have outgrown
> the FAQ format for our process doc. I'm curious what others think but
> I often find myself struggling to locate information in this doc,
> because the questions do not serve well as section headers.

Looks good to me. It has grown beyond a simple FAQ.

I think you kept the top level header 'netdev FAQ'. Do we also want to
change that, since it is no longer question/answer formatted? Not that
i have a good idea what to call it instead.

Anyway:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
