Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC41C2181D
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 14:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfEQMYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 08:24:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:47326 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfEQMYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 08:24:03 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hRbu5-0005y4-9Q; Fri, 17 May 2019 14:24:01 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hRbu5-0008FK-4E; Fri, 17 May 2019 14:24:01 +0200
Subject: Re: [PATCH bpf] bpftool: fix BTF raw dump of FWD's fwd_kind
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com
References: <20190517062129.2786346-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a95b5de4-c8eb-715f-2557-1861561deb8e@iogearbox.net>
Date:   Fri, 17 May 2019 14:24:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190517062129.2786346-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25452/Fri May 17 09:57:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/17/2019 08:21 AM, Andrii Nakryiko wrote:
> kflag bit determines whether FWD is for struct or union. Use that bit.
> 
> Fixes: c93cc69004df ("bpftool: add ability to dump BTF types")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
