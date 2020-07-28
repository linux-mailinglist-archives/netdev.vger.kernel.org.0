Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843E6231585
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgG1W2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:28:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:44934 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgG1W2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 18:28:23 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Y55-0002v1-Oe; Wed, 29 Jul 2020 00:28:19 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Y55-0005Z3-0I; Wed, 29 Jul 2020 00:28:19 +0200
Subject: Re: [bpf-next PATCH] bpf, selftests: use ::1 for localhost in
 tcp_server.py
To:     John Fastabend <john.fastabend@gmail.com>, guro@fb.com,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <159594714197.21431.10113693935099326445.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fbbbe3df-23fc-5cc7-5761-f891bda6777d@iogearbox.net>
Date:   Wed, 29 Jul 2020 00:28:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159594714197.21431.10113693935099326445.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25887/Tue Jul 28 17:44:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/20 4:39 PM, John Fastabend wrote:
> Using localhost requires the host to have a /etc/hosts file with that
> specific line in it. By default my dev box did not, they used
> ip6-localhost, so the test was failing. To fix remove the need for any
> /etc/hosts and use ::1.
> 
> I could just add the line, but this seems easier.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied, thanks!
