Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF0F311D7
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfEaQBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:01:00 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40498 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfEaQA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:00:59 -0400
Received: by mail-ed1-f65.google.com with SMTP id r18so14231204edo.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJSKuOYS9k4NRm3OvEUNIpiOJPcTngK0103O1r5DO2I=;
        b=HsEQicWC+Yjzq9ZP/U5gFMXFYUlhu4+lyGZR0IXWHfvfCMzrZ0eK3MuxEz7Gi2xH1O
         oJi1trEiPCB7ZdaCJqnn7SINj24pFKO3QATTHS7fy+J+ax/odp3fR39UynoKiEM5Alwz
         nPtzkW37zNzhUc7nfeFFbClrVRAjH7WpksEfskD8X/uwRZ3vMrSPXEpYQSXf74egEOm+
         7hs4oq3F1nziDynu+B3PDAzwfIIRCA4zeqELnbbTzCJWt2+9Bk6bNacBBMosysabBlf9
         cQ1dyChZ/1VwjxzYEOV49tqXtkJHS12vxQwsayYz3ZvfRuZQzrjRqQUHZZ/Wu47jW//w
         nLtA==
X-Gm-Message-State: APjAAAWmN0YM46qKuowK2pMsfRjwtczRyk2XeLDNS2GngZTKHZcQWbr3
        uaRE6ua3ownQYiBiIH1/CGF+tG/BXLFZtyaYJ7bebQ==
X-Google-Smtp-Source: APXvYqzBcqua918Ofe2XHos0qx+eedebxhuC7vPuLyUuQqSChM/qn4iKDWkbwg0kXDb7H1IsrEA+HYDIsD1Svv2y+JM=
X-Received: by 2002:a50:c31a:: with SMTP id a26mr12296051edb.289.1559318458311;
 Fri, 31 May 2019 09:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <7d450cb1d7bc1cde70b530930e0a5d73e39f4fdf.1559304622.git.dcaratti@redhat.com>
In-Reply-To: <7d450cb1d7bc1cde70b530930e0a5d73e39f4fdf.1559304622.git.dcaratti@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Fri, 31 May 2019 18:01:31 +0200
Message-ID: <CAPpH65yQ-si9q-H7SgWpXa0osvT3Y29G5ub_nYEX9=ybAV=G-A@mail.gmail.com>
Subject: Re: [PATCH iproute2] man: tc-skbedit.8: document 'inheritdsfield'
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Qiaobin Fu <qiaobinf@bu.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 2:12 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> while at it, fix missing square bracket near 'ptype' and a typo in the
> action description (it's -> its).
>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  man/man8/tc-skbedit.8 | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/man/man8/tc-skbedit.8 b/man/man8/tc-skbedit.8
> index 003f05c93f7c..2459198261e6 100644
> --- a/man/man8/tc-skbedit.8
> +++ b/man/man8/tc-skbedit.8
> @@ -10,9 +10,10 @@ skbedit - SKB editing action
>  .B priority
>  .IR PRIORITY " ] ["
>  .B mark
> -.IR MARK " ]"
> +.IR MARK " ] ["
>  .B ptype
> -.IR PTYPE " ]"
> +.IR PTYPE " ] ["
> +.BR inheritdsfield " ]"
>  .SH DESCRIPTION
>  The
>  .B skbedit
> @@ -22,7 +23,7 @@ action, which in turn allows to change parts of the packet data itself.
>
>  The most unique feature of
>  .B skbedit
> -is it's ability to decide over which queue of an interface with multiple
> +is its ability to decide over which queue of an interface with multiple
>  transmit queues the packet is to be sent out. The number of available transmit
>  queues is reflected by sysfs entries within
>  .I /sys/class/net/<interface>/queues
> @@ -61,6 +62,12 @@ needing to allow ingressing packets with the wrong MAC address but
>  correct IP address.
>  .I PTYPE
>  is one of: host, otherhost, broadcast, multicast
> +.TP
> +.BI inheritdsfield
> +Override the packet classification decision, and any value specified with
> +.BR priority ", "
> +using the information stored in the Differentiated Services Field of the
> +IPv6/IPv4 header (RFC2474).
>  .SH SEE ALSO
>  .BR tc (8),
>  .BR tc-pedit (8)
> --
> 2.20.1
>

Acked-by: Andrea Claudi <aclaudi@redhat.com>
