Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BE95261D0
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 14:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiEMM11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 08:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380273AbiEMM1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 08:27:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6998F60AB6
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 05:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TbBn4yaRKvG1s2vXHP7k3HBj0mbml8N45EcGuVW+ZIs=; b=cdvZWP4zP815f9RXhWpYReOru3
        x1J38raXwFF1zj0rf2bwjYv2xke0Fs+9/CDDayWo6dAMmKlckcZSpFqFJl3IvdhOoLHXYA7fA3QyX
        p41wSHIHe4DMmp8UGzeR1J6lm6zfzn9F0qXrdae/TnK+CAF5aLvcq/HOExMCokez3d2A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1npUO7-002adH-AS; Fri, 13 May 2022 14:27:19 +0200
Date:   Fri, 13 May 2022 14:27:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     'Jakub Kicinski' <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/14] Wangxun 10 Gigabit Ethernet Driver
Message-ID: <Yn5Op7FIxyMC3ap9@lunn.ch>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
 <20220511175425.67968b76@kernel.org>
 <004401d865e4$c3073d10$4915b730$@trustnetic.com>
 <20220512085748.2f678d20@kernel.org>
 <Yn2E8X6f8PJ0c4CB@lunn.ch>
 <001201d86671$61c86410$25592c30$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201d86671$61c86410$25592c30$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> By the way, I have some email related questions.
> I can't find the message of my reply in Patchwork. So I don't know whether
> my reply has been sent successfully.

Try looking at the other archive, like lore.

It could be you are obfuscating your email in MIME, so it got dropped.

> Also, I always receive two identical reply emails from other people at the
> same time. Are there settings I have forgotten?

That is probably one direct and one via the list. Take a look in the
email header to confirm this, look at the path the email took.

I actually find this useful, since i have all the list emails going
into a separate mailbox. Replies from the list can be missed, since
they are just one among 700 a day, but they do form a good local
archive. The direct emails land in my main mailbox, where they get
seen quickly.

     Andrew
