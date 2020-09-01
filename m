Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B1225977B
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbgIAQOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:14:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:33212 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731424AbgIAQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 12:13:50 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kD8uj-0002pa-A7; Tue, 01 Sep 2020 18:13:41 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kD8uj-0001E8-4A; Tue, 01 Sep 2020 18:13:41 +0200
Subject: Re: [PATCH bpf] tools/bpf: build: make sure resolve_btfids cleans up
 after itself
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     ast@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        jolsa@kernel.org
References: <20200901144343.179552-1-toke@redhat.com>
 <20200901152048.GA470123@krava> <87sgc1iior.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <68904564-aa5a-0ba7-01e6-21484daceb8c@iogearbox.net>
Date:   Tue, 1 Sep 2020 18:13:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87sgc1iior.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25917/Tue Sep  1 15:24:01 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 6:08 PM, Toke Høiland-Jørgensen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
>> On Tue, Sep 01, 2020 at 04:43:43PM +0200, Toke HÃ¸iland-JÃ¸rgensen wrote:
>>> The new resolve_btfids tool did not clean up the feature detection folder
>>> on 'make clean', and also was not called properly from the clean rule in
>>> tools/make/ folder on its 'make clean'. This lead to stale objects being
>>> left around, which could cause feature detection to fail on subsequent
>>> builds.
>>>
>>> Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
>>> Signed-off-by: Toke HÃ¸iland-JÃ¸rgensen <toke@redhat.com>

Applied, thanks guys!

