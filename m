Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6090914A264
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgA0K6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:58:43 -0500
Received: from www62.your-server.de ([213.133.104.62]:43446 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgA0K6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:58:43 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iw26L-00077P-0W; Mon, 27 Jan 2020 11:58:41 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iw26K-000GIJ-Kr; Mon, 27 Jan 2020 11:58:40 +0100
Subject: Re: [PATCH bpf-next v3 0/3] XDP flush cleanups
To:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com, ast@kernel.org,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
References: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <33363fbd-44e3-bffe-421c-367207db30c2@iogearbox.net>
Date:   Mon, 27 Jan 2020 11:58:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25707/Sun Jan 26 12:40:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/20 1:13 AM, John Fastabend wrote:
> A couple updates to cleanup some of the XDP comments and rcu usage.
> 
> It would be best if patch 1/3 goes into current bpf-next with the
> associated patch in the fixes tag so we don't have out of sync
> comments in the code. Just noting because its close to time to close
> {bpf|net}-next branches.
> 
> v2->v3: Jesper noticed I can't spell, so fixed spelling. If we
> are fixing comments its best to have correct spelling.
> 
> v1->v2: Added 2/3 patch for virtio_net to use rcu_access_pointer
> and avoid read_lock.
> 
> John Fastabend (3):
>    bpf: xdp, update devmap comments to reflect napi/rcu usage
>    bpf: xdp, virtio_net use access ptr macro for xdp enable check
>    bpf: xdp, remove no longer required rcu_read_{un}lock()
> 
>   drivers/net/veth.c       |  6 +++++-
>   drivers/net/virtio_net.c |  2 +-
>   kernel/bpf/devmap.c      | 26 ++++++++++++++------------
>   3 files changed, 20 insertions(+), 14 deletions(-)
> 

Series applied, thanks. I had to manually massage the patch 3/3 as it
wasn't rebased onto bpf-next.
