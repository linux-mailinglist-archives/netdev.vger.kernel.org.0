Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA57899A8
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfHLJTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:19:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:39806 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfHLJTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:19:17 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hx6Tw-0003TY-V0; Mon, 12 Aug 2019 11:19:13 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hx6Tw-00047g-Lf; Mon, 12 Aug 2019 11:19:12 +0200
Subject: Re: [PATCH v3] tools: bpftool: fix reading from /proc/config.gz
To:     Peter Wu <peter@lekensteyn.nl>, Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <20190809003911.7852-1-peter@lekensteyn.nl>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6154af6c-4f24-4b0a-25c2-a8a1d6c9948f@iogearbox.net>
Date:   Mon, 12 Aug 2019 11:19:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190809003911.7852-1-peter@lekensteyn.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25539/Mon Aug 12 10:15:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 2:39 AM, Peter Wu wrote:
> /proc/config has never existed as far as I can see, but /proc/config.gz
> is present on Arch Linux. Add support for decompressing config.gz using
> zlib which is a mandatory dependency of libelf. Replace existing stdio
> functions with gzFile operations since the latter transparently handles
> uncompressed and gzip-compressed files.
> 
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>

Applied, thanks. Please follow-up with a zlib feature test as suggested
by Jakub.
