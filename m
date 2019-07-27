Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF977576
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 02:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfG0AqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 20:46:16 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44823 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0AqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 20:46:16 -0400
Received: by mail-lj1-f196.google.com with SMTP id k18so53085331ljc.11
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 17:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UDKQqWrRKkEyYs4VcQEabb6TsfkMI9hDY7tUqyW8+ZA=;
        b=IHPUa0cBo9BoHwYasZY/Q7E+Dh+u4GyFivrHyVk0/6AxjMtgpMNT5hVA+AYWElEhHY
         zEDpL1crmZwn91GfPQZqlRH5xyDgF74W4ygUaTtyT/WMoPltNv56+VRMvLki+FDyqE6/
         ZuWQt3obDSKxT3U4BlWyt+RJSaTHhRy43ET7TGO+BgIVWJeUiwCWItUvqSlijBAJRkJr
         ieu3kJNNFTMtGRkXLhSLFmx6Qr5U/R0dGjR1gwWwmwXRpxdfKIidgIeKy/5/tdt4drmF
         QMz5Zoc4pdMmXhs6dkrMCxj1KCb2zuyutS3Caebt0j9AHDXXZUXoZDARcG/dJr7rRTl7
         fhgA==
X-Gm-Message-State: APjAAAVXKB8vRkWbC6q+KXMHm5LGCd3fTHWEmbzHIRyqHLuSqoEeAmpW
        TfExRE9E/tzt7vvG/p8IgNXynffcEh/eieD0WGsOSvIJfV9Abg==
X-Google-Smtp-Source: APXvYqwGuQEK3UT849+LjdebGrJmQmRMPjZ/l31ZyGdcV8LG72VOIYzZMqldw06KBlgJQs1ocEW5lqiD7Oh64NieA0I=
X-Received: by 2002:a2e:9117:: with SMTP id m23mr51263137ljg.134.1564188374072;
 Fri, 26 Jul 2019 17:46:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191218.11757-1-mcroce@redhat.com> <20190726215959.6312-1-stephen@networkplumber.org>
In-Reply-To: <20190726215959.6312-1-stephen@networkplumber.org>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 27 Jul 2019 02:45:38 +0200
Message-ID: <CAGnkfhzT6qCUp1uge3tOF9wxHGZxmY=-pjiMg=JCpc6=0S2LUw@mail.gmail.com>
Subject: Re: [PATCH] iplink: document 'change' option to ip link
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 12:00 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> Add the command alias "change" to man page.
> Don't show it on usage, since it is not commonly used.
>
> Reported-off-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  man/man8/ip-link.8.in | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index 883d88077d66..a8ae72d2b097 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -1815,6 +1815,11 @@ can move the system to an unpredictable state. The solution
>  is to avoid changing several parameters with one
>  .B ip link set
>  call.
> +The modifier
> +.B change
> +is equivalent to
> +.BR "set" .
> +
>
>  .TP
>  .BI dev " DEVICE "
> --
> 2.20.1
>

Acked-by: Matteo Croce <mcroce@redhat.com>

-- 
Matteo Croce
per aspera ad upstream
