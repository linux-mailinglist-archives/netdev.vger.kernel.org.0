Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164F21DF0C5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 22:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgEVUtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 16:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730946AbgEVUtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 16:49:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB120C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 13:49:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 779A0122A991B;
        Fri, 22 May 2020 13:49:12 -0700 (PDT)
Date:   Fri, 22 May 2020 13:49:09 -0700 (PDT)
Message-Id: <20200522.134909.896095143298337172.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/15][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
References: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 13:49:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 21 May 2020 17:10:53 -0700

> This series contains updates to igc and e1000.
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks Jeff.
