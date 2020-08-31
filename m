Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F94258242
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgHaUHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:07:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:39100 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729893AbgHaUHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:07:54 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCq5o-0002w4-Cn; Mon, 31 Aug 2020 22:07:52 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCq5o-000M2P-6P; Mon, 31 Aug 2020 22:07:52 +0200
Subject: Re: [PATCH bpf-next] bpf: Fix build without BPF_LSM.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     bjorn.topel@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20200831163132.66521-1-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <09c8c97f-a9fb-1521-c70b-45216b00a668@iogearbox.net>
Date:   Mon, 31 Aug 2020 22:07:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200831163132.66521-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 6:31 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> resolve_btfids doesn't like empty set. Add unused ID when BPF_LSM is off.
> 
> Reported-by: Björn Töpel <bjorn.topel@gmail.com>
> Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
