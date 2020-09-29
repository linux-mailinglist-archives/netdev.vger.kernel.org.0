Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93927D769
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgI2T6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2T6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:58:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39D1C061755;
        Tue, 29 Sep 2020 12:58:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A43B144EA6BB;
        Tue, 29 Sep 2020 12:42:02 -0700 (PDT)
Date:   Tue, 29 Sep 2020 12:58:49 -0700 (PDT)
Message-Id: <20200929.125849.710595543531143236.davem@davemloft.net>
To:     petko.manolov@konsulko.com
Cc:     gregKH@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND v3 0/2] Use the new usb control message API.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929045911.GA4393@carbon>
References: <20200927124909.16380-1-petko.manolov@konsulko.com>
        <20200928.160058.501175525907482710.davem@davemloft.net>
        <20200929045911.GA4393@carbon>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 12:42:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petko.manolov@konsulko.com>
Date: Tue, 29 Sep 2020 07:59:11 +0300

> On 20-09-28 16:00:58, David Miller wrote:
>> From: Petko Manolov <petko.manolov@konsulko.com> Date: Sun, 27 Sep 2020 
>> 15:49:07 +0300
>> 
>> > Re-sending these, now CC-ing the folks at linux-netdev.
>> 
>> I can't apply these since the helpers do not exist in the networking tree.
> 
> Right, Greg was only asking for ack (or nack) from your side.

Acked-by: David S. Miller <davem@davemloft.net>
