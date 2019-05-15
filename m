Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB971FD7E
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 03:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfEPBqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 21:46:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:58128 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfEOXm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 19:42:56 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hR3Xy-0002tc-0x; Thu, 16 May 2019 01:42:54 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hR3Xx-00072w-RP; Thu, 16 May 2019 01:42:53 +0200
Subject: Re: [bpf PATCH] net: tcp_bpf, correctly handle DONT_WAIT flags and
 timeo == 0
To:     John Fastabend <john.fastabend@gmail.com>, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <155780892372.10726.16677541867391282805.stgit@john-XPS-13-9360>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e3c7810a-0a54-2f9b-707d-b87ff5080904@iogearbox.net>
Date:   Thu, 16 May 2019 01:42:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <155780892372.10726.16677541867391282805.stgit@john-XPS-13-9360>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25450/Wed May 15 09:59:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/14/2019 06:42 AM, John Fastabend wrote:
> The tcp_bpf_wait_data() routine needs to check timeo != 0 before
> calling sk_wait_event() otherwise we may see unexpected stalls
> on receiver.
> 
> Arika did all the leg work here I just formaatted, posted and ran
> a few tests.
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Reported-by: Arika Chen <eaglesora@gmail.com>
> Suggested-by: Arika Chen <eaglesora@gmail.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied, thanks!
