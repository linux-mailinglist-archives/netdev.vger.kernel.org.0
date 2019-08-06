Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F9183AFC
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfHFVVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:21:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfHFVVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:21:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB8ED133F18DB;
        Tue,  6 Aug 2019 14:21:47 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:21:47 -0700 (PDT)
Message-Id: <20190806.142147.1877188870910996176.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-08-04
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
References: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:21:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Sun,  4 Aug 2019 04:59:18 -0700

> This series contains more updates to fm10k from Jake Keller.
> 
> Jake removes the unnecessary initialization of some variables to help
> resolve static code checker warnings.  Explicitly return success during
> resume, since the value of 'err' is always success.  Fixed a issue with
> incrementing a void pointer, which can produce undefined behavior.  Used
> the __always_unused macro for function templates that are passed as
> parameters in functions, but are not used.  Simplified the code by
> removing an unnecessary macro in determining the value of NON_Q_VECTORS.
> Fixed an issue, using bitwise operations to prevent the low address
> overwriting the high portion of the address.

Pulled, thanks Jeff.
