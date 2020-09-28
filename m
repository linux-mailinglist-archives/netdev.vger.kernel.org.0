Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E385F27B7BC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgI1XPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgI1XNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010A1C0613D3
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 14:54:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 017B311E3E4CE;
        Mon, 28 Sep 2020 14:37:56 -0700 (PDT)
Date:   Mon, 28 Sep 2020 14:54:43 -0700 (PDT)
Message-Id: <20200928.145443.1201204462279910787.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/15] 1GbE Intel Wired LAN Driver Updates
 2020-09-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 14:37:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Mon, 28 Sep 2020 14:50:03 -0700

> This series contains updates to igb, igc, and e1000e drivers.
 ...
>   https://github.com/anguy11/next-queue.git 1GbE

Pulled, thanks Tony.
