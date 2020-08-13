Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44AD2440C5
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHMVgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 17:36:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:47086 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgHMVgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 17:36:21 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k6KtU-0007dv-3b; Thu, 13 Aug 2020 23:36:16 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k6KtT-0002h9-UF; Thu, 13 Aug 2020 23:36:15 +0200
Subject: Re: [bpf PATCH v3 0/5] Fix sock_ops field read splat
To:     John Fastabend <john.fastabend@gmail.com>, songliubraving@fb.com,
        kafai@fb.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c55c79df-5c80-1cb4-3f8f-a1ab8d5135a5@iogearbox.net>
Date:   Thu, 13 Aug 2020 23:36:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25901/Thu Aug 13 09:01:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/20 12:04 AM, John Fastabend wrote:
[...]
> v2->v3: Updated commit msg in patch1 to include ommited line of asm
>          output, per Daniels comment.
> v1->v2: Added fix sk access case

Applied, thanks!
