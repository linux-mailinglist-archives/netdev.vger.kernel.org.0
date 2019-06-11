Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305143C0DF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 03:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390080AbfFKBUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 21:20:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388845AbfFKBUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 21:20:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 869601513ABDB;
        Mon, 10 Jun 2019 18:20:45 -0700 (PDT)
Date:   Mon, 10 Jun 2019 18:20:43 -0700 (PDT)
Message-Id: <20190610.182043.1165253938894520472.davem@davemloft.net>
To:     benve@cisco.com
Cc:     ssuryaextr@gmail.com, gvaradar@cisco.com, netdev@vger.kernel.org,
        govind.varadar@gmail.com
Subject: Re: [PATCH net] net: handle 802.1P vlan 0 packets properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BYAPR11MB351224279A7FDF2B9C5A73A5BAED0@BYAPR11MB3512.namprd11.prod.outlook.com>
References: <20190610.142810.138225058759413106.davem@davemloft.net>
        <20190610230836.GA3390@ubuntu>
        <BYAPR11MB351224279A7FDF2B9C5A73A5BAED0@BYAPR11MB3512.namprd11.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 18:20:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Christian Benvenuti (benve)" <benve@cisco.com>
Date: Tue, 11 Jun 2019 00:35:59 +0000

>   if we assume that the kernel is supposed to deal properly with .1p tagged frames, regardless
> of what the next header is (802.{1Q,1AD} or something else), I think the case this patch was
> trying to address (that is 1Q+1AD) is not handled properly in the case of priority tagged frames
> when the (1Q) vlan is untagged and therefore 1Q is only used to carry 1p.
>  
>     [1P vid=0][1AD].
> 
> Here is a simplified summary of how the kernel is dealing with priority frames right now, based on
> - what the next protocol is
> and
> - whether a vlan device exists or not for the outer (1Q) header.

Yeah I think I misunderstood the situation.

Please repost the patch.

Thanks.
