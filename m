Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878AF1E3117
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404312AbgEZVWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:22:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:45790 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404259AbgEZVWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:22:49 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdh25-0000rC-8k; Tue, 26 May 2020 23:22:45 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdh24-000BXR-SM; Tue, 26 May 2020 23:22:44 +0200
Subject: Re: [PATCH] bpf: Fix spelling in comment
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200525230025.14470-1-chris.packham@alliedtelesis.co.nz>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dbf7bcb8-5c4d-b8e9-6c7d-1238bd49b133@iogearbox.net>
Date:   Tue, 26 May 2020 23:22:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200525230025.14470-1-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25824/Tue May 26 14:27:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 1:00 AM, Chris Packham wrote:
> Change 'handeled' to 'handled'.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Applied, thanks!
