Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB146100185
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 10:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfKRJjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 04:39:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:37698 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfKRJjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 04:39:36 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWdVO-0007Dx-UJ; Mon, 18 Nov 2019 10:39:34 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWdVO-00072o-KV; Mon, 18 Nov 2019 10:39:34 +0100
Subject: Re: [PATCH bpf] selftests: bpf: xdping is not meant to be run
 standalone
To:     Jiri Benc <jbenc@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
References: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com>
 <427e0b06-679e-5621-f828-be545e6ca3b1@iogearbox.net>
 <20191118091821.4a1b3faf@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dcd526b1-a198-3e37-d94a-e845fdb0267d@iogearbox.net>
Date:   Mon, 18 Nov 2019 10:39:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191118091821.4a1b3faf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25636/Sun Nov 17 10:57:06 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 9:18 AM, Jiri Benc wrote:
> On Fri, 15 Nov 2019 23:06:13 +0100, Daniel Borkmann wrote:
>> Any objections if I take this to bpf-next as otherwise this will create an ugly
>> merge conflict between bpf and bpf-next given selftests have been heavily reworked
>> in there.
> 
> Should I resend against bpf-next?

I can take care of it today, no need.

Thanks,
Daniel
