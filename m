Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAEE1B6474
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgDWT3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgDWT3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:29:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE21C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:29:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7905A12774D46;
        Thu, 23 Apr 2020 12:29:54 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:29:53 -0700 (PDT)
Message-Id: <20200423.122953.620712677247198855.davem@davemloft.net>
To:     fgont@si6networks.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv6: Honor all IPv6 PIO Valid Lifetime values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419122457.GA971@archlinux-current.localdomain>
References: <20200419122457.GA971@archlinux-current.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:29:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Gont <fgont@si6networks.com>
Date: Sun, 19 Apr 2020 09:24:57 -0300

> RFC4862 5.5.3 e) prevents received Router Advertisements from reducing
> the Valid Lifetime of configured addresses to less than two hours, thus
> preventing hosts from reacting to the information provided by a router
> that has positive knowledge that a prefix has become invalid.
> 
> This patch makes hosts honor all Valid Lifetime values, as per
> draft-gont-6man-slaac-renum-06, Section 4.2. This is meant to help
> mitigate the problem discussed in draft-ietf-v6ops-slaac-renum.
> 
> Note: Attacks aiming at disabling an advertised prefix via a Valid
> Lifetime of 0 are not really more harmful than other attacks
> that can be performed via forged RA messages, such as those
> aiming at completely disabling a next-hop router via an RA that
> advertises a Router Lifetime of 0, or performing a Denial of
> Service (DoS) attack by advertising illegitimate prefixes via
> forged PIOs.  In scenarios where RA-based attacks are of concern,
> proper mitigations such as RA-Guard [RFC6105] [RFC7113] should
> be implemented.
> 
> Signed-off-by: Fernando Gont <fgont@si6networks.com>

Applied, thank you.
