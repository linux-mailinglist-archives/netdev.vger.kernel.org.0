Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12239C10E
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfHXXrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:47:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48652 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHXXrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:47:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB107152619AC;
        Sat, 24 Aug 2019 16:47:00 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:47:00 -0700 (PDT)
Message-Id: <20190824.164700.328083188896923585.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-08-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:47:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 23 Aug 2019 16:37:36 -0700

> This series contains updates to ice driver only.

Pulled, thanks Jeff.
