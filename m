Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3F41BB06F
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD0VW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:22:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:47816 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgD0VW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:22:56 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBDF-00027r-8l; Mon, 27 Apr 2020 23:22:49 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBDE-000NWy-RJ; Mon, 27 Apr 2020 23:22:48 +0200
Subject: Re: [PATCH bpf-next v3 2/2] libbpf: Return err if bpf_object__load
 failed
To:     Mao Wenan <maowenan@huawei.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        andrii.nakryiko@gmail.com, dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200426063635.130680-1-maowenan@huawei.com>
 <20200426063635.130680-3-maowenan@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5c730cda-8177-3049-51c5-65e2f22958c5@iogearbox.net>
Date:   Mon, 27 Apr 2020 23:22:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200426063635.130680-3-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25795/Mon Apr 27 14:00:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 8:36 AM, Mao Wenan wrote:
> bpf_object__load() has various return code, when it failed to load
> object, it must return err instead of -EINVAL.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
