Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A17C8BB68
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbfHMOYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:24:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:48794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbfHMOYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:24:21 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxXii-0005Zr-LU; Tue, 13 Aug 2019 16:24:16 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxXii-000M2R-CM; Tue, 13 Aug 2019 16:24:16 +0200
Subject: Re: [PATCH] tools: bpftool: add feature check for zlib
To:     Peter Wu <peter@lekensteyn.nl>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <20190813003833.22042-1-peter@lekensteyn.nl>
 <20190813003833.22042-2-peter@lekensteyn.nl>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <396943ae-e99e-d544-bcbb-50cc89dd55ec@iogearbox.net>
Date:   Tue, 13 Aug 2019 16:24:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190813003833.22042-2-peter@lekensteyn.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25540/Tue Aug 13 10:16:47 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 2:38 AM, Peter Wu wrote:
> bpftool requires libelf, and zlib for decompressing /proc/config.gz.
> zlib is a transitive dependency via libelf, and became mandatory since
> elfutils 0.165 (Jan 2016). The feature check of libelf is already done
> in the elfdep target of tools/lib/bpf/Makefile, pulled in by bpftool via
> a dependency on libbpf.a. Add a similar feature check for zlib.
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>

Applied, thanks!
