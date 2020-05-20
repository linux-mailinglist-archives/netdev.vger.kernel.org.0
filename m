Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE271DA846
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 04:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgETCz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 22:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgETCz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 22:55:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5965EC061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 19:55:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18AD812942611;
        Tue, 19 May 2020 19:55:55 -0700 (PDT)
Date:   Tue, 19 May 2020 19:55:50 -0700 (PDT)
Message-Id: <20200519.195550.807958532603507314.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] net: unexport skb_gro_receive()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANn89iLBjDj4aOxUgnkyOfT2SwYXEzL3ZXpfG4voSALejUtfXQ@mail.gmail.com>
References: <20200519225012.159597-1-edumazet@google.com>
        <20200519.155305.1235405039792201660.davem@davemloft.net>
        <CANn89iLBjDj4aOxUgnkyOfT2SwYXEzL3ZXpfG4voSALejUtfXQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 19:55:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 19 May 2020 15:53:51 -0700

> On Tue, May 19, 2020 at 3:53 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Eric Dumazet <edumazet@google.com>
>> Date: Tue, 19 May 2020 15:50:12 -0700
>>
>> > skb_gro_receive() used to be used by SCTP, it is no longer the case.
>> >
>> > skb_gro_receive_list() is in the same category : never used from modules.
>> >
>> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>>
>> Maybe this is net-next material instead?
> 
> Sure thing !

Great, applied :)
