Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6797C1708C5
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgBZTOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:14:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgBZTOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 14:14:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC65515AA59E0;
        Wed, 26 Feb 2020 11:14:54 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:14:54 -0800 (PST)
Message-Id: <20200226.111454.1070933318178678026.davem@davemloft.net>
To:     amritha.nambiar@intel.com
Cc:     netdev@vger.kernel.org, alexander.h.duyck@intel.com,
        sridhar.samudrala@intel.com, sergei.shtylyov@cogentembedded.com
Subject: Re: [net PATCH v2] net: Fix Tx hash bound checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158257056094.10327.890174763453610916.stgit@anambiarhost.jf.intel.com>
References: <158257056094.10327.890174763453610916.stgit@anambiarhost.jf.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 11:14:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amritha Nambiar <amritha.nambiar@intel.com>
Date: Mon, 24 Feb 2020 10:56:00 -0800

> Fixes the lower and upper bounds when there are multiple TCs and
> traffic is on the the same TC on the same device.
> 
> The lower bound is represented by 'qoffset' and the upper limit for
> hash value is 'qcount + qoffset'. This gives a clean Rx to Tx queue
> mapping when there are multiple TCs, as the queue indices for upper TCs
> will be offset by 'qoffset'.
> 
> v2: Fixed commit description based on comments.
> 
> Fixes: 1b837d489e06 ("net: Revoke export for __skb_tx_hash, update it to just be static skb_tx_hash")
> Fixes: eadec877ce9c ("net: Add support for subordinate traffic classes to netdev_pick_tx")
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

Applied and queued up for -stable, thanks.
