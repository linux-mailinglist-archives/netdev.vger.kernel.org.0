Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDF620F6E6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388816AbgF3OMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:12:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:47112 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbgF3OMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:12:05 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqGzT-0000ul-1t; Tue, 30 Jun 2020 16:12:03 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqGzS-0002BZ-Rn; Tue, 30 Jun 2020 16:12:02 +0200
Subject: Re: [PATCH bpf-next 1/2] tools/bpftool: allow substituting custom
 vmlinux.h for the build
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200630004759.521530-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <74b531fe-d55c-7698-4a13-8119793c5edc@iogearbox.net>
Date:   Tue, 30 Jun 2020 16:12:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200630004759.521530-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25858/Mon Jun 29 15:30:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 2:47 AM, Andrii Nakryiko wrote:
> In some build contexts (e.g., Travis CI build for outdated kernel), vmlinux.h,
> generated from available kernel, doesn't contain all the types necessary for
> BPF program compilation. For such set up, the most maintainable way to deal
> with this problem is to keep pre-generated (almost up-to-date) vmlinux.h
> checked in and use it for compilation purposes. bpftool after that can deal
> with kernel missing some of the features in runtime with no problems.
> 
> To that effect, allow to specify path to custom vmlinux.h to bpftool's
> Makefile with VMLINUX_H variable.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Both applied, thanks!
