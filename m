Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7427A222B59
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgGPS7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgGPS7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 14:59:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9CFC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 11:59:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34AD611E45920;
        Thu, 16 Jul 2020 11:59:50 -0700 (PDT)
Date:   Thu, 16 Jul 2020 11:59:47 -0700 (PDT)
Message-Id: <20200716.115947.741360685940124518.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [RFC] bonding driver terminology change proposal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKfmpSeqqD_RQwdFwsZG212tbNF0E__83xKWT44nGYs4AOjDJw@mail.gmail.com>
References: <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
        <20200713.180030.118342049848300015.davem@davemloft.net>
        <CAKfmpSeqqD_RQwdFwsZG212tbNF0E__83xKWT44nGYs4AOjDJw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jul 2020 11:59:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Wed, 15 Jul 2020 23:06:55 -0400

> On Mon, Jul 13, 2020 at 9:00 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Michal Kubecek <mkubecek@suse.cz>
>> Date: Tue, 14 Jul 2020 00:00:16 +0200
>>
>> > Could we, please, avoid breaking existing userspace tools and scripts?
>>
>> I will not let UAPI breakage, don't worry.
> 
> Seeking some clarification here. Does the output of
> /proc/net/bonding/<bond> fall under that umbrella as well?

Yes, anything user facing must not break.

