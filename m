Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D803124AA
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 15:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBGOYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 09:24:54 -0500
Received: from novek.ru ([213.148.174.62]:39192 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhBGOYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 09:24:46 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C756B500ACF;
        Sun,  7 Feb 2021 17:23:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C756B500ACF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612707811; bh=9obz1s26oshiRnXru45x6dN4KP1BWv2+QBJm3ARKzNs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ub+ZxPFqiRftXK/pEdXqcfY14Vo0IS5sXSsIJFLjvDC+KsTIIqkG9TBNlfEOYLvLJ
         x56wwEHDlB1XJ4hOUIxgj24N1kYGWgv5/4cNsEwjLiAZOZLbYjwOlb3tXLhf9qMDiF
         Tpn/+5HsxJYLi3XVV2f1jfLm21P2g87vioGo8+aU=
Subject: Re: [PATCH net-next] rxrpc: use udp tunnel APIs instead of open code
 in rxrpc_open_socket
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>
References: <33e11905352da3b65354622dcd2f7d2c3c00c645.1612686194.git.lucien.xin@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <d85e5bc1-8e74-321d-e727-f669a55da90f@novek.ru>
Date:   Sun, 7 Feb 2021 14:23:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <33e11905352da3b65354622dcd2f7d2c3c00c645.1612686194.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.02.2021 08:23, Xin Long wrote:
> In rxrpc_open_socket(), now it's using sock_create_kern() and
> kernel_bind() to create a udp tunnel socket, and other kernel
> APIs to set up it. These code can be replaced with udp tunnel
> APIs udp_sock_create() and setup_udp_tunnel_sock(), and it'll
> simplify rxrpc_open_socket().
> 
> Note that with this patch, the udp tunnel socket will always
> bind to a random port if transport is not provided by users,
> which is suggested by David Howells, thanks!
> 
> Acked-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Looks good to me.

Reviewed-by: Vadim Fedorenko <vfedorenko@novek.ru>
