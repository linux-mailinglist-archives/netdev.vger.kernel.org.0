Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25EEB5DA3C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfGCBFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:05:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfGCBFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:05:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5327B140125A7;
        Tue,  2 Jul 2019 15:29:07 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:29:06 -0700 (PDT)
Message-Id: <20190702.152906.590540173372387063.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add random MAC address fallback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <60c26de4-23bc-a94b-d4a0-1216d8053e1f@gmail.com>
References: <61a7754f-bdf9-f69a-296d-47353a78c8b4@gmail.com>
        <60c26de4-23bc-a94b-d4a0-1216d8053e1f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:29:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 2 Jul 2019 18:49:14 +0200

> On 02.07.2019 08:18, Heiner Kallweit wrote:
>>>From 1c8bacf724f1450e5256c68fbff407305faf9cbd Mon Sep 17 00:00:00 2001
>> 
>> 
>> 
> 
> Sorry, something went wrong when preparing the commit message. I'll resubmit.

It helps to speak closer to the microphone.
