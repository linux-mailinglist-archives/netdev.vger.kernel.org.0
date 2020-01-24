Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AC7147E8B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 11:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388122AbgAXKM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 05:12:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:52978 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729509AbgAXKM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 05:12:27 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvww-00013K-1v; Fri, 24 Jan 2020 11:12:26 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvwv-0003KN-Q0; Fri, 24 Jan 2020 11:12:25 +0100
Subject: Re: [PATCH bpf-next] bpftool: print function linkage in BTF dump
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200124054317.2459436-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a9526f65-4173-6771-ed60-f0887db40343@iogearbox.net>
Date:   Fri, 24 Jan 2020 11:12:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200124054317.2459436-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 6:43 AM, Andrii Nakryiko wrote:
> Add printing out BTF_KIND_FUNC's linkage.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
