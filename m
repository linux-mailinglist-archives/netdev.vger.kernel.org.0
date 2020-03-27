Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903BA196172
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgC0WqM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Mar 2020 18:46:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgC0WqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:46:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79B1215BB70B4;
        Fri, 27 Mar 2020 15:46:10 -0700 (PDT)
Date:   Fri, 27 Mar 2020 15:46:09 -0700 (PDT)
Message-Id: <20200327.154609.741168661523502246.davem@davemloft.net>
To:     brambonne@google.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        hannes@stressinduktion.org, netdev@vger.kernel.org,
        lorenzo@google.com, jeffv@google.com
Subject: Re: [RFC PATCH] ipv6: Use dev_addr in stable-privacy address
 generation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com>
References: <20200326094252.157914-1-brambonne@google.com>
        <20200326.114550.2060060414897819387.davem@davemloft.net>
        <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 15:46:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bram Bonné <brambonne@google.com>
Date: Fri, 27 Mar 2020 12:50:07 +0100

> Could you help me understand the use cases where the admin / user
> chooses to use MAC address randomization, but still wants an IPv6
> link-local address that remains stable across these networks? My
> assumption was that the latter would defeat the purpose of the former,
> though it's entirely possible that I'm missing something.

Someone could renumber all of their MACs using a certain numbering
scheme, but that would not ensure the kind of uniqueness that the
physical MAC does.
