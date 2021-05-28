Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B3F3944E2
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 17:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbhE1PPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 11:15:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:46260 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhE1PPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 11:15:15 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmdw3-0008I6-7V; Fri, 28 May 2021 16:58:03 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lmdw3-000XUh-3O; Fri, 28 May 2021 16:58:03 +0200
Subject: Re: XDP-hints working group mailing list is active
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        BPF-dev-list <bpf@vger.kernel.org>
Cc:     XDP-hints working-group <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210528161917.0810d5ca@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e9132d87-9de7-a9af-6e2f-91201993124b@iogearbox.net>
Date:   Fri, 28 May 2021 16:58:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210528161917.0810d5ca@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26184/Fri May 28 13:05:50 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 4:19 PM, Jesper Dangaard Brouer wrote:
> Hi BPF-community,
> 
> We have created a mailing list for the XDP-hints working group (Cc'ed).
> Some of you have already been subscribed. If you want to subscribe or
> unsubscribe please visit the link[0] below:
> 
>   [0] https://lists.xdp-project.net/postorius/lists/xdp-hints.xdp-project.net/
> 
> Remember we prefer to keep the upstream discussion on bpf@vger.kernel.org.
> This list should be Cc'ed for topics related to XDP-hints.

I'm not sure why exactly you need an extra topic mailing list ?? Just keep
the existing discussions upstream with netdev + bpf + cc'ed folks in the loop
to avoid divergence and reiterating over topics yet again (given discussed
in one place but not the other, for example).. much simpler.

Thanks,
Daniel
