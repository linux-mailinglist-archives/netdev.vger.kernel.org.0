Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E04C2B15
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfI3XtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:49:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40222 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3XtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:49:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2EDF154F4976;
        Mon, 30 Sep 2019 16:48:59 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:48:57 -0700 (PDT)
Message-Id: <20190930.164857.1326063600782757885.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/5] ionic: driver updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930214920.18764-1-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 16:48:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 30 Sep 2019 14:49:15 -0700

> These patches are a few updates to clean up some code
> issues and add an ethtool feature.
> 
> v2: add cover letter
>     edit a couple of patch descriptions for clarity and add Fixes tags

I agree with Jakub that Fixes: tags for cleanups really doesn't fit the
character and usage of Fixes:.

Please address this and the rest of his feedback, thank you.
