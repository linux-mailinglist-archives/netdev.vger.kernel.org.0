Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE5B7972
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbfISMbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:31:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:59940 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfISMbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:31:23 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iAvai-0000Eh-4U; Thu, 19 Sep 2019 14:31:20 +0200
Date:   Thu, 19 Sep 2019 14:31:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf v2] libbpf: Remove getsockopt() check for XDP_OPTIONS
Message-ID: <20190919123119.GA5504@pc-63.home>
References: <20190916123342.49928-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190916123342.49928-1-toke@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25577/Thu Sep 19 10:20:13 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 02:33:42PM +0200, Toke Høiland-Jørgensen wrote:
> The xsk_socket__create() function fails and returns an error if it cannot
> get the XDP_OPTIONS through getsockopt(). However, support for XDP_OPTIONS
> was not added until kernel 5.3, so this means that creating XSK sockets
> always fails on older kernels.
> 
> Since the option is just used to set the zero-copy flag in the xsk struct,
> and that flag is not really used for anything yet, just remove the
> getsockopt() call until a proper use for it is introduced.
> 
> Suggested-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!
