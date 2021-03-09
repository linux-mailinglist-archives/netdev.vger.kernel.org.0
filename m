Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332E033219D
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 10:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCIJKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 04:10:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:46000 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCIJJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 04:09:46 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJYN5-000GYE-Na; Tue, 09 Mar 2021 10:09:43 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJYN5-000AtG-F5; Tue, 09 Mar 2021 10:09:43 +0100
Subject: Re: [PATCH bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast
 support
To:     Hangbin Liu <liuhangbin@gmail.com>,
        kernel test robot <lkp@intel.com>
Cc:     bpf@vger.kernel.org, kbuild-all@01.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20210309072948.2127710-3-liuhangbin@gmail.com>
 <202103091607.YXhmDMeL-lkp@intel.com>
 <20210309085530.GW2900@Leo-laptop-t470s>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5dfb1386-3369-47b6-7c07-08bd44d02e47@iogearbox.net>
Date:   Tue, 9 Mar 2021 10:09:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210309085530.GW2900@Leo-laptop-t470s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26102/Mon Mar  8 13:03:13 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 9:55 AM, Hangbin Liu wrote:
> On Tue, Mar 09, 2021 at 04:22:44PM +0800, kernel test robot wrote:
>> Hi Hangbin,
>>
>> Thank you for the patch! Yet something to improve:
> 
> Thanks, I forgot to modify it when rename the flag name.

Sigh, so this was not even compiled prior to submission ... ? :-(
