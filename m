Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56C88BCC
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 16:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfHJO6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 10:58:24 -0400
Received: from ms.lwn.net ([45.79.88.28]:54206 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfHJO6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 10:58:24 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id EA68D2EF;
        Sat, 10 Aug 2019 14:58:22 +0000 (UTC)
Date:   Sat, 10 Aug 2019 08:58:21 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc:     linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/networking/af_xdp: Inhibit reference to
 struct socket
Message-ID: <20190810085821.11cee8b0@lwn.net>
In-Reply-To: <20190810121738.19587-1-j.neuschaefer@gmx.net>
References: <20190810121738.19587-1-j.neuschaefer@gmx.net>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Aug 2019 14:17:37 +0200
Jonathan Neuschäfer <j.neuschaefer@gmx.net> wrote:

> With the recent change to auto-detect function names, Sphinx parses
> socket() as a reference to the in-kernel definition of socket. It then
> decides that struct socket is a good match, which was obviously not
> intended in this case, because the text speaks about the syscall with
> the same name.
> 
> Prevent socket() from being misinterpreted by wrapping it in ``inline
> literal`` quotes.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Thanks for looking at that.  The better fix, though, would be to add
socket() to the Skipfuncs array in Documentation/sphinx/automarkup.py.
Then it will do the right thing everywhere without the need to add markup
to the RST files.

Thanks,

jon
