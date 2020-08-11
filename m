Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0648241BAD
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 15:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgHKNnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 09:43:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:35546 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbgHKNnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 09:43:15 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k5UYb-0006ek-Kk; Tue, 11 Aug 2020 15:43:13 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k5UYW-000JM1-F9; Tue, 11 Aug 2020 15:43:08 +0200
Subject: Re: [PATCH bpf] selftests/bpf: fix v4_to_v6 in sk_lookup
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20200807223846.4190917-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c3f0c469-2491-8e35-ce88-df8a6afcd41a@iogearbox.net>
Date:   Tue, 11 Aug 2020 15:43:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200807223846.4190917-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25900/Mon Aug 10 14:44:29 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/20 12:38 AM, Stanislav Fomichev wrote:
> I'm getting some garbage in bytes 8 and 9 when doing conversion
> from sockaddr_in to sockaddr_in6 (leftover from AF_INET?).
> Let's explicitly clear the higher bytes.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
