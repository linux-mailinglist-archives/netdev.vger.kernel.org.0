Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3C75E1F7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfGCKVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:21:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:57438 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGCKVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 06:21:42 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hicOS-0001bO-S4; Wed, 03 Jul 2019 12:21:40 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hicOS-000EWU-N1; Wed, 03 Jul 2019 12:21:40 +0200
Subject: Re: [PATCH v2 bpf-next] libbpf: fix GCC8 warning for strncpy
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        magnus.karlsson@intel.com
References: <20190702151620.3382559-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <148618ec-f1f6-94e1-6e52-2a831d99302d@iogearbox.net>
Date:   Wed, 3 Jul 2019 12:21:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190702151620.3382559-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 05:16 PM, Andrii Nakryiko wrote:
> GCC8 started emitting warning about using strncpy with number of bytes
> exactly equal destination size, which is generally unsafe, as can lead
> to non-zero terminated string being copied. Use IFNAMSIZ - 1 as number
> of bytes to ensure name is always zero-terminated.
> 
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
