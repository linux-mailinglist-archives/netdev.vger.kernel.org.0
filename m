Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D041DF0E6
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgEVVFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgEVVFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:05:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0598DC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:05:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C2A412359E91;
        Fri, 22 May 2020 14:05:32 -0700 (PDT)
Date:   Fri, 22 May 2020 14:05:31 -0700 (PDT)
Message-Id: <20200522.140531.577242314240967598.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/17][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 14:05:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 21 May 2020 23:55:50 -0700

> This series contains updates to ice driver only.  Several of the changes
> are fixes, which could be backported to stable, of which, only one was
> marked for stable because of the memory leak potential.
 ...

Pulled, thanks Jeff.
