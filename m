Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E033C1F8
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhCOQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:33:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:40128 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbhCOQck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:32:40 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lLq8z-000DTs-1U; Mon, 15 Mar 2021 17:32:37 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lLq8y-000L5P-SG; Mon, 15 Mar 2021 17:32:36 +0100
Subject: Re: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel
 opt failed
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
References: <20210309032214.2112438-1-liuhangbin@gmail.com>
 <20210312015617.GZ2900@Leo-laptop-t470s>
 <0b5c810b-5eec-c7b0-15fc-81c989494202@iogearbox.net>
 <20210315065734.GA2900@Leo-laptop-t470s>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8900191d-fa04-6aaa-f214-92e4cad338a9@iogearbox.net>
Date:   Mon, 15 Mar 2021 17:32:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210315065734.GA2900@Leo-laptop-t470s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26109/Mon Mar 15 12:06:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 7:57 AM, Hangbin Liu wrote:
> On Fri, Mar 12, 2021 at 04:15:27PM +0100, Daniel Borkmann wrote:
>> On 3/12/21 2:56 AM, Hangbin Liu wrote:
>>> Hi David,
>>>
>>> May I ask what's the status of this patch? From patchwork[1] the state is
>>> accepted. But I can't find the fix on net or net-next.
>>
>> I think there may have been two confusions, i) that $subject says that this goes
>> via net tree instead of bpf tree, which might have caused auto-delegation to move
>> this into 'netdev' patchwork reviewer bucket, and ii) the kernel patchwork bot then
>> had a mismatch as you noticed when it checked net-next after tree merge and replied
>> to the wrong patch of yours which then placed this one into 'accepted' state. I just
>> delegated it to bpf and placed it back under review..
>>
>>> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20210309032214.2112438-1-liuhangbin@gmail.com/
> 
> Thanks Daniel, I thought the issue also exists on net tree and is a fixup. So
> I set the target to 'net'.

Sure; in the end this gets routed via bpf to net tree given it's bpf selftests, so
$subj should target bpf. Anyway, applied now, thanks!
