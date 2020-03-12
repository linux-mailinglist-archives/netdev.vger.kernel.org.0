Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C4D183D5A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgCLX3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:29:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:42966 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgCLX3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:29:32 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCXGZ-0001Bh-R7; Fri, 13 Mar 2020 00:29:27 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCXGZ-000Q77-It; Fri, 13 Mar 2020 00:29:27 +0100
Subject: Re: [PATCH bpf-next v2 0/2] tools: bpftool: fix object pinning and
 bash
To:     Martin KaFai Lau <kafai@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200312184608.12050-1-quentin@isovalent.com>
 <20200312202512.yuiesbhlrsglziap@kafai-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <af195126-9c8c-d6c2-f317-ab829319c8ba@iogearbox.net>
Date:   Fri, 13 Mar 2020 00:29:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200312202512.yuiesbhlrsglziap@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25749/Thu Mar 12 14:09:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 9:25 PM, Martin KaFai Lau wrote:
> On Thu, Mar 12, 2020 at 06:46:06PM +0000, Quentin Monnet wrote:
>> The first patch of this series improves user experience by allowing to pass
>> all kinds of handles for programs and maps (id, tag, name, pinned path)
>> instead of simply ids when pinning them with "bpftool (prog|map) pin".
>>
>> The second patch improves or fix bash completion, including for object
>> pinning.
>>
>> v2: Restore close() on file descriptor after pinning the object.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
