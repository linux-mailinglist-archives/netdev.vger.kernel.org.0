Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE57D2708EE
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 00:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIRWZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 18:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgIRWZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 18:25:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656D7C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 15:25:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CB9115A1774F;
        Fri, 18 Sep 2020 15:09:09 -0700 (PDT)
Date:   Fri, 18 Sep 2020 15:25:55 -0700 (PDT)
Message-Id: <20200918.152555.1403201229559966970.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-09-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918212703.3398038-1-anthony.l.nguyen@intel.com>
References: <20200918212703.3398038-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 15:09:09 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Tony, there seems to be repeated problems with the patch serieses
you post.

Several of the patches in the series don't make it to the mailing
list and looking at the vger.kernel.org logs I see:

RVeMDj90000w    553 5.4.3 Hello [192.55.52.118], for MAIL FROM address <MAILER-DAEMON@fmsmga104.fm.intel.com> the policy analysis reports DNS error with your source domain.
RVeMDj90001w    553 5.4.3 Hello [192.55.52.118], for MAIL FROM address <MAILER-DAEMON@fmsmga104.fm.intel.com> the policy analysis reports DNS error with your source domain.

For patches 1 and 3 which didn't make it to the lists.

The other patches went through different servers such as mga01.intel.com
which don't have the DNS issues.

I've never seen this happen when Jeff was posting his pull requests.

Please fix this up otherwise we won't be able to review and apply you
patch submissions.

Thank you.
