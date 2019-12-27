Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8F912B9D0
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfL0SJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:09:32 -0500
Received: from www62.your-server.de ([213.133.104.62]:58708 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfL0SJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 13:09:32 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iku3G-0002gE-28; Fri, 27 Dec 2019 19:09:30 +0100
Received: from [185.105.41.29] (helo=linux-9.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iku3F-000Ai7-OU; Fri, 27 Dec 2019 19:09:29 +0100
Subject: Re: [PATCH bpf-next] bpftool: make skeleton C code compilable with
 C++ compiler
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191226210253.3132060-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <17f26786-3e41-157f-8586-c1a8f5218925@iogearbox.net>
Date:   Fri, 27 Dec 2019 19:09:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191226210253.3132060-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25676/Fri Dec 27 11:04:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/26/19 10:02 PM, Andrii Nakryiko wrote:
> When auto-generated BPF skeleton C code is included from C++ application, it
> triggers compilation error due to void * being implicitly casted to whatever
> target pointer type. This is supported by C, but not C++. To solve this
> problem, add explicit casts, where necessary.
> 
> To ensure issues like this are captured going forward, add skeleton usage in
> test_cpp test.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied it earlier today, thanks!
