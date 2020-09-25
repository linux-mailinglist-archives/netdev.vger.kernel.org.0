Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA352794A9
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgIYXYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgIYXYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:24:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88665C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:24:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F34FA13B9D498;
        Fri, 25 Sep 2020 16:07:51 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:24:36 -0700 (PDT)
Message-Id: <20200925.162436.1039753774581438405.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net v2 0/4][pull request] Intel Wired LAN Driver Updates
 2020-09-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
References: <20200925210930.4049734-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:07:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Fri, 25 Sep 2020 14:09:26 -0700

> This series contains updates to the iavf and ice driver.
> 
> Sylwester fixes a crash with iavf resume due to getting the wrong pointers.
> 
> Ani fixes a call trace in ice resume by calling pci_save_state().
> 
> Jakes fixes memory leaks in case of register_netdev() failure or
> ice_cfg_vsi_lan() failure for the ice driver.
> 
> v2: Rebased; no other changes

Pulled, thanks Tony.
