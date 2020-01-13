Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B1B139179
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgAMM65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:58:57 -0500
Received: from mx4.wp.pl ([212.77.101.11]:7257 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgAMM65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 07:58:57 -0500
Received: (wp-smtpd smtp.wp.pl 28385 invoked from network); 13 Jan 2020 13:58:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578920335; bh=SR3kC/ZoSfEBGgeqzp09eP+AkVVtPZC7aWzLpCxtZM0=;
          h=From:To:Cc:Subject;
          b=QfQdImP21gyKRCG//341cm/ZgENmkme62gjtUIGpzGceIcDjsJmjLO9AGOMLreTpD
           AM/8rfGXEa+C9KIfxp42RhP1aHM/eji3YErUrKphmR6gHfbWZ8ze00IENL8rSLlKkv
           EktpexUna4Fhq6PUVcVciYlolO6z7kmNcRjtzjRM=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <zhangxiaoxu5@huawei.com>; 13 Jan 2020 13:58:54 +0100
Date:   Mon, 13 Jan 2020 04:58:46 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     <ecree@solarflare.com>, <amaftei@solarflare.com>
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <mhabets@solarflare.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] sfc/ethtool_common: Make some function to static
Message-ID: <20200113045846.3330b57c@cakuba>
In-Reply-To: <20200113112411.28090-1-zhangxiaoxu5@huawei.com>
References: <20200113112411.28090-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: a69f63854e16864fac017bd07ac364e2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [IaM0]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 19:24:11 +0800, Zhang Xiaoxu wrote:
> Fix sparse warning:
> 
> drivers/net/ethernet/sfc/ethtool_common.c
>   warning: symbol 'efx_fill_test' was not declared. Should it be static?
>   warning: symbol 'efx_fill_loopback_test' was not declared.
>            Should it be static?
>   warning: symbol 'efx_describe_per_queue_stats' was not declared.
>            Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

Ed, Alex, since you were talking about reusing this code would you
rather add a declaration for these function to a header? Or should 
I apply the current fix?
