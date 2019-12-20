Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEEC1272D9
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLTBhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:37:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLTBha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:37:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B9081540C721;
        Thu, 19 Dec 2019 17:37:30 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:37:29 -0800 (PST)
Message-Id: <20191219.173729.1864083041118264275.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net-next v2 0/9] Add ipv6 tunnel support to NFP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
References: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 17:37:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Tue, 17 Dec 2019 21:57:15 +0000

> The following patches add support for IPv6 tunnel offload to the NFP
> driver.
> 
> Patches 1-2 do some code tidy up and prepare existing code for reuse in
> IPv6 tunnels.
> Patches 3-4 handle IPv6 tunnel decap (match) rules.
> Patches 5-8 handle encap (action) rules.
> Patch 9 adds IPv6 support to the merge and pre-tunnel rule functions.
> 
> v1->v2:
> - fix compiler warning when building without CONFIG_IPV6 set -
>   Jakub Kicinski (patch 7)

Series applied, thanks.
