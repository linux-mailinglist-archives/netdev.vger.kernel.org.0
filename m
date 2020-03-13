Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0C184FF5
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 21:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgCMUNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 16:13:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:47192 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMUNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 16:13:07 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCqg4-0006tE-AZ; Fri, 13 Mar 2020 21:13:04 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCqg4-0007uO-0X; Fri, 13 Mar 2020 21:13:04 +0100
Subject: Re: [PATCH bpf-next] bpf_helpers_doc.py: Fix warning when compiling
 bpftool.
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, quentin@isovalent.com,
        ebiederm@xmission.com, brouer@redhat.com, bpf@vger.kernel.org
References: <20200313154650.13366-1-cneirabustos@gmail.com>
 <20200313172119.3vflwxlbikvqdcqh@kafai-mbp> <20200313182319.GA13630@bpf-dev>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2ac3730c-123c-df3e-0ec8-45957bbf8d8a@iogearbox.net>
Date:   Fri, 13 Mar 2020 21:13:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200313182319.GA13630@bpf-dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25750/Fri Mar 13 14:03:09 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/20 7:23 PM, Carlos Antonio Neira Bustos wrote:
> On Fri, Mar 13, 2020 at 10:21:19AM -0700, Martin KaFai Lau wrote:
>> On Fri, Mar 13, 2020 at 12:46:50PM -0300, Carlos Neira wrote:
>>>
>>> When compiling bpftool the following warning is found:
>>> "declaration of 'struct bpf_pidns_info' will not be visible outside of this function."
>>> This patch adds struct bpf_pidns_info to type_fwds array to fix this.
>>>
>>> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
>> Fixes: b4490c5c4e02 ("bpf: Added new helper bpf_get_ns_current_pid_tgid")
>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>>
>> Please add the Fixes tag next time.  Other than tracking,
>> it will be easier for review purpose also.
> 
> Thanks, I will do that in the future.

Applied, thanks!
