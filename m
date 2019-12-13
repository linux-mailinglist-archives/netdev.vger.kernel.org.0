Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E85F11DEBD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 08:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfLMHiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 02:38:52 -0500
Received: from relay.sw.ru ([185.231.240.75]:43538 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbfLMHiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 02:38:52 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1iffWS-0004Zi-Kb; Fri, 13 Dec 2019 10:38:00 +0300
Subject: Re: [PATCH net-next v2 0/2] unix: Show number of scm files in fdinfo
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, axboe@kernel.dk,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, hare@suse.com, tglx@linutronix.de,
        edumazet@google.com, arnd@arndb.de
References: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
 <20191212.170506.1014670344797867509.davem@davemloft.net>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <57b6c0a4-285e-e429-2e87-41b5079974e1@virtuozzo.com>
Date:   Fri, 13 Dec 2019 10:37:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191212.170506.1014670344797867509.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.12.2019 04:05, David Miller wrote:
> From: Kirill Tkhai <ktkhai@virtuozzo.com>
> Date: Mon, 09 Dec 2019 13:03:34 +0300
> 
>> v2: Pass correct argument to locked in patch [2/2].
>>
>> Unix sockets like a block box. You never know what is pending there:
>> there may be a file descriptor holding a mount or a block device,
>> or there may be whole universes with namespaces, sockets with receive
>> queues full of sockets etc.
>>
>> The patchset makes number of pending scm files be visible in fdinfo.
>> This may be useful to determine, that socket should be investigated
>> or which task should be killed to put a reference counter on a resourse.
>>
>> $cat /proc/[pid]/fdinfo/[unix_sk_fd] | grep scm_fds
>> scm_fds: 1
> 
> Series applied.

Thanks, David.

