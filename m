Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB61147381
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 23:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgAWWEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 17:04:43 -0500
Received: from www62.your-server.de ([213.133.104.62]:42932 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgAWWEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 17:04:43 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iukaX-0004Li-4E; Thu, 23 Jan 2020 23:04:33 +0100
Received: from [178.197.248.20] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iukaW-000K4o-HK; Thu, 23 Jan 2020 23:04:32 +0100
Subject: Re: [PATCH] bpf: devmap: Pass lockdep expression to RCU lists
To:     Amol Grover <frextrite@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, brouer@redhat.com,
        toke@redhat.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20200123120437.26506-1-frextrite@gmail.com>
 <20200123171800.GC4484@workstation-portable>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <991cab17-3616-4cb4-60f5-5fe235e5bec8@iogearbox.net>
Date:   Thu, 23 Jan 2020 23:04:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200123171800.GC4484@workstation-portable>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 6:18 PM, Amol Grover wrote:
> On Thu, Jan 23, 2020 at 05:34:38PM +0530, Amol Grover wrote:
>> head is traversed using hlist_for_each_entry_rcu outside an
>> RCU read-side critical section but under the protection
>> of dtab->index_lock.
>>
>> Hence, add corresponding lockdep expression to silence false-positive
>> lockdep warnings, and harden RCU lists.
>>
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
>> Signed-off-by: Amol Grover <frextrite@gmail.com>

Applied, thanks!
