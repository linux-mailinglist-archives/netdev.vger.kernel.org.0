Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719FC736DF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfGXSqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:46:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbfGXSqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:46:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7A761540A472;
        Wed, 24 Jul 2019 11:46:30 -0700 (PDT)
Date:   Wed, 24 Jul 2019 11:46:30 -0700 (PDT)
Message-Id: <20190724.114630.265658125734027818.davem@davemloft.net>
To:     willy@infradead.org
Cc:     David.Laight@aculab.com, hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724114120.GT363@bombadil.infradead.org>
References: <20190723030831.11879-7-willy@infradead.org>
        <b47b0b19e5594b97af62352dc0dbffcc@AcuMS.aculab.com>
        <20190724114120.GT363@bombadil.infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 11:46:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Wed, 24 Jul 2019 04:41:21 -0700

> On Wed, Jul 24, 2019 at 10:49:03AM +0000, David Laight wrote:
>> This is 'just plain stupid'.
>> The 'bv_' prefix of the members of 'struct bvec' is there so that 'grep'
>> (etc) can be used to find the uses of the members.
>> 
>> In a 'struct skb_frag_struct' a sensible prefix might be 'sf_'.
>> 
>> OTOH it might be sensible to use (or embed) a 'struct bvec'
>> instead of 'skb_frag_struct'.
> 
> Maybe you should read patch 7/7.  Or 0/7.

+1
