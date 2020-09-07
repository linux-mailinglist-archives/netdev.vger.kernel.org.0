Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22A825FE0F
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgIGOjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:39:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:58764 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729962AbgIGOgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:36:03 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFIFO-0000qP-24; Mon, 07 Sep 2020 16:35:54 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFIFN-000SvE-T0; Mon, 07 Sep 2020 16:35:53 +0200
Subject: Re: [PATCH bpf-next 0/3] bpf: format fixes for BPF helpers and
 bpftool documentation
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200904161454.31135-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dd993cfa-7e03-81d4-1d3c-ab55c7943f8c@iogearbox.net>
Date:   Mon, 7 Sep 2020 16:35:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200904161454.31135-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25922/Sun Sep  6 15:39:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 6:14 PM, Quentin Monnet wrote:
> This series contains minor fixes (or harmonisation edits) for the
> bpftool-link documentation (first patch) and BPF helpers documentation
> (last two patches), so that all related man pages can build without errors.
> 
> Quentin Monnet (3):
>    tools: bpftool: fix formatting in bpftool-link documentation
>    bpf: fix formatting in documentation for BPF helpers
>    tools, bpf: synchronise BPF UAPI header with tools
> 
>   include/uapi/linux/bpf.h                      | 87 ++++++++++---------
>   .../bpftool/Documentation/bpftool-link.rst    |  2 +-
>   tools/include/uapi/linux/bpf.h                | 87 ++++++++++---------
>   3 files changed, 91 insertions(+), 85 deletions(-)
> 

Applied, thanks!
