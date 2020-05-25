Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23ED31E17DF
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgEYWVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:21:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:52114 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYWVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:21:23 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLTF-0002aE-Kf; Tue, 26 May 2020 00:21:21 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLTE-000Evx-Qr; Tue, 26 May 2020 00:21:21 +0200
Subject: Re: [PATCH bpf-next] bpf: Fix returned error sign when link doesn't
 support updates
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
References: <20200525122928.1164495-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <69310286-415e-d167-4c73-84b04abd243b@iogearbox.net>
Date:   Tue, 26 May 2020 00:21:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200525122928.1164495-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25823/Mon May 25 14:23:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/20 2:29 PM, Jakub Sitnicki wrote:
> System calls encode returned errors as negative values. Fix a typo that
> breaks this convention for bpf(LINK_UPDATE) when bpf_link doesn't support
> update operation.
> 
> Fixes: f9d041271cf4 ("bpf: Refactor bpf_link update handling")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied, thanks!
