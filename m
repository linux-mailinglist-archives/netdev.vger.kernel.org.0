Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E71702BF
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgBZPjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:39:02 -0500
Received: from www62.your-server.de ([213.133.104.62]:40838 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgBZPjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:39:02 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6ym1-00012b-GY; Wed, 26 Feb 2020 16:38:57 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6ym1-000JAe-4A; Wed, 26 Feb 2020 16:38:57 +0100
Subject: Re: [PATCH] scripts/bpf: switch to more portable python3 shebang
To:     Scott Branden <scott.branden@broadcom.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
References: <20200225205426.6975-1-scott.branden@broadcom.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e46b5fc2-dc2c-ddcd-8483-2c03f8f09a23@iogearbox.net>
Date:   Wed, 26 Feb 2020 16:38:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200225205426.6975-1-scott.branden@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 9:54 PM, Scott Branden wrote:
> Change "/usr/bin/python3" to "/usr/bin/env python3" for
> more portable solution in bpf_helpers_doc.py.
> 
> Signed-off-by: Scott Branden <scott.branden@broadcom.com>

Applied, thanks!
