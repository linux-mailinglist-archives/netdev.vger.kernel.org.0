Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0612075A0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390181AbgFXOXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:23:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:38098 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388115AbgFXOXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 10:23:48 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jo6JW-0004lJ-NW; Wed, 24 Jun 2020 16:23:47 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jo6JW-000El6-FM; Wed, 24 Jun 2020 16:23:46 +0200
Subject: Re: [PATCH bpf-next] libbpf: prevent loading vmlinux BTF twice
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200624043805.1794620-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a4174b65-dbc5-d3c7-4a5e-e77b08fab26e@iogearbox.net>
Date:   Wed, 24 Jun 2020 16:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200624043805.1794620-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25853/Wed Jun 24 15:13:27 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/20 6:38 AM, Andrii Nakryiko wrote:
> Prevent loading/parsing vmlinux BTF twice in some cases: for CO-RE relocations
> and for BTF-aware hooks (tp_btf, fentry/fexit, etc).
> 
> Fixes: a6ed02cac690 ("libbpf: Load btf_vmlinux only once per object.")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Lgtm, applied, thanks!
