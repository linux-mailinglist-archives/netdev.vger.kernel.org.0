Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA76C92D0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfJBUVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:21:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36544 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJBUVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 16:21:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CE9315501857;
        Wed,  2 Oct 2019 13:21:31 -0700 (PDT)
Date:   Wed, 02 Oct 2019 13:21:21 -0700 (PDT)
Message-Id: <20191002.132121.402975401040540710.davem@davemloft.net>
To:     keescook@chromium.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pankaj.laxminarayan.bharadiya@intel.com, joe@perches.com,
        adobriyan@gmail.com, netdev@vger.kernel.org
Subject: Re: renaming FIELD_SIZEOF to sizeof_member
From:   David Miller <davem@davemloft.net>
In-Reply-To: <201910021115.9888E9B@keescook>
References: <CAHk-=wg8+eNK+SK1Ekqm0qNQHVM6e6YOdZx3yhsX6Ajo3gEupg@mail.gmail.com>
        <201909261347.3F04AFA0@keescook>
        <201910021115.9888E9B@keescook>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 13:21:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Wed, 2 Oct 2019 11:19:16 -0700

> On Thu, Sep 26, 2019 at 01:56:55PM -0700, Kees Cook wrote:
>> On Thu, Sep 26, 2019 at 01:06:01PM -0700, Linus Torvalds wrote:
>> >  (a) why didn't this use the already existing and well-named macro
>> > that nobody really had issues with?
>> 
>> That was suggested, but other folks wanted the more accurate "member"
>> instead of "field" since a treewide change was happening anyway:
>> https://www.openwall.com/lists/kernel-hardening/2019/07/02/2
>> 
>> At the end of the day, I really don't care -- I just want to have _one_
>> macro. :)
>> 
>> >  (b) I see no sign of the networking people having been asked about
>> > their preferences.
>> 
>> Yeah, that's entirely true. Totally my mistake; it seemed like a trivial
>> enough change that I didn't want to bother too many people. But let's
>> fix that now... Dave, do you have any concerns about this change of
>> FIELD_SIZEOF() to sizeof_member() (or if it prevails, sizeof_field())?
> 
> David, can you weight in on this? Are you okay with a mass renaming of
> FIELD_SIZEOF() to sizeof_member(), as the largest user of the old macro
> is in networking?

I have no objection to moving to sizeof_member().
