Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDA2147E88
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 11:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389018AbgAXKMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 05:12:00 -0500
Received: from www62.your-server.de ([213.133.104.62]:52812 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387509AbgAXKMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 05:12:00 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvwT-0000zJ-ST; Fri, 24 Jan 2020 11:11:57 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvwT-000Y4Q-En; Fri, 24 Jan 2020 11:11:57 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: improve bpftool changes detection
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200124054148.2455060-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ea78ea54-3f6a-d3fc-9fda-bb2eda74c82d@iogearbox.net>
Date:   Fri, 24 Jan 2020 11:11:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200124054148.2455060-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 6:41 AM, Andrii Nakryiko wrote:
> Detect when bpftool source code changes and trigger rebuild within
> selftests/bpf Makefile. Also fix few small formatting problems.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
