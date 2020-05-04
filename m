Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014921C48B2
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 23:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEDVBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 17:01:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:60414 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDVBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 17:01:31 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jViDO-0000u2-JM; Mon, 04 May 2020 23:01:26 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jViDO-000Nmt-7F; Mon, 04 May 2020 23:01:26 +0200
Subject: Re: [PATCH bpf-next 0/2] xsk: improve code readability
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com
References: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c11bbedc-aa94-c41e-5b62-202f75ae2bf1@iogearbox.net>
Date:   Mon, 4 May 2020 23:01:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25802/Mon May  4 14:12:31 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/20 3:33 PM, Magnus Karlsson wrote:
> This small series improves xsk code readibility by renaming two
> variables in the first patch and removing one struct member that there
> is no reason to keep around in the second patch. Basically small
> things that were found in other series but not fixed there for one or
> the other reason.
> 
> Thanks: Magnus
> 
> Magnus Karlsson (2):
>    xsk: change two variable names for increased clarity
>    xsk: remove unnecessary member in xdp_umem
> 
>   include/net/xdp_sock.h |  5 ++---
>   net/xdp/xdp_umem.c     | 21 ++++++++++-----------
>   net/xdp/xsk.c          |  8 ++++----
>   net/xdp/xsk_queue.c    |  4 ++--
>   net/xdp/xsk_queue.h    |  8 ++++----
>   5 files changed, 22 insertions(+), 24 deletions(-)
> 
> --
> 2.7.4
> 

Applied, thanks!
