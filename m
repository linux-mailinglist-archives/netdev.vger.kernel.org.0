Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75422B74E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgGWUOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgGWUOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:14:22 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08F6C0619DC;
        Thu, 23 Jul 2020 13:14:21 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id E42482BA;
        Thu, 23 Jul 2020 20:14:20 +0000 (UTC)
Date:   Thu, 23 Jul 2020 14:14:19 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] docs: index.rst: Add watch_queue
Message-ID: <20200723141419.01373889@lwn.net>
In-Reply-To: <20200718165107.625847-13-dwlsalmeida@gmail.com>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
        <20200718165107.625847-13-dwlsalmeida@gmail.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 13:51:07 -0300
"Daniel W. S. Almeida" <dwlsalmeida@gmail.com> wrote:

> From: "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
> 
> Fix the following sphinx warning:
> 
> Documentation/watch_queue.rst:
> WARNING: document isn't included in any toctree
> 
> By adding watch_queue.rst to the index.
> 
> Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
> ---
>  Documentation/index.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/index.rst b/Documentation/index.rst
> index 3b491af0122de..57719744774c2 100644
> --- a/Documentation/index.rst
> +++ b/Documentation/index.rst
> @@ -193,6 +193,7 @@ to ReStructured Text format, or are simply too old.
>     :maxdepth: 2
>  
>     staging/index
> +   watch_queue

Thanks, I've applied this, but it isn't really the right fix - this
document should not be at the top level of Documentation/.  I'd be
inclined to move it under userspace-api/, even though there's a strange
mixture of user-space and kernel material here...

jon
