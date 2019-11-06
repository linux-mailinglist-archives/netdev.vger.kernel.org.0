Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3CFF227C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfKFXX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:23:27 -0500
Received: from www62.your-server.de ([213.133.104.62]:38674 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbfKFXX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:23:27 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSUdz-0002JK-BT; Thu, 07 Nov 2019 00:23:19 +0100
Received: from [178.197.248.39] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSUdz-0000Pl-0J; Thu, 07 Nov 2019 00:23:19 +0100
Subject: Re: [PATCH bpf] bpf: offload: unlock on error in
 bpf_offload_dev_create()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20191104091536.GB31509@mwanda>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7c831580-49e5-6582-16df-86e70bad242e@iogearbox.net>
Date:   Thu, 7 Nov 2019 00:23:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191104091536.GB31509@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25625/Wed Nov  6 10:44:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 10:15 AM, Dan Carpenter wrote:
> We need to drop the bpf_devs_lock on error before returning.
> 
> Fixes: 9fd7c5559165 ("bpf: offload: aggregate offloads per-device")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!
