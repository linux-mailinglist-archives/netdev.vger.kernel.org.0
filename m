Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D6320A746
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405733AbgFYVMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:12:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:59798 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405718AbgFYVMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 17:12:51 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1joZAu-0000IB-JK; Thu, 25 Jun 2020 23:12:48 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1joZAu-000737-AM; Thu, 25 Jun 2020 23:12:48 +0200
Subject: Re: [PATCH bpf] libbpf: adjust SEC short cut for expected attach type
 BPF_XDP_DEVMAP
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        andriin@fb.com
Cc:     netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Ahern <dsahern@gmail.com>
References: <CAADnVQ+tiHo1y12ae4EREtBiU=AKUW7upMV4Pfa8Yc7mrAsqEg@mail.gmail.com>
 <159309521882.821855.6873145686353617509.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5580b36e-340c-7032-588d-9cc66888e9f0@iogearbox.net>
Date:   Thu, 25 Jun 2020 23:12:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159309521882.821855.6873145686353617509.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25854/Thu Jun 25 15:16:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/20 4:26 PM, Jesper Dangaard Brouer wrote:
> Adjust the SEC("xdp_devmap/") prog type prefix to contain a
> slash "/" for expected attach type BPF_XDP_DEVMAP.  This is consistent
> with other prog types like tracing.
> 
> Fixes: 2778797037a6 ("libbpf: Add SEC name for xdp programs attached to device map")
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Given it's not released yet, lgtm, applied, thanks!
