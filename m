Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F001CFE08
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgELTKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELTKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:10:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7750EC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:10:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35E821282CCE3;
        Tue, 12 May 2020 12:10:49 -0700 (PDT)
Date:   Tue, 12 May 2020 12:10:48 -0700 (PDT)
Message-Id: <20200512.121048.1412981549184597716.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
Subject: Re: [PATCH net] ptp: fix struct member comment for do_aux_work
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511210215.4178242-1-jacob.e.keller@intel.com>
References: <20200511210215.4178242-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 12:10:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Mon, 11 May 2020 14:02:15 -0700

> The do_aux_work callback had documentation in the structure comment
> which referred to it as "do_work".
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied, thanks.
