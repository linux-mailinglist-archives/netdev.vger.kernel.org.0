Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922F2EBD00
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 06:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbfKAFJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 01:09:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbfKAFJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 01:09:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA5FE15044628;
        Thu, 31 Oct 2019 22:09:46 -0700 (PDT)
Date:   Thu, 31 Oct 2019 22:09:42 -0700 (PDT)
Message-Id: <20191031.220942.1781037796505390783.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     manfred.rudigier@omicronenergy.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, aaron.f.brown@intel.com
Subject: Re: [net 3/7] igb: Fix constant media auto sense switching when no
 cable is connected
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031221719.14028-4-jeffrey.t.kirsher@intel.com>
References: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
        <20191031221719.14028-4-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 22:09:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 31 Oct 2019 15:17:15 -0700

> -	} else if (!(connsw & E1000_CONNSW_SERDESD)) {
> +	} else if ((hw->phy.media_type != e1000_media_type_copper) &&
> +	    !(connsw & E1000_CONNSW_SERDESD)) {

Please indent this last line properly, the '!' should line up with the
very first column after the opennening parenthesis of the previous
line.
