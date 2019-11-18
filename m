Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4F5100F53
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfKRXNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:13:44 -0500
Received: from www62.your-server.de ([213.133.104.62]:37998 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfKRXNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 18:13:43 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWqDF-00075M-T0; Tue, 19 Nov 2019 00:13:41 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWqDF-0000qK-Gs; Tue, 19 Nov 2019 00:13:41 +0100
Subject: Re: [PATCH bpf] selftests: bpf: fix test_tc_tunnel hanging
To:     Jiri Benc <jbenc@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
References: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
 <dc889f46-bc26-df21-bf24-906a6ccf7a12@iogearbox.net>
 <CAF=yD-K53UaChX7S6YzNaCTArYf3RVWGPdskeEd5bEaBfuaonQ@mail.gmail.com>
 <20191118105145.3e576745@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b4c05bc0-13a0-39bb-2e90-54ed93050d27@iogearbox.net>
Date:   Tue, 19 Nov 2019 00:13:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191118105145.3e576745@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25637/Mon Nov 18 10:53:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 10:51 AM, Jiri Benc wrote:
> On Fri, 15 Nov 2019 17:05:42 -0500, Willem de Bruijn wrote:
>> Ah, a typo. This is the SHA1 in my tree, note the aa9d --> aa99d
>>
>> $ git fetch davem-net-next
>> $ git log -1 --oneline -- tools/testing/selftests/bpf/test_tc_tunnel.sh
>> f6ad6accaa99d selftests/bpf: expand test_tc_tunnel with SIT encap
> 
> Indeed, it should have been:
> 
> Fixes: f6ad6accaa99 ("selftests/bpf: expand test_tc_tunnel with SIT encap")
> 
> Not sure how that happened, I'm sorry for that. Thanks for catching it.
> Should I resend with the fixed commit message?
> 
> Sorry again,

Ok, fixed up and applied both of your patches to bpf-next, thanks!
