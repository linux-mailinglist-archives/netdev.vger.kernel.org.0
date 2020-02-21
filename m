Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021F7166B3B
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgBUAAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 19:00:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729234AbgBUAAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 19:00:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A703B104D0A81;
        Thu, 20 Feb 2020 16:00:29 -0800 (PST)
Date:   Thu, 20 Feb 2020 16:00:29 -0800 (PST)
Message-Id: <20200220.160029.1024031267302216595.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/12][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-02-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
References: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 16:00:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 19 Feb 2020 16:57:01 -0800

> This series contains updates to e1000e and igc drivers.

Pulled, thanks Jeff.
