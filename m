Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F139510E39D
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 22:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfLAVVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 16:21:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfLAVVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 16:21:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12D4814F9AF42;
        Sun,  1 Dec 2019 13:21:41 -0800 (PST)
Date:   Sun, 01 Dec 2019 13:21:40 -0800 (PST)
Message-Id: <20191201.132140.1492992458174891218.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net v2 0/2] openvswitch: remove a couple of BUG_ON()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1575221237.git.pabeni@redhat.com>
References: <cover.1575221237.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Dec 2019 13:21:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Sun,  1 Dec 2019 18:41:23 +0100

> The openvswitch kernel datapath includes some BUG_ON() statements to check
> for exceptional/unexpected failures. These patches drop a couple of them,
> where we can do that without introducing other side effects.
> 
> v1 -> v2:
>  - avoid memory leaks on error path

Series applied and queued up for -stable, thanks.
