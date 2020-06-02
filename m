Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285991EC53C
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgFBWoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgFBWoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:44:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A21FC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 15:44:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A26AA12780391;
        Tue,  2 Jun 2020 15:44:02 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:44:01 -0700 (PDT)
Message-Id: <20200602.154401.977499738191444566.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V1 net 0/2] Fix xdp in ena driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200602092333.53d88bb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20200602132151.366-1-sameehj@amazon.com>
        <20200602092333.53d88bb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:44:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 2 Jun 2020 09:23:33 -0700

> On Tue, 2 Jun 2020 13:21:49 +0000 sameehj@amazon.com wrote:
>> From: Sameeh Jubran <sameehj@amazon.com>
>> 
>> This patchset includes 2 XDP related bug fixes.
> 
> Both of them have this problem
> 
> Fixes tag: Fixes: cad451dd2427 ("net: ena: Implement XDP_TX action")
> Has these problem(s):
> 	- Subject does not match target commit subject
> 	  Just use
> 		git log -1 --format='Fixes: %h ("%s")'

Whoops, I'll revert, please fix this up.
