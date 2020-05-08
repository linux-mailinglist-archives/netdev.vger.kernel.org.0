Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE56A1CB43E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgEHQA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgEHQA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 12:00:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCC120725;
        Fri,  8 May 2020 16:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588953656;
        bh=+zD3Jtj+Es8ilD9qppwj3Jh+4HWpyu/Df6rLL7OWGPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bCy53VCm5fcZHx/4PekPRcSqS9MMZXEh1kQxgN4ALNUbTBeaGSPdRy9MtU0275CPw
         T+nBaOf7a2+4aZBBXusQUl1sjD1iEBM4RT+cXPBdEUj5txhtpbxcHb6R88C1DqloUz
         rqxnTQjNi8Y+Cb/UOI116+LaCip5vDPXDuoB0kmA=
Date:   Fri, 8 May 2020 09:00:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next v3 07/33] xdp: xdp_frame add member frame_sz
 and handle in convert_to_xdp_frame
Message-ID: <20200508090054.14138b79@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <158893616140.2321140.12105192195910658974.stgit@firesoul>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
        <158893616140.2321140.12105192195910658974.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 08 May 2020 13:09:21 +0200 Jesper Dangaard Brouer wrote:
> +/* Used by XDP_WARN macro, to avoid inlining WARN() in fast-path */
> +void xdp_warn(const char* msg, const char* func, const int line) {
> +	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
> +};
> +EXPORT_SYMBOL_GPL(xdp_warn);

ERROR: "foo* bar" should be "foo *bar"
#59: FILE: include/net/xdp.h:109:
+void xdp_warn(const char* msg, const char* func, const int line);

ERROR: "foo* bar" should be "foo *bar"
#59: FILE: include/net/xdp.h:109:
+void xdp_warn(const char* msg, const char* func, const int line);

ERROR: "foo* bar" should be "foo *bar"
#104: FILE: net/core/xdp.c:502:
+void xdp_warn(const char* msg, const char* func, const int line) {

ERROR: "foo* bar" should be "foo *bar"
#104: FILE: net/core/xdp.c:502:
+void xdp_warn(const char* msg, const char* func, const int line) {

ERROR: open brace '{' following function definitions go on the next line
#104: FILE: net/core/xdp.c:502:
+void xdp_warn(const char* msg, const char* func, const int line) {
