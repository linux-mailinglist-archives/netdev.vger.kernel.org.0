Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4934123AB8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfLQXVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:21:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:40852 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfLQXVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:21:53 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihM9w-000678-W7; Wed, 18 Dec 2019 00:21:45 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihM9w-0005Ir-5Q; Wed, 18 Dec 2019 00:21:44 +0100
Subject: Re: [PATCH bpf-next] libbpf: Fix libbpf_common.h when installing
 libbpf through 'make install'
To:     Yonghong Song <yhs@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
References: <20191217112810.768078-1-toke@redhat.com>
 <c6a49edd-3992-6ddc-58d9-2c37acdeeece@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7e88179c-155e-ce8c-4641-debad4ca0631@iogearbox.net>
Date:   Wed, 18 Dec 2019 00:21:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c6a49edd-3992-6ddc-58d9-2c37acdeeece@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/19 10:58 PM, Yonghong Song wrote:
> On 12/17/19 3:28 AM, Toke Høiland-Jørgensen wrote:
>> This fixes two issues with the newly introduced libbpf_common.h file:
>>
>> - The header failed to include <string.h> for the definition of memset()
>> - The new file was not included in the install_headers rule in the Makefile
>>
>> Both of these issues cause breakage when installing libbpf with 'make
>> install' and trying to use it in applications.
>>
>> Fixes: 544402d4b493 ("libbpf: Extract common user-facing helpers")
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
