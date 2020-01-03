Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F15C12FDDB
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgACUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:24:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbgACUYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:24:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58E8C15976323;
        Fri,  3 Jan 2020 12:24:49 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:24:48 -0800 (PST)
Message-Id: <20200103.122448.535296179519230066.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     lirongqing@baidu.com, netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] net: remove the check argument from
 __skb_gro_checksum_convert
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103081039.GE12930@netronome.com>
References: <1578023460-12331-1-git-send-email-lirongqing@baidu.com>
        <20200103081039.GE12930@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:24:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Fri, 3 Jan 2020 09:10:39 +0100

> On Fri, Jan 03, 2020 at 11:51:00AM +0800, Li RongQing wrote:
>> The argument is always ignored, so remove it.
>> 
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> 
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied, thanks.
