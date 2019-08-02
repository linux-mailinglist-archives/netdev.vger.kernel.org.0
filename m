Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B184B80317
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 01:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437420AbfHBXTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 19:19:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729267AbfHBXTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 19:19:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AC24153FF93E;
        Fri,  2 Aug 2019 16:19:36 -0700 (PDT)
Date:   Fri, 02 Aug 2019 16:19:32 -0700 (PDT)
Message-Id: <20190802.161932.1776993765494484851.davem@davemloft.net>
To:     joe@perches.com
Cc:     nhorman@tuxdriver.com, vyasevich@gmail.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a03a23728d3b468942a20b55f70babceaec587ee.camel@perches.com>
References: <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
        <20190731121646.GD9823@hmswarspite.think-freely.org>
        <a03a23728d3b468942a20b55f70babceaec587ee.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 16:19:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 02 Aug 2019 10:47:34 -0700

> On Wed, 2019-07-31 at 08:16 -0400, Neil Horman wrote:
>> On Wed, Jul 31, 2019 at 04:32:43AM -0700, Joe Perches wrote:
>> > On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
>> > > On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
>> > > > fallthrough may become a pseudo reserved keyword so this only use of
>> > > > fallthrough is better renamed to allow it.
> 
> Can you or any other maintainer apply this patch
> or ack it so David Miller can apply it?

I, like others, don't like the lack of __ in the keyword.  It's kind of
rediculous the problems it creates to pollute the global namespace like
that and yes also inconsistent with other shorthands for builtins.
