Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310A470239
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbfGVOX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:23:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:40176 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbfGVOXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 10:23:25 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hpZDl-0001AN-2k; Mon, 22 Jul 2019 16:23:21 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hpZDk-0008dF-R6; Mon, 22 Jul 2019 16:23:20 +0200
Subject: Re: [GIT PULL 0/2] libbpf build fixes
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
References: <20190719143407.20847-1-acme@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d2828163-2743-b4a6-84a8-dc2431e7b4ca@iogearbox.net>
Date:   Mon, 22 Jul 2019 16:23:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190719143407.20847-1-acme@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25518/Mon Jul 22 10:12:39 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/19 4:34 PM, Arnaldo Carvalho de Melo wrote:
> Hi Daniel,
> 
> 	Please consider pulling or applying from the patches, if someone
> has any issues, please holler,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   libbpf: Fix endianness macro usage for some compilers
>   libbpf: Avoid designated initializers for unnamed union members
> 
>  tools/lib/bpf/btf.c    |  5 +++--
>  tools/lib/bpf/libbpf.c | 19 ++++++++++---------
>  2 files changed, 13 insertions(+), 11 deletions(-)
> 

Applied, thanks!
