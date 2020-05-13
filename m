Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A671D180F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbgEMO5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:57:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:49148 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389058AbgEMO5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:57:19 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYson-0002dc-Ir; Wed, 13 May 2020 16:57:09 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYson-0002vB-7v; Wed, 13 May 2020 16:57:09 +0200
Subject: Re: [PATCH bpf-next v4] libbpf: fix probe code to return EPERM if
 encountered
To:     Eelco Chaudron <echaudro@redhat.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        toke@redhat.com
References: <158927424896.2342.10402475603585742943.stgit@ebuild>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1c706733-47cb-0216-e8a6-214979af7494@iogearbox.net>
Date:   Wed, 13 May 2020 16:57:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158927424896.2342.10402475603585742943.stgit@ebuild>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/20 11:04 AM, Eelco Chaudron wrote:
> When the probe code was failing for any reason ENOTSUP was returned, even
> if this was due to no having enough lock space. This patch fixes this by
> returning EPERM to the user application, so it can respond and increase
> the RLIMIT_MEMLOCK size.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Applied, thanks!
