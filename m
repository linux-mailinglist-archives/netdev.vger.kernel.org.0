Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4048EC1D69
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfI3IuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:50:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:57504 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfI3IuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:50:07 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iErNc-00007s-TU; Mon, 30 Sep 2019 10:50:05 +0200
Date:   Mon, 30 Sep 2019 10:50:04 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Stephen Kitt <steve@sk2.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] bpf: use flexible array members, not zero-length
Message-ID: <20190930085004.GA1698@pc-66.home>
References: <20190928144814.27002-1-steve@sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190928144814.27002-1-steve@sk2.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25587/Sun Sep 29 10:25:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 28, 2019 at 04:48:14PM +0200, Stephen Kitt wrote:
> This switches zero-length arrays in variable-length structs to C99
> flexible array members. GCC will then ensure that the arrays are
> always the last element in the struct.
> 
> Coccinelle:
> @@
> identifier S, fld;
> type T;
> @@
> 
> struct S {
>   ...
> - T fld[0];
> + T fld[];
>   ...
> };

You did not explain the "why is it needed" part, only what your
change is doing. What [compilation?] issue are you seeing that
you're trying to fix? This sort of information must be present
in a changelog.

> Signed-off-by: Stephen Kitt <steve@sk2.org>

Thanks,
Daniel
