Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC412298A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfLQLJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:09:42 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63380 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLQLJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:09:42 -0500
Received: from fsav107.sakura.ne.jp (fsav107.sakura.ne.jp [27.133.134.234])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xBHB9Z8C070263;
        Tue, 17 Dec 2019 20:09:35 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav107.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav107.sakura.ne.jp);
 Tue, 17 Dec 2019 20:09:35 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav107.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id xBHB9Tx7070228
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Tue, 17 Dec 2019 20:09:35 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] net-sysfs: Call dev_hold always in rx_queue_add_kobject
To:     jouni.hogander@unikie.com, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
References: <20191217084429.28001-1-jouni.hogander@unikie.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <825f5099-db9a-671e-dece-0217339833de@i-love.sakura.ne.jp>
Date:   Tue, 17 Dec 2019 20:09:30 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191217084429.28001-1-jouni.hogander@unikie.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/17 17:44, jouni.hogander@unikie.com wrote:
> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Dev_hold has to be called always in rx_queue_add_kobject.
> Otherwise usage count drops below 0 in case of failure in
> kobject_init_and_add.
> 
> Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject")
> Reported-by: Hulk Robot <hulkci@huawei.com>

This bug was originally reported by

  syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>

and forwarded by me. Who is "Hulk Robot <hulkci@huawei.com>" ?
