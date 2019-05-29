Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2C22E959
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfE2X05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:26:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38113 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2X05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 19:26:57 -0400
Received: by mail-ed1-f66.google.com with SMTP id g13so6235343edu.5;
        Wed, 29 May 2019 16:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4MYDvvkcBMpD3vTFCGd0htlT0GxbUehOqYVwE/XNQ9w=;
        b=r9y1ILosMv1HdLnsdsAP+MOj8XoPRuEhpX+827w9xBOQ4atic97Pj5M57pj7RqdciP
         o4NSSKU+sBsW+S00Z3Q9wK2lJpFLwI9hObrUubudDFxx5f2aH6wKfZv71g1B4NB8Ijg7
         wVbYcgqIUIUm2gMwMYvxncCQqmVzUIrGYMRGSmHJiKOn0Bv1nNYKwRm1laaQkp2lNxxR
         hOr02yrpjt7u07lHY5gfV0YLdBNIRb6c3uS4t3npWort/GbChtnyUMV0Ta0DSNqK/lvf
         hCrjWka+iETsxPTS106cV3W4ZLjeOJSzoQUXpTqOdDwWcIXp6nK7DYoPtDHHPc4Yx2hf
         cuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4MYDvvkcBMpD3vTFCGd0htlT0GxbUehOqYVwE/XNQ9w=;
        b=RF6GwOPDuvuQ8Nz58geNBG2Ra68mpikEV6G4KXgOBBJXZIvAFhezUNrjO97YBKDJWU
         pbpu2MZLKnUXSjXFcXG4+0MSfrbVuX/XIwQWZwm/eXGVo8dUxqtndmfVTgjYdSEAu6r3
         gOCDI3zsyIYh9Baork7LD4zVkJemrBeEaK7eUSfF6+fAQ3gehn7q284CoXeCdKWVBS72
         uhZe8Bq0R+RrIuWImletxYL3/czdtCwPKUiy20vRJ4Ana9q2qtblIAtELefxYDKKQy1i
         fvzmvf+KZAah7kw60AhqzaebQWGfr0vrJudq0OmHjuQkvBw07TT8e2QkFSIWcUuVOupX
         1qGQ==
X-Gm-Message-State: APjAAAWu8LPQmjBZCiVZlyki8D1xDRsu7UuYysAAAta3OzXqf7i6Wr9y
        fg/Qlw969ijK6040R12JlSFrGedbSJQAZgwR45w=
X-Google-Smtp-Source: APXvYqwnheto+zYvIaHfRrjE+flVSb0ynWBD4Kqor0qxUvVvN3xWwpreCuaWW1NOsE9qA9ag86vzCURZDstGO6tJSe8=
X-Received: by 2002:a05:6402:1543:: with SMTP id p3mr1047442edx.108.1559172415592;
 Wed, 29 May 2019 16:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559171394.git.mchehab+samsung@kernel.org> <c8f6ddd2d538e36f6036681f5756f6ea9499039f.1559171394.git.mchehab+samsung@kernel.org>
In-Reply-To: <c8f6ddd2d538e36f6036681f5756f6ea9499039f.1559171394.git.mchehab+samsung@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 30 May 2019 02:26:44 +0300
Message-ID: <CA+h21hqtfh1KTZXXC+Hmf7JUkXpWwjtJU_KS_u-wcjnWA3pLZA@mail.gmail.com>
Subject: Re: [PATCH 21/22] docs: net: sja1105.rst: fix table format
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 at 02:24, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> There's a table there with produces two warnings when built
> with Sphinx:
>
>     Documentation/networking/dsa/sja1105.rst:91: WARNING: Block quote ends without a blank line; unexpected unindent.
>     Documentation/networking/dsa/sja1105.rst:91: WARNING: Block quote ends without a blank line; unexpected unindent.
>
> It will still produce a table, but the html output is wrong, as
> it won't interpret the second line as the continuation for the
> first ones, because identation doesn't match.
>
> After the change, the output looks a way better and we got rid
> of two warnings.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  Documentation/networking/dsa/sja1105.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
> index ea7bac438cfd..cb2858dece93 100644
> --- a/Documentation/networking/dsa/sja1105.rst
> +++ b/Documentation/networking/dsa/sja1105.rst
> @@ -86,13 +86,13 @@ functionality.
>  The following traffic modes are supported over the switch netdevices:
>
>  +--------------------+------------+------------------+------------------+
> -|                    | Standalone |   Bridged with   |   Bridged with   |
> -|                    |    ports   | vlan_filtering 0 | vlan_filtering 1 |
> +|                    | Standalone | Bridged with     | Bridged with     |
> +|                    | ports      | vlan_filtering 0 | vlan_filtering 1 |
>  +====================+============+==================+==================+
>  | Regular traffic    |     Yes    |       Yes        |  No (use master) |
>  +--------------------+------------+------------------+------------------+
>  | Management traffic |     Yes    |       Yes        |       Yes        |
> -|    (BPDU, PTP)     |            |                  |                  |
> +| (BPDU, PTP)        |            |                  |                  |
>  +--------------------+------------+------------------+------------------+
>
>  Switching features
> --
> 2.21.0
>

Acked-by: Vladimir Oltean <olteanv@gmail.com>
