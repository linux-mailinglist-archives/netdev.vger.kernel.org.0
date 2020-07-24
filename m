Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD95122D267
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGXXr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgGXXr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 19:47:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856C3C0619D3;
        Fri, 24 Jul 2020 16:47:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DED312755EE5;
        Fri, 24 Jul 2020 16:30:41 -0700 (PDT)
Date:   Fri, 24 Jul 2020 16:47:25 -0700 (PDT)
Message-Id: <20200724.164725.2267540815357576064.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, bigeasy@linutronix.de,
        richardcochran@gmail.com, kamil.alkhouri@hs-offenburg.de,
        ilias.apalodimas@linaro.org, olteanv@gmail.com
Subject: Re: [PATCH v2 0/8] Hirschmann Hellcreek DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87wo2t30v9.fsf@kurt>
References: <20200723081714.16005-1-kurt@linutronix.de>
        <20200723093339.7f2b6e27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87wo2t30v9.fsf@kurt>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:30:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Fri, 24 Jul 2020 08:04:10 +0200

> On Thu Jul 23 2020, Jakub Kicinski wrote:
>> Appears not to build:
>>
> 
> Yeah, i know. This patch series depends on two other ones:
> 
>  * https://lkml.kernel.org/netdev/20200723074946.14253-1-kurt@linutronix.de/
>  * https://lkml.kernel.org/netdev/20200720124939.4359-1-kurt@linutronix.de/
> 
> One of them has been merged, the other is being discussed. That series
> includes the 'ptp_header' and the corresponding functions. So, for
> compile testing you'll have to apply that series as well.

Please never submit patches for serious review when the dependencies
haven't landed in the target tree yet.

That makes so much wasted work for us and other reviewers.

Thank you.

