Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDC71C3036
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgECW6J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 3 May 2020 18:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgECW6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:58:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CA7C061A0E;
        Sun,  3 May 2020 15:58:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C4351211C987;
        Sun,  3 May 2020 15:58:08 -0700 (PDT)
Date:   Sun, 03 May 2020 15:58:07 -0700 (PDT)
Message-Id: <20200503.155807.975495147223194743.davem@davemloft.net>
To:     bjorn@mork.no
Cc:     Kangie@footclan.ninja, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for DW5816e
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87v9ldlccp.fsf@miraculix.mork.no>
References: <20200502155228.11535-1-Kangie@footclan.ninja>
        <87v9ldlccp.fsf@miraculix.mork.no>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 May 2020 15:58:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Sun, 03 May 2020 09:13:58 +0200

> Matt Jolly <Kangie@footclan.ninja> writes:
> 
>> Add support for Dell Wireless 5816e to drivers/net/usb/qmi_wwan.c
>>
>> Signed-off-by: Matt Jolly <Kangie@footclan.ninja>
 ...
> Looks fine to me.  Please add to the stable queue as well,  Thanks.
> 
> Acked-by: Bjørn Mork <bjorn@mork.no>

Applied and queued up for -stable.
