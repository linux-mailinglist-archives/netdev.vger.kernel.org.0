Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808341CFDFE
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730978AbgELTJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgELTJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:09:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20042C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:09:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 660131282BA1A;
        Tue, 12 May 2020 12:09:14 -0700 (PDT)
Date:   Tue, 12 May 2020 12:09:11 -0700 (PDT)
Message-Id: <20200512.120911.2258216308785425487.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     cpaasch@apple.com, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net] mptcp: Initialize map_seq upon subflow
 establishment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6b0594845f7787b9bc82c845321e23b6bc3bca38.camel@redhat.com>
References: <20200511162442.78382-1-cpaasch@apple.com>
        <6b0594845f7787b9bc82c845321e23b6bc3bca38.camel@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 12:09:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Mon, 11 May 2020 19:35:21 +0200

> On Mon, 2020-05-11 at 09:24 -0700, Christoph Paasch wrote:
>> When the other MPTCP-peer uses 32-bit data-sequence numbers, we rely on
>> map_seq to indicate how to expand to a 64-bit data-sequence number in
>> expand_seq() when receiving data.
>> 
>> For new subflows, this field is not initialized, thus results in an
>> "invalid" mapping being discarded.
>> 
>> Fix this by initializing map_seq upon subflow establishment time.
>> 
>> Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
>> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
 ...
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks.
