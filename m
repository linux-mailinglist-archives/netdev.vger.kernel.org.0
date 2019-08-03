Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADFCD80782
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 19:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfHCRqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 13:46:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfHCRqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 13:46:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C648153F5133;
        Sat,  3 Aug 2019 10:46:33 -0700 (PDT)
Date:   Sat, 03 Aug 2019 10:46:32 -0700 (PDT)
Message-Id: <20190803.104632.1590271221707233392.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/9][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-08-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 03 Aug 2019 10:46:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu,  1 Aug 2019 13:51:40 -0700

> This series contains updates to i40e driver only.

Patch #2 seems to need some changes, so I'll wait for the next respin
of this pull request.
