Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B386719FDD4
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 21:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDFTEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 15:04:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFTEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 15:04:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 069B615DB377B;
        Mon,  6 Apr 2020 12:04:32 -0700 (PDT)
Date:   Mon, 06 Apr 2020 12:04:30 -0700 (PDT)
Message-Id: <20200406.120430.52263128980646881.davem@davemloft.net>
To:     elder@linaro.org
Cc:     netdev@vger.kernel.org
Subject: Re: IPA Driver Maintenance
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cd3cefcd-1b80-d788-38c0-7d2a03fb6a0d@linaro.org>
References: <cd3cefcd-1b80-d788-38c0-7d2a03fb6a0d@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 12:04:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Fri, 27 Mar 2020 18:42:13 -0500

> I'd like to know what your preferences and expectations are for
> me maintaining the IPA driver.
> 
> I will review all IPA-related patches and will clearly indicate
> whether I find them acceptable (i.e., Reviewed-by, Signed-off-by,
> or Acked-by... or not).
> 
> Do you want me to set up a tree and send you pull requests?
> Should I be watching the netdev patchwork queue?  Or something
> else?

Patches always work fine, as do pull requests, so simply do whatever
works best for you.
