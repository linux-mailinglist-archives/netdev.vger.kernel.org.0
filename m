Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65E188D7E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCQS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:56:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:59606 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQS4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:56:01 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHNe-0001sX-Mf; Tue, 17 Mar 2020 19:55:58 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHNe-0002FB-E4; Tue, 17 Mar 2020 19:55:58 +0100
Subject: Re: [PATCH v2 bpf-next] selftest/bpf: fix compilation warning in
 sockmap_parse_prog.c
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200314001834.3727680-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cea39831-83df-08cd-45b7-1fb7f7131e05@iogearbox.net>
Date:   Tue, 17 Mar 2020 19:55:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200314001834.3727680-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/20 1:18 AM, Andrii Nakryiko wrote:
> Remove unused len variable, which causes compilation warnings.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
