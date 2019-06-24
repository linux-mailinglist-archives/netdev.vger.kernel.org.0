Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C251D6A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732526AbfFXVxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:53:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33340 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFXVxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:53:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BCEE133E97CE;
        Mon, 24 Jun 2019 14:53:24 -0700 (PDT)
Date:   Mon, 24 Jun 2019 14:53:21 -0700 (PDT)
Message-Id: <20190624.145321.933638237488043613.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     snelson@pensando.io, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next 00/18] Add ionic driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624131952.0b90206e@cakuba.netronome.com>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190624131952.0b90206e@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 14:53:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 24 Jun 2019 13:19:52 -0700

> On Thu, 20 Jun 2019 13:24:06 -0700, Shannon Nelson wrote:
>>  28 files changed, 9970 insertions(+)
> 
> Dave, could we consider setting a LoC limit for series and patches?
> I know this is a new driver, but there's gotta be a way to split 
> this up more, even if it's painful for the submitter :S
> 
> All the debugfs stuff shouldn't be necessary in the first version,
> just looking at first 2 patches...

I hear what you're saying.  But I have to balance this with the concern
for creating a barrier for entry to submitting new drivers.

However, looking from another perspective you are right that review
burdon is not purely on a number of patches level, but rather the
product of number of patches and lines per patch and thus LoC.

I'd hate to specify a hard nuber and would rather try to apply
judgment onto individual submissions and deal with it on a case
by case basis.

If someone thinks a submission is too large, anyone can just say that
and we'll see what happens.

Thanks.
