Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC48232850
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgG2Xob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:44:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:34748 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgG2Xob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:44:31 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0vkM-00022P-61; Thu, 30 Jul 2020 01:44:30 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0vkL-0005T7-V6; Thu, 30 Jul 2020 01:44:30 +0200
Subject: Re: [PATCH v4 bpf 1/2] bpf: fix map leak in HASH_OF_MAPS map
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Song Liu <songliubraving@fb.com>, stable@vger.kernel.org
References: <20200729040913.2815687-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e54bb61c-e66a-d506-28ee-1193d2d583c8@iogearbox.net>
Date:   Thu, 30 Jul 2020 01:44:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200729040913.2815687-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25888/Wed Jul 29 16:57:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 6:09 AM, Andrii Nakryiko wrote:
> Fix HASH_OF_MAPS bug of not putting inner map pointer on bpf_map_elem_update()
> operation. This is due to per-cpu extra_elems optimization, which bypassed
> free_htab_elem() logic doing proper clean ups. Make sure that inner map is put
> properly in optimized case as well.
> 
> Fixes: 8c290e60fa2a ("bpf: fix hashmap extra_elems logic")
> Acked-by: Song Liu <songliubraving@fb.com>
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Both applied, thanks!
