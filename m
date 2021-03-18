Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680FA340CE1
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhCRSYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbhCRSXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:23:53 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199CEC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:23:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AB7704D31C532;
        Thu, 18 Mar 2021 11:23:49 -0700 (PDT)
Date:   Thu, 18 Mar 2021 11:23:45 -0700 (PDT)
Message-Id: <20210318.112345.1088585054654353399.davem@davemloft.net>
To:     edumazet@google.com
Cc:     ljp@linux.ibm.com, netdev@vger.kernel.org, kuba@kernel.org,
        tlfalcon@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, shemminger@linux-foundation.org
Subject: Re: [PATCH net] net: core: avoid napi_disable to cause deadlock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANn89iK-AQeDvdV-FSjqA6QPm=tSUJTqMZ2z8D1Dw401n-xPYg@mail.gmail.com>
References: <20210318080450.38893-1-ljp@linux.ibm.com>
        <CANn89iK-AQeDvdV-FSjqA6QPm=tSUJTqMZ2z8D1Dw401n-xPYg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 18 Mar 2021 11:23:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 18 Mar 2021 10:22:23 +0100

> On Thu, Mar 18, 2021 at 9:04 AM Lijun Pan <ljp@linux.ibm.com> wrote:
>>
>> There are chances that napi_disable is called twice by NIC driver.
> 
> 
> ???
> 
> Please fix the buggy driver, or explain why it can not be fixed.

Agreed,.
