Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653A915ADAE
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBLQuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:50:35 -0500
Received: from www62.your-server.de ([213.133.104.62]:40574 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLQue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 11:50:34 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1vDY-0003nr-OV; Wed, 12 Feb 2020 17:50:28 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1vDY-000FFG-GA; Wed, 12 Feb 2020 17:50:28 +0100
Subject: Re: [PATCH bpf] bpf: selftests: Fix error checking on reading the
 tcp_fastopen sysctl
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200211175910.3235321-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f092bb3b-aad4-1685-7b69-b669fae51471@iogearbox.net>
Date:   Wed, 12 Feb 2020 17:50:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200211175910.3235321-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25721/Wed Feb 12 06:24:38 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/20 6:59 PM, Martin KaFai Lau wrote:
> There is a typo in checking the "saved_tcp_fo" and instead
> "saved_tcp_syncookie" is checked again.  This patch fixes it
> and also breaks them into separate if statements such that
> the test will abort asap.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
