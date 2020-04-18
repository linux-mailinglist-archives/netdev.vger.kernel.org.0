Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44991AF5BE
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgDRWxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgDRWxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:53:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3F7C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:53:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF61612783B61;
        Sat, 18 Apr 2020 15:53:14 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:53:13 -0700 (PDT)
Message-Id: <20200418.155313.304932819682962388.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-04-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:53:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 17 Apr 2020 11:42:37 -0700

> This series contains updates to e1000e and igc only.

Pulled, thanks Jeff.
