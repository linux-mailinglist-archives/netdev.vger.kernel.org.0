Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFBB1DA05D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgESTDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:03:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A36C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:03:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEFDC128B385B;
        Tue, 19 May 2020 12:02:58 -0700 (PDT)
Date:   Tue, 19 May 2020 12:02:55 -0700 (PDT)
Message-Id: <20200519.120255.1933609173047563508.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v5 0/9][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
References: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 12:02:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 18 May 2020 18:03:34 -0700

> This series contains updates to igc driver only.
> 
> Sasha adds ECN support for TSO by adding the NETIF_F_TSO_ECN flag, which
> aligns with other Intel drivers.  Also cleaned up defines that are not
> supported or used in the igc driver.
> 
> Andre does most of the changes with updating the log messages for igc
> driver.
> 
> Vitaly adds support for EEPROM, register and link ethtool
> self-tests.
> 
> v2: Fixed up the added ethtool self-tests based on feedback from the
>     community.  Dropped the four patches that removed '\n' from log
>     messages.
> v3: Reverted the debug message changes in patch 2 for messages in
>     igc_probe, also made reg_test[] static in patch 3 based on community
>     feedback
> v4: Updated the patch description for patch 2, which referred to changes
>     that no longer existed in the patch
> v5: Scrubbed patches 4-7 patch description, which also referred to
>     changes that no longer existed in the patch

Pulled, thanks.
