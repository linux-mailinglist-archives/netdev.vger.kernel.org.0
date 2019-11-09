Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAADFF5C8C
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfKIAvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:51:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfKIAvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:51:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B7E7153C10A1;
        Fri,  8 Nov 2019 16:51:05 -0800 (PST)
Date:   Fri, 08 Nov 2019 16:51:03 -0800 (PST)
Message-Id: <20191108.165103.633165061506740611.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 0/6][pull request] Intel Wired LAN Driver Fixes 2019-11-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
References: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 16:51:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri,  8 Nov 2019 16:44:24 -0800

> This series contains fixes to igb, igc, ixgbe, i40e, iavf and ice
> drivers.

Pulled, thanks Jeff.
