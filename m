Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339DA74183
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfGXWf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:35:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbfGXWf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:35:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7033B1543C8A4;
        Wed, 24 Jul 2019 15:35:55 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:35:54 -0700 (PDT)
Message-Id: <20190724.153554.469160824234541146.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 0/5][pull request] 1GbE Intel Wired LAN Driver
 Updates 2019-07-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724212613.1580-1-jeffrey.t.kirsher@intel.com>
References: <20190724212613.1580-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:35:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 24 Jul 2019 14:26:08 -0700

> This series contains updates to igc and e1000e client drivers only.
> 
> Sasha provides a couple of cleanups to remove code that is not needed
> and reduce structure sizes.  Updated the MAC reset flow to use the
> device reset flow instead of a port reset flow.  Added addition device
> id's that will be supported.
> 
> Kai-Heng Feng provides a workaround for a possible stalled packet issue
> in our ICH devices due to a clock recovery from the PCH being too slow.
> 
> v2: removed the last patch in the series that supposedly fixed a MAC/PHY
>     de-sync potential issue while waiting for additional information from
>     hardware engineers.

Pulled, thanks Jeff.
