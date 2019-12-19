Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682D7126656
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLSQBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:01:40 -0500
Received: from www62.your-server.de ([213.133.104.62]:53080 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfLSQBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:01:40 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihyF8-0001Zw-E2; Thu, 19 Dec 2019 17:01:38 +0100
Date:   Thu, 19 Dec 2019 17:01:38 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH bpf-next v2] libbpf: Fix printing of ulimit value
Message-ID: <20191219160138.GB8564@linux-9.fritz.box>
References: <20191219090236.905059-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191219090236.905059-1-toke@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:02:36AM +0100, Toke Høiland-Jørgensen wrote:
> Naresh pointed out that libbpf builds fail on 32-bit architectures because
> rlimit.rlim_cur is defined as 'unsigned long long' on those architectures.
> Fix this by using %zu in printf and casting to size_t.
> 
> Fixes: dc3a2d254782 ("libbpf: Print hint about ulimit when getting permission denied error")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!
