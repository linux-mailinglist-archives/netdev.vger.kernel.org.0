Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CC821E4CE
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGNAvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgGNAvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:51:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812CFC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:51:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4074B12986ED5;
        Mon, 13 Jul 2020 17:51:38 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:51:37 -0700 (PDT)
Message-Id: <20200713.175137.2050137423148058887.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] bonding driver terminology change proposal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:51:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Mon, 13 Jul 2020 14:51:39 -0400

> To start out with, I'd like to attempt to eliminate as much of the use
> of master and slave in the bonding driver as possible. For the most
> part, I think this can be done without breaking UAPI, but may require
> changes to anything accessing bond info via proc or sysfs.

You can change what you want internally to the driver in order to meet
this objective, but I am positively sure that external facing UAPI has
to be retained.
