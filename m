Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B446A6ABD
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 16:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfICOFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 10:05:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:51478 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICOFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 10:05:08 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i59Qf-0004U9-TM; Tue, 03 Sep 2019 16:05:05 +0200
Received: from [178.197.249.19] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i59Qf-000CjB-Mh; Tue, 03 Sep 2019 16:05:05 +0200
Subject: Re: [PATCH bpf-next] arm64: bpf: optimize modulo operation
To:     jerinj@marvell.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:BPF JIT for ARM64" <bpf@vger.kernel.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190902061448.28252-1-jerinj@marvell.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4da4bb59-5578-6981-55b7-5dbc4f0a8254@iogearbox.net>
Date:   Tue, 3 Sep 2019 16:05:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190902061448.28252-1-jerinj@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25561/Tue Sep  3 10:24:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/19 8:14 AM, jerinj@marvell.com wrote:
> From: Jerin Jacob <jerinj@marvell.com>
> 
> Optimize modulo operation instruction generation by
> using single MSUB instruction vs MUL followed by SUB
> instruction scheme.
> 
> Signed-off-by: Jerin Jacob <jerinj@marvell.com>

Applied, thanks!
