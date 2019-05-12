Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5968C1AE65
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 01:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfELXX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 19:23:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:59530 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfELXX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 19:23:58 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPxov-0003z0-Da; Mon, 13 May 2019 01:23:53 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPxov-000Vwp-7G; Mon, 13 May 2019 01:23:53 +0200
Subject: Re: [PATCH v2] selftests: bpf: Add files generated after build to
 .gitignore
To:     Kelsey Skunberg <skunberg.kelsey@gmail.com>, shuah@kernel.org,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20190512072918.10736-1-skunberg.kelsey@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d6097853-70e1-b42c-b332-c08da6942efb@iogearbox.net>
Date:   Mon, 13 May 2019 01:23:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190512072918.10736-1-skunberg.kelsey@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25447/Sun May 12 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2019 09:29 AM, Kelsey Skunberg wrote:
> The following files are generated after building /selftests/bpf/ and
> should be added to .gitignore:
> 
> 	- libbpf.pc
> 	- libbpf.so.*
> 
> Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>

Applied, thanks.
