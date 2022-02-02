Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84A24A6EBB
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245705AbiBBKbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:31:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:56050 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiBBKbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:31:44 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFCvK-0000ju-Tk; Wed, 02 Feb 2022 11:31:38 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFCvK-0009La-Lp; Wed, 02 Feb 2022 11:31:38 +0100
Subject: Re: [PATCH net] net, neigh: Do not trigger immediate probes on
 NUD_FAILED from neigh_managed_work
To:     davem@davemloft.net
Cc:     kuba@kernel.org, roopa@nvidia.com, edumazet@google.com,
        dsahern@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org,
        syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
References: <20220201193942.5055-1-daniel@iogearbox.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2aef3b34-26e6-67ea-296e-8c61d0934e76@iogearbox.net>
Date:   Wed, 2 Feb 2022 11:31:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220201193942.5055-1-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26440/Tue Feb  1 10:29:16 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/22 8:39 PM, Daniel Borkmann wrote:
> syzkaller was able to trigger a deadlock for NTF_MANAGED entries [0]:
> 
[...]
> 
> Fixes: 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
> Reported-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Roopa Prabhu <roopa@nvidia.com>

Tested-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
