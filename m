Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70921510B4
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbfFXPhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:37:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:47362 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbfFXPhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:37:19 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfQRc-00053w-U9; Mon, 24 Jun 2019 16:59:44 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfQRc-000QfP-Ni; Mon, 24 Jun 2019 16:59:44 +0200
Subject: Re: [PATCH][next] libbpf: fix spelling mistake "conflictling" ->
 "conflicting"
To:     Colin King <colin.king@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190619162742.985-1-colin.king@canonical.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fb192b66-9fa9-b1ac-cc11-d621865e83b3@iogearbox.net>
Date:   Mon, 24 Jun 2019 16:59:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190619162742.985-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25490/Mon Jun 24 10:02:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/19/2019 06:27 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are several spelling mistakes in pr_warning messages. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks!
