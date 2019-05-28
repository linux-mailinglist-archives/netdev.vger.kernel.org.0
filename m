Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94572C334
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfE1J2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:28:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:38636 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfE1J2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:28:50 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYPZ-00086u-0v; Tue, 28 May 2019 11:28:49 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYPY-000Ahn-QJ; Tue, 28 May 2019 11:28:48 +0200
Subject: Re: [PATCH v2] samples: bpf: fix style in bpf_load
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20190523072448.25269-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <23b51aa3-9505-4106-3361-c10559f00476@iogearbox.net>
Date:   Tue, 28 May 2019 11:28:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190523072448.25269-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25463/Tue May 28 09:57:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/23/2019 09:24 AM, Daniel T. Lee wrote:
> This commit fixes style problem in samples/bpf/bpf_load.c
> 
> Styles that have been changed are:
>  - Magic string use of 'DEBUGFS'
>  - Useless zero initialization of a global variable
>  - Minor style fix with whitespace
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Applied, thanks!
