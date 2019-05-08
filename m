Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7291E182B8
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfEHXfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:35:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfEHXfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 19:35:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B4B514700BA0;
        Wed,  8 May 2019 16:35:10 -0700 (PDT)
Date:   Wed, 08 May 2019 16:35:09 -0700 (PDT)
Message-Id: <20190508.163509.962491051763041431.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com,
        pieter.jansenvanvuuren@netronome.com, dan.carpenter@oracle.com
Subject: Re: [PATCH net] net/sched: avoid double free on matchall reoffload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508225607.26052-1-jakub.kicinski@netronome.com>
References: <20190508225607.26052-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 16:35:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed,  8 May 2019 15:56:07 -0700

> From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> 
> Avoid freeing cls_mall.rule twice when failing to setup flow_action
> offload used in the hardware intermediate representation. This is
> achieved by returning 0 when the setup fails but the skip software
> flag has not been set.
> 
> Fixes: f00cbf196814 ("net/sched: use the hardware intermediate representation for matchall")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
