Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CC45ACC2
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 19:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfF2RxI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 29 Jun 2019 13:53:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfF2RxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 13:53:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09FC214B566FC;
        Sat, 29 Jun 2019 10:53:06 -0700 (PDT)
Date:   Sat, 29 Jun 2019 10:53:06 -0700 (PDT)
Message-Id: <20190629.105306.762888643756822083.davem@davemloft.net>
To:     bjorn.topel@gmail.com
Cc:     ivan.khoronzhuk@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] xdp: xdp_umem: fix umem pages mapping for
 32bits systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com>
References: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
        <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 10:53:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@gmail.com>
Date: Wed, 26 Jun 2019 22:50:23 +0200

> On Wed, 26 Jun 2019 at 17:59, Ivan Khoronzhuk
> <ivan.khoronzhuk@linaro.org> wrote:
>>
>> Use kmap instead of page_address as it's not always in low memory.
>>
> 
> Ah, some 32-bit love. :-) Thanks for working on this!
> 
> For future patches, please base AF_XDP patches on the bpf/bpf-next
> tree instead of net/net-next.
> 
> Acked-by: Björn Töpel <bjorn.topel@intel.com>

Alexei and Daniel, I'll let you guys take this one.

Thanks.
