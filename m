Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB822123C7E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 02:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfLRBg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 20:36:57 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64064 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfLRBg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 20:36:56 -0500
Received: from fsav301.sakura.ne.jp (fsav301.sakura.ne.jp [153.120.85.132])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xBI1alIO017874;
        Wed, 18 Dec 2019 10:36:47 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav301.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav301.sakura.ne.jp);
 Wed, 18 Dec 2019 10:36:47 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav301.sakura.ne.jp)
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xBI1alod017862;
        Wed, 18 Dec 2019 10:36:47 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: (from i-love@localhost)
        by www262.sakura.ne.jp (8.15.2/8.15.2/Submit) id xBI1alSc017861;
        Wed, 18 Dec 2019 10:36:47 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Message-Id: <201912180136.xBI1alSc017861@www262.sakura.ne.jp>
X-Authentication-Warning: www262.sakura.ne.jp: i-love set sender to penguin-kernel@i-love.sakura.ne.jp using -f
Subject: Re: [PATCH] net-sysfs: Call =?ISO-2022-JP?B?ZGV2X2hvbGQgYWx3YXlzIGluIHJ4?=
 =?ISO-2022-JP?B?X3F1ZXVlX2FkZF9rb2JqZWN0?=
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     David Miller <davem@davemloft.net>
Cc:     jouni.hogander@unikie.com, netdev@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, lukas.bulwahn@gmail.com
MIME-Version: 1.0
Date:   Wed, 18 Dec 2019 10:36:47 +0900
References: <20191217084429.28001-1-jouni.hogander@unikie.com> <20191217.142048.1420015947023495901.davem@davemloft.net>
In-Reply-To: <20191217.142048.1420015947023495901.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote:
> From: jouni.hogander@unikie.com
> Date: Tue, 17 Dec 2019 10:44:29 +0200
> 
> > From: Jouni Hogander <jouni.hogander@unikie.com>
> > 
> > Dev_hold has to be called always in rx_queue_add_kobject.
> > Otherwise usage count drops below 0 in case of failure in
> > kobject_init_and_add.
> > 
> > Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Why are you posting this again, the change is already in my tree?
> 

Not posting again. Previous patch was for "netdev_queue_add_kobject" and
this patch is for "rx_queue_add_kobject". Also, Reported-by: in this patch
is wrong. Please apply an updated patch shown below.

  Date: Tue, 17 Dec 2019 13:46:34 +0200
  Message-Id: <20191217114634.9428-1-jouni.hogander@unikie.com>
