Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF65146DAA
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAWP7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:59:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:37840 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgAWP7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:59:21 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuesw-0002U1-Du; Thu, 23 Jan 2020 16:59:10 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuesv-0002p8-Si; Thu, 23 Jan 2020 16:59:09 +0100
Subject: Re: [PATCH] bpf: devmap: Pass lockdep expression to RCU lists
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Amol Grover <frextrite@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20200123120437.26506-1-frextrite@gmail.com>
 <87d0ba9ttp.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b019ff62-08f5-1536-48f3-484b9dc2e064@iogearbox.net>
Date:   Thu, 23 Jan 2020 16:59:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87d0ba9ttp.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 2:38 PM, Toke Høiland-Jørgensen wrote:
> Amol Grover <frextrite@gmail.com> writes:
> 
>> head is traversed using hlist_for_each_entry_rcu outside an
>> RCU read-side critical section but under the protection
>> of dtab->index_lock.
>>
>> Hence, add corresponding lockdep expression to silence false-positive
>> lockdep warnings, and harden RCU lists.
>>
>> Signed-off-by: Amol Grover <frextrite@gmail.com>
> 
> Could you please add an appropriate Fixes: tag?

+1, please reply with Fixes: tag (no need to resend).
