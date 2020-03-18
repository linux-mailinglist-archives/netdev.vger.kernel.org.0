Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5836B1894D1
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgCREVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:21:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgCREVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:21:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72EBD141C8E51;
        Tue, 17 Mar 2020 21:21:20 -0700 (PDT)
Date:   Tue, 17 Mar 2020 21:21:19 -0700 (PDT)
Message-Id: <20200317.212119.1685899802035487434.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/5] ionic bits and bytes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317032210.7996-1-snelson@pensando.io>
References: <20200317032210.7996-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 21:21:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 16 Mar 2020 20:22:05 -0700

> These are a few little updates to the ionic driver while we are in between
> other feature work.  While these are mostly Fixes, they are almost all low
> priority and needn't be promoted to net.  The one higher need is patch 1,
> but it is fixing something that hasn't made it out of net-next yet.
> 
> v3: allow decode of unknown transciever and use type
>     codes from sfp.h
> v2: add Fixes tags to patches 1-4, and a little
>     description for patch 5

Series applied to net-next.
