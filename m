Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9BB159E7B
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 02:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBLBEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 20:04:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgBLBEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 20:04:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD87E151679C8;
        Tue, 11 Feb 2020 17:04:10 -0800 (PST)
Date:   Tue, 11 Feb 2020 17:04:10 -0800 (PST)
Message-Id: <20200211.170410.226180513890431439.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     brett.creeley@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, andrewx.bowers@intel.com
Subject: Re: [net 1/1] i40e: Fix the conditional for
 i40e_vc_validate_vqs_bitmaps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200210185918.2903634-1-jeffrey.t.kirsher@intel.com>
References: <20200210185918.2903634-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Feb 2020 17:04:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 10 Feb 2020 10:59:18 -0800

> From: Brett Creeley <brett.creeley@intel.com>
> 
> Commit d9d6a9aed3f6 ("i40e: Fix virtchnl_queue_select bitmap
> validation") introduced a necessary change for verifying how queue
> bitmaps from the iavf driver get validated. Unfortunately, the
> conditional was reversed. Fix this.
> 
> Fixes: d9d6a9aed3f6 ("i40e: Fix virtchnl_queue_select bitmap validation")
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
