Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533261BFD8
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfEMXec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:34:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:60252 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfEMXec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:34:32 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKSk-0002kR-Nh; Tue, 14 May 2019 01:34:30 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKSk-00082r-IN; Tue, 14 May 2019 01:34:30 +0200
Subject: Re: [PATCH bpf] bpf: mark bpf_event_notify and bpf_event_init as
 static
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20190513190436.229860-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9d2fb425-9136-df1c-fd1d-7d1ca0d7783e@iogearbox.net>
Date:   Tue, 14 May 2019 01:34:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190513190436.229860-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/13/2019 09:04 PM, Stanislav Fomichev wrote:
> Both of them are not declared in the headers and not used outside
> of bpf_trace.c file.
> 
> Fixes: a38d1107f937c ("bpf: support raw tracepoints in modules")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
