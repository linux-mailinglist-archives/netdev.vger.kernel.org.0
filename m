Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7AF810BE10
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 22:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfK0Vdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 16:33:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:32904 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731075AbfK0Vdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 16:33:32 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ia4wE-000315-Es; Wed, 27 Nov 2019 22:33:30 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ia4wE-000Nw4-57; Wed, 27 Nov 2019 22:33:30 +0100
Subject: Re: [PATCH bpf] libbpf: fix Makefile' libbpf symbol mismatch
 diagnostic
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, yhs@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191127200134.1360660-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <653b6ca5-fc67-4203-e668-3495b2eacedb@iogearbox.net>
Date:   Wed, 27 Nov 2019 22:33:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191127200134.1360660-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25646/Wed Nov 27 11:06:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/19 9:01 PM, Andrii Nakryiko wrote:
> Fix Makefile's diagnostic diff output when there is LIBBPF_API-versioned
> symbols mismatch.
> 
> Fixes: 1bd63524593b ("libbpf: handle symbol versioning properly for libbpf.a")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
