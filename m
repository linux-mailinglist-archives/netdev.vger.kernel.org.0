Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE4215EE4
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgGFSjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:39:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:46316 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730051AbgGFSjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:39:36 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsW1Y-0003QI-T3; Mon, 06 Jul 2020 20:39:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsW1Y-000K6c-LS; Mon, 06 Jul 2020 20:39:28 +0200
Subject: Re: [PATCH bpf-next 00/14] xsk: support shared umems between devices
 and queues
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b016b064-3e46-d73c-758f-4c0e97c1f1a4@iogearbox.net>
Date:   Mon, 6 Jul 2020 20:39:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25865/Mon Jul  6 16:07:44 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/20 2:18 PM, Magnus Karlsson wrote:
> This patch set adds support to share a umem between AF_XDP sockets
> bound to different queue ids on the same device or even between
> devices. It has already been possible to do this by registering the
> umem multiple times, but this wastes a lot of memory. Just imagine
> having 10 threads each having 10 sockets open sharing a single
> umem. This means that you would have to register the umem 100 times
> consuming large quantities of memory.

[...]

> Note to Maxim at Mellanox. I do not have a mlx5 card, so I have not
> been able to test the changes to your driver. It compiles, but that is
> all I can say, so it would be great if you could test it. Also, I did
> change the name of many functions and variables from umem to pool as a
> buffer pool is passed down to the driver in this patch set instead of
> the umem. I did not change the name of the files umem.c and
> umem.h. Please go through the changes and change things to your
> liking.

Bjorn / Maxim, this is waiting on review (& mlx5 testing) from you, ptal.

Thanks,
Daniel
