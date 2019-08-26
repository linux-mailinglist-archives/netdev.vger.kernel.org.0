Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2AE9D90E
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHZWZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:25:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfHZWZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:25:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05E2F152539BC;
        Mon, 26 Aug 2019 15:25:25 -0700 (PDT)
Date:   Mon, 26 Aug 2019 15:25:25 -0700 (PDT)
Message-Id: <20190826.152525.144590581669280532.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     jakub.kicinski@netronome.com, jiri@resnulli.us,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ddd05712-e8c7-3c08-11c7-9840f5b64226@gmail.com>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
        <20190826.151819.804077961408964282.davem@davemloft.net>
        <ddd05712-e8c7-3c08-11c7-9840f5b64226@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 15:25:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Mon, 26 Aug 2019 16:24:38 -0600

> On 8/26/19 4:18 PM, David Miller wrote:
>> I honestly think that the size of link dumps are out of hand as-is.
> 
> so you are suggesting new alternate names should not appear in kernel
> generated RTM_NEWLINK messages - be it a link dump or a notification on
> a change?

I counter with the question of how much crap can we keep sticking in there
before we have to do something else to provide that information?
