Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B515852F46F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 22:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353476AbiETUbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 16:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353470AbiETUbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 16:31:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356CC340CD;
        Fri, 20 May 2022 13:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DLULO/rszAHKPxdjbAsajMe5tA7+SsUhYH9DkHT1ik8=; b=jPEWsltQc/BpiOuVhDPI+/0J2H
        jjRgljUV+DoWu40evBQluhrq2ch+ONssPw3TgtxkPJQ1b+FUYo153A8F5sHXvc311y8k67nHHRhkV
        q8boZAgnJaT+zB7SJRmc9xfCwLUAW/5+OBShp6dOFphjY0Fw7wzQ5OvrNKooQ55ukFkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ns9H4-003geZ-E3; Fri, 20 May 2022 22:31:02 +0200
Date:   Fri, 20 May 2022 22:31:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org, tytso@mit.edu
Subject: Re: RFC: Ioctl v2
Message-ID: <Yof6hsC1hLiYITdh@lunn.ch>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I want to circulate this and get some comments and feedback, and if
> no one raises any serious objections - I'd love to get collaborators
> to work on this with me. Flame away!

Hi Kent

I doubt you will get much interest from netdev. netdev already
considers ioctl as legacy, and mostly uses netlink and a message
passing structure, which is easy to extend in a backwards compatible
manor.

https://man7.org/linux/man-pages/man7/netlink.7.html

	Andrew
