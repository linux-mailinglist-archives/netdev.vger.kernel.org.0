Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6851C47
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfFXU15 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Jun 2019 16:27:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFXU15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:27:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E21C128FECAD;
        Mon, 24 Jun 2019 13:27:56 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:27:55 -0700 (PDT)
Message-Id: <20190624.132755.801319459234383843.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     ndesaulniers@google.com, netdev@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH net v2 1/2] ipv6: constify rt6_nexthop()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3d7c16c4-9c3e-d18c-aad4-6583216ea457@6wind.com>
References: <20190624.102212.4398258272798722.davem@davemloft.net>
        <CAKwvOdkqE_RVosXAe9ULePR8A37CHh6+JtDMaRAghUA41Y_+yg@mail.gmail.com>
        <3d7c16c4-9c3e-d18c-aad4-6583216ea457@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 13:27:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 24 Jun 2019 20:18:37 +0200

> Le 24/06/2019 à 19:37, Nick Desaulniers a écrit :
> [snip]
>> 
>> The author stated that this patch was no functional change.  Nicolas,
>> it can be helpful to include compiler warnings in the commit message
>> when sending warning fixes, but it's not a big deal.  Thanks for
>> sending the patches.
>> 
> Yep, but I was not aware of this compilation warning. As explained in the commit
> log, the goal of this patch was to prepare the next one.

Yeah, don't worry about it.
