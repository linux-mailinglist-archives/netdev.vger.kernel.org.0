Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713DF51970
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbfFXRWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:22:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726941AbfFXRWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:22:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F3BA15064086;
        Mon, 24 Jun 2019 10:22:12 -0700 (PDT)
Date:   Mon, 24 Jun 2019 10:22:12 -0700 (PDT)
Message-Id: <20190624.102212.4398258272798722.davem@davemloft.net>
To:     ndesaulniers@google.com
Cc:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH net v2 1/2] ipv6: constify rt6_nexthop()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKwvOdmd2AooQrpPhBVhcRHGNsMoGFiXSyBA4_aBf7=oVeOx1g@mail.gmail.com>
References: <CAKwvOdk9yxnO_2yDwuG8ECw2o8kP=w8pvdbCqDuwO4_03rj5gw@mail.gmail.com>
        <20190624.100609.1416082266723674267.davem@davemloft.net>
        <CAKwvOdmd2AooQrpPhBVhcRHGNsMoGFiXSyBA4_aBf7=oVeOx1g@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 10:22:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 24 Jun 2019 10:17:03 -0700

> On Mon, Jun 24, 2019 at 10:06 AM David Miller <davem@davemloft.net> wrote:
>>
>> From: Nick Desaulniers <ndesaulniers@google.com>
>> Date: Mon, 24 Jun 2019 09:45:14 -0700
>>
>> > https://groups.google.com/forum/#!searchin/clang-built-linux/const%7Csort:date/clang-built-linux/umkS84jS9m8/GAVVEgNYBgAJ
>>
>> Inaccessible...
>>
>>         This group either doesn't exist, or you don't have permission
>>         to access it. If you're sure this group exists, contact the
>>         Owner of the group and ask them to give you access.
> 
> Sorry, I set up the mailing list not too long ago, seem to have a long
> tail of permissions related issues.  I confirmed that the link was
> borked in an incognito window.  Via
> https://support.google.com/a/answer/9325317#Visibility I was able to
> change the obscure setting.  I now confirmed the above link works in
> an incognito window.  Thanks for reporting; can you please triple
> check?

Yep it works now, thanks.

>>
>> And you mean just changing to 'const' fixes something, how?
> 
> See the warning in the above link (assuming now you have access).
> Assigning a non-const variable the result of a function call that
> returns const discards the const qualifier.

Ok thanks for clarifying.

However I was speaking in terms of this fixing a functional bug rather
than a loss of const warning.
