Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D131166F09
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfGLMmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:42:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:46190 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfGLMmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:42:43 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hluss-00040u-1B; Fri, 12 Jul 2019 14:42:42 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlusr-000LFp-Ru; Fri, 12 Jul 2019 14:42:41 +0200
Subject: Re: [PATCH bpf-next v9 0/2] bpf: Allow bpf_skb_event_output for more
 prog types
To:     Allan Zhang <allanzhang@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20190710181811.127374-1-allanzhang@google.com>
 <CAEf4BzbkVPk_Ugktgi+6NUmQzLxNsBN_MO48dPKA8qCF+28RTA@mail.gmail.com>
 <CAMHgqJ71XDWSZDFOvcvu-sjDzrVp8+G8VdMx1fNUs5+xefhUSQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dd2e7fc6-9eec-2c01-5990-eae5817a5823@iogearbox.net>
Date:   Fri, 12 Jul 2019 14:42:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAMHgqJ71XDWSZDFOvcvu-sjDzrVp8+G8VdMx1fNUs5+xefhUSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2019 09:10 PM, Allan Zhang wrote:
> Sure, thanks. will do as suggested.

Yep, bpf-next is currently closed due to merge window, please resubmit
once it reopens.

Thanks,
Daniel
