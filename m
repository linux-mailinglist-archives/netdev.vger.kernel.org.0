Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74F4ECAE
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfD2WVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:21:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbfD2WVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:21:13 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 626771469177F;
        Mon, 29 Apr 2019 15:21:12 -0700 (PDT)
Date:   Mon, 29 Apr 2019 18:21:09 -0400 (EDT)
Message-Id: <20190429.182109.2278488103649846421.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154 for net 2019-04-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190425160311.19767-1-stefan@datenfreihafen.org>
References: <20190425160311.19767-1-stefan@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 15:21:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Thu, 25 Apr 2019 18:03:11 +0200

> An update from ieee802154 for your *net* tree.
> 
> Another fix from Kangjie Lu to ensure better checking regmap updates in the
> mcr20a driver. Nothing else I have pending for the final release.
> 
> If there are any problems let me know.

Pulled, thanks Stefan.

> During the preparation of this pull request a workflow question on
> my side came up and wonder if you (or some subsystem maintainer
> sending you pull requests) does have a comment on this. The
> ieee802154 subsystem has a low activity in the number of patches
> coming through it. I still wanted to pull from your net tree
> regularly to test if changes have implications to it. During this
> pulls I often end up with merge of the remote tracking branch. Which
> in the end could mean that I would have something like 3-4 merge
> commits in my tree with only one actual patch I want to send over to
> you. Feels and looks kind of silly to be honest.
> 
> How do other handle this? Just merge once every rc? Merge just
> before sending a pull request? Never merge, wait for Dave to pull
> and merge and do a pull of his tree directly afterwards?

I would say never pull from the net tree until right after I pull your
tree and thus you can do a clean fast-forward merge.

If you want to test, right before you send me a pull request do a test
pull into a local throw-away branch.

Otherwise I'll handle conflicts and merge issues.

Thanks.
