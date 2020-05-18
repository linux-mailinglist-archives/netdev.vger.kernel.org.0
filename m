Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0B11D8BD9
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgERXvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERXvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:51:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE218C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:51:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77F051274466A;
        Mon, 18 May 2020 16:51:14 -0700 (PDT)
Date:   Mon, 18 May 2020 16:51:11 -0700 (PDT)
Message-Id: <20200518.165111.133399076092373084.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v4 0/9][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518221657.1420070-1-jeffrey.t.kirsher@intel.com>
References: <20200518221657.1420070-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 16:51:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 18 May 2020 15:16:48 -0700

> v4: Updated the patch description for patch 2, which referred to changes
>     that no longer existed in the patch

Jeff, please.    Patches #4 thru #7 are the same exact change and
have the same exact problem in the commit message.

Please fix this up, thank you.
