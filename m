Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CDB5BDAE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfGAOKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:10:08 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41031 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbfGAOKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 10:10:08 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so23749615eds.8
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 07:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R3J2eBnWRAew9xlfRZxduN2Y5tSBwgkWhVf1LV4jyJA=;
        b=fHTlPjkBycbePC1CMBBFVpAy4OawyUkjeCU22uyOaROnYtdnnQZVSyxUTT6kx23eoD
         Ac09TbefIMpylG0eS8S/4twf9OK66Liqe5b/5UTZEe7Xk5V1I5b03uyI2rl325GDl7OG
         GwG+FU7rYCp8RlThpHsVFoh6lT60j+TNUhuYX0b9JytKTBA2MeOEiYxBt9hPgB3E3/ng
         pizlrXzA1yLFPdEgw8C5IE05BBOuQ/UyWkT1Bk1TOgl6Hg84hsiWtwKRi7IRSLedDQvP
         ixHIKX9xY4RzmnlZOR+4bvnG0PKQp74/Wwm6qVaP8G15K6dbXPNXPqn5QCn0K5keuvih
         VhXg==
X-Gm-Message-State: APjAAAV6GNPX+h5E1QpibhoEtUnBNBy8ijZ6Uqtla+QhE1d918IT4Kkc
        M8ZRSoRv7U+8v6rkc7XtY6LJYrirVVDNQnXAJ3wMtBCYo0E=
X-Google-Smtp-Source: APXvYqwiTKX1YcSnP63rx0TtS4YSnLHTwbG4a0X61kM6MDjmLKMFa60yJemDEsLGYpgC/OB1XcuMuCE2cmWzPRVc7M4=
X-Received: by 2002:a50:900d:: with SMTP id b13mr29144464eda.289.1561990206178;
 Mon, 01 Jul 2019 07:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <39256a189709ec195fd97da736ee5b003a49f298.1561989640.git.aclaudi@redhat.com>
In-Reply-To: <39256a189709ec195fd97da736ee5b003a49f298.1561989640.git.aclaudi@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Mon, 1 Jul 2019 16:10:55 +0200
Message-ID: <CAPpH65zeHAoHmPfJjaufWcLWm76U+idTduc3fmWVK7=i0KOZSw@mail.gmail.com>
Subject: Re: [PATCH iproute2] man: tc-netem.8: fix URL for netem page
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 4:05 PM Andrea Claudi <aclaudi@redhat.com> wrote:
>
> URL for netem page on sources section points to a no more existent
> resource. Fix this using the correct URL.
>
> Fixes: cd72dcf13c8a4 ("netem: add man-page")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  man/man8/tc-netem.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/man/man8/tc-netem.8 b/man/man8/tc-netem.8
> index 111109cf042f0..5a08a406a4a7b 100644
> --- a/man/man8/tc-netem.8
> +++ b/man/man8/tc-netem.8
> @@ -219,7 +219,7 @@ April 2005
>  (http://devresources.linux-foundation.org/shemminger/netem/LCA2005_paper.pdf)
>
>  .IP " 2. " 4
> -Netem page from Linux foundation, (http://www.linuxfoundation.org/en/Net:Netem)
> +Netem page from Linux foundation, (https://wiki.linuxfoundation.org/networking/netem)
>
>  .IP " 3. " 4
>  Salsano S., Ludovici F., Ordine A., "Definition of a general and intuitive loss
> --
> 2.20.1
>

Hi Stephen,
I noticed that the link to your LCA 2005 paper is wrong, too (it
actually redirects to the home page of the Linux Foundation Wiki). If
you provide me the correct URL, I will happily send a v2 of this patch
fixing that, too.

Regards,
Andrea
