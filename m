Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB440586EB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfF0QWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:22:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0QWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:22:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37D7D14DB52E6;
        Thu, 27 Jun 2019 09:22:54 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:22:53 -0700 (PDT)
Message-Id: <20190627.092253.1878691006683087825.davem@davemloft.net>
To:     skhan@linuxfoundation.org
Cc:     c0d1n61at3@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH v2] packet: Fix undefined
 behavior in bit shift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7f6f44b2-3fe4-85f6-df3c-ad59f2eadba2@linuxfoundation.org>
References: <20190627010137.5612-1-c0d1n61at3@gmail.com>
        <20190627032532.18374-2-c0d1n61at3@gmail.com>
        <7f6f44b2-3fe4-85f6-df3c-ad59f2eadba2@linuxfoundation.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 09:22:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>
Date: Wed, 26 Jun 2019 21:32:52 -0600

> On 6/26/19 9:25 PM, Jiunn Chang wrote:
>> Shifting signed 32-bit value by 31 bits is undefined.  Changing most
>> significant bit to unsigned.
>> Changes included in v2:
>>    - use subsystem specific subject lines
>>    - CC required mailing lists
>> 
> 
> These version change lines don't belong in the change log.

For networking changes I actually like the change lines to be in the
commit log.  So please don't stray people this way, thanks.
