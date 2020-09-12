Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB6A2676C2
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgILATO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILATM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:19:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953A7C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:19:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1766F120EA825;
        Fri, 11 Sep 2020 17:02:24 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:19:10 -0700 (PDT)
Message-Id: <20200911.171910.1388280780744487211.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [RESEND net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-09-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
References: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:02:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Fri, 11 Sep 2020 16:22:03 -0700

> This series contains updates to i40e and igc drivers.
> 
> Stefan Assmann changes num_vlans to u16 to fix may be used uninitialized
> error and propagates error in i40_set_vsi_promisc() for i40e.
> 
> Vinicius corrects timestamping latency values for i225 devices and
> accounts for TX timestamping delay for igc.
> 
> The following are changes since commit b87f9fe1ac9441b75656dfd95eba70ef9f0375e0:
>   hsr: avoid newline  end of message in NL_SET_ERR_MSG_MOD
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Pulled, thank you.
