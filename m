Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC896148FF6
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgAXVPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:15:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:45730 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgAXVPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:15:04 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iv6I8-0005xx-1R; Fri, 24 Jan 2020 22:15:00 +0100
Received: from [178.197.248.48] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iv6I7-000Sou-No; Fri, 24 Jan 2020 22:14:59 +0100
Subject: Re: [PATCH bpf-next v2 0/4] Various fixes for sockmap and reuseport
 tests
To:     Martin Lau <kafai@fb.com>, Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200124112754.19664-1-lmb@cloudflare.com>
 <20200124154517.lqm2vhkdiirtoaut@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f344313c-1c69-f824-87de-511014fb405e@iogearbox.net>
Date:   Fri, 24 Jan 2020 22:14:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200124154517.lqm2vhkdiirtoaut@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25705/Fri Jan 24 12:39:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 4:45 PM, Martin Lau wrote:
> On Fri, Jan 24, 2020 at 11:27:50AM +0000, Lorenz Bauer wrote:
>> I've fixed the commit messages, added Fixes tags and am submitting to bpf-next instead
>> of the bpf tree.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Series applied (and also added John's ACKs he just sent for the v1 set), thanks!
