Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B6718C5A8
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCTDVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:21:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTDVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:21:00 -0400
Received: from localhost (c-73-193-106-77.hsd1.wa.comcast.net [73.193.106.77])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A8C7158E851B;
        Thu, 19 Mar 2020 20:21:00 -0700 (PDT)
Date:   Thu, 19 Mar 2020 20:20:17 -0700 (PDT)
Message-Id: <20200319.202017.943577670120896534.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net-next] mptcp: rename fourth ack field
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3c7d0601bc04139108479bf06a8d299b14496300.1584612221.git.pabeni@redhat.com>
References: <3c7d0601bc04139108479bf06a8d299b14496300.1584612221.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 20:21:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 19 Mar 2020 11:06:30 +0100

> The name is misleading, it actually tracks the 'fully established'
> status.
> 
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks.
