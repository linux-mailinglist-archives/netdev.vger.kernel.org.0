Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F0618D8D5
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCTUHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:07:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:39388 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTUHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:07:50 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFNvm-0006X1-NO; Fri, 20 Mar 2020 21:07:46 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFNvm-000BST-9W; Fri, 20 Mar 2020 21:07:46 +0100
Subject: Re: [PATCH] bpf: explicitly memset some bpf info structures declared
 on the stack
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
References: <20200320094813.GA421650@kroah.com>
 <3bcf52da-0930-a27f-60f9-28a40e639949@iogearbox.net>
 <20200320154518.GA765793@kroah.com>
 <d55983b3-0f94-cc7f-2055-a0b4ab8075ed@iogearbox.net>
 <20200320161515.GA778529@kroah.com> <20200320162258.GA794295@kroah.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f413a861-32cc-9ca7-f780-4c208ec34ffc@iogearbox.net>
Date:   Fri, 20 Mar 2020 21:07:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200320162258.GA794295@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25757/Fri Mar 20 14:13:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 5:22 PM, Greg Kroah-Hartman wrote:
> Trying to initialize a structure with "= {};" will not always clean out
> all padding locations in a structure.  So be explicit and call memset to
> initialize everything for a number of bpf information structures that
> are then copied from userspace, sometimes from smaller memory locations
> than the size of the structure.
> 
> Reported-by: Daniel Borkmann <daniel@iogearbox.net
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied, thanks!
