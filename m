Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64ABE21171F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgGBAZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgGBAZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:25:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2B5C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:25:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69ACB14D79B3C;
        Wed,  1 Jul 2020 17:25:19 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:25:14 -0700 (PDT)
Message-Id: <20200701.172514.1550874317481687006.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com
Subject: Re: [net-next 0/3][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-07-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
References: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:25:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Wed,  1 Jul 2020 16:53:23 -0700

> This series contains updates to the ice driver only.
> 
> Jacob implements a devlink region for device capabilities.
> 
> Bruce removes structs containing only one-element arrays that are either
> unused or only used for indexing. Instead, use pointer arithmetic or
> other indexing to access the elements. Converts "C struct hack"
> variable-length types to the preferred C99 flexible array member.

Pulled, thanks Tony.
