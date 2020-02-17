Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8936D1616D2
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgBQP5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:57:00 -0500
Received: from www62.your-server.de ([213.133.104.62]:34936 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbgBQP5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:57:00 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j3ilW-0000Lh-28; Mon, 17 Feb 2020 16:56:58 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j3ilV-000JSw-PJ; Mon, 17 Feb 2020 16:56:57 +0100
Subject: Re: [PATCH] bpf_prog_offload_info_fill: replace bitwise AND by
 logical AND
To:     Johannes Krude <johannes@krude.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        trivial@kernel.org
References: <20200212193227.GA3769@phlox.h.transitiv.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5456d0d1-487d-1019-3083-397803b23888@iogearbox.net>
Date:   Mon, 17 Feb 2020 16:56:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200212193227.GA3769@phlox.h.transitiv.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25726/Mon Feb 17 15:01:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/20 8:32 PM, Johannes Krude wrote:
> This if guards whether user-space wants a copy of the offload-jited
> bytecode and whether this bytecode exists. By erroneously doing a bitwise
> AND instead of a logical AND on user- and kernel-space buffer-size can lead
> to no data being copied to user-space especially when user-space size is a
> power of two and bigger then the kernel-space buffer.
> 
> Signed-off-by: Johannes Krude <johannes@krude.de>

Applied, thanks!
