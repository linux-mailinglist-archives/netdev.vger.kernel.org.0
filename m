Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF942042A5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgFVV1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:27:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:42142 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbgFVV1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 17:27:05 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnTy2-0005QG-Nh; Mon, 22 Jun 2020 23:27:02 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnTy2-000PVx-FX; Mon, 22 Jun 2020 23:27:02 +0200
Subject: Re: [PATCH bpf] libbpf: forward-declare bpf_stats_type for systems
 with outdated UAPI headers
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200621031159.2279101-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <85bd6a92-5230-6b7b-a3de-d166e80913f4@iogearbox.net>
Date:   Mon, 22 Jun 2020 23:27:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200621031159.2279101-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25851/Mon Jun 22 15:09:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/20 5:11 AM, Andrii Nakryiko wrote:
> Systems that doesn't yet have the very latest linux/bpf.h header, enum
> bpf_stats_type will be undefined, causing compilation warnings. Prevents this
> by forward-declaring enum.
> 
> Fixes: 0bee106716cf ("libbpf: Add support for command BPF_ENABLE_STATS")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
