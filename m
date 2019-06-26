Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B574356C0C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfFZOcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:32:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:44744 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZOcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:32:35 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8yO-0000aN-Hy; Wed, 26 Jun 2019 16:32:32 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8yO-000Cfe-AU; Wed, 26 Jun 2019 16:32:32 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: build tests with debug info
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        ast@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20190625225628.3129845-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <38929bf8-6d79-93d0-191f-82777ad75880@iogearbox.net>
Date:   Wed, 26 Jun 2019 16:32:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190625225628.3129845-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/26/2019 12:56 AM, Andrii Nakryiko wrote:
> Non-BPF (user land) part of selftests is built without debug info making
> occasional debugging with gdb terrible. Build with debug info always.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
