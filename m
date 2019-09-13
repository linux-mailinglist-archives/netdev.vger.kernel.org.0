Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5C0B2159
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389501AbfIMNsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:48:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388860AbfIMNsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:48:06 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9343B14C63FFD;
        Fri, 13 Sep 2019 06:48:05 -0700 (PDT)
Date:   Fri, 13 Sep 2019 14:48:03 +0100 (WEST)
Message-Id: <20190913.144803.679992177070979119.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/13][pull request] Intel Wired LAN Driver
 Updates 2019-09-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
References: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 06:48:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 11 Sep 2019 09:50:01 -0700

> This series contains updates to i40e, ixgbe/vf and iavf.

Pulled, thanks Jeff.
