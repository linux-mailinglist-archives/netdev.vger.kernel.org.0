Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B1923F199
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgHGRCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:02:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:42212 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHGRCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:02:07 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k45ki-0005qO-RL; Fri, 07 Aug 2020 19:01:56 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k45ki-000S11-H3; Fri, 07 Aug 2020 19:01:56 +0200
Subject: Re: [PATCH bpf] bpf: doc: remove references to warning message when
 using bpf_trace_printk()
To:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1596801029-32395-1-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <007a231f-6352-9784-bce1-417d6572b423@iogearbox.net>
Date:   Fri, 7 Aug 2020 19:01:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1596801029-32395-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25897/Fri Aug  7 14:45:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/20 1:50 PM, Alan Maguire wrote:
> The BPF helper bpf_trace_printk() no longer uses trace_printk();
> it is now triggers a dedicated trace event.  Hence the described
> warning is no longer present, so remove the discussion of it as
> it may confuse people.
> 
> Fixes: ac5a72ea5c89 ("bpf: Use dedicated bpf_trace_printk event instead of trace_printk()")
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>

Applied, thanks!
