Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8789D1D0C0B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgEMJ2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgEMJ2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:28:51 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F36C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 02:28:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h10so3171549iob.10
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 02:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CdVf4SgFHjgLpfIEcLy499lStPfmxw/48zFjBHeHUoI=;
        b=o0I0h87FDyM286c3gcOI5mhYNuyEOgq9RGYpTSSKT1ETbVz2FAc6i27p0Hc5qLnAuN
         hV3dHivXX/lRNnoWN84E5s3+MCCqWkmUi90fjynLp3s7Ig3nttargqvUNYbTCrXydqfo
         orBLVwfkRho6h149FBqgWWQrEI8PY4uahLh3C2dC2c7jqSwWeWA3of+Cnp4tZCPjQ+jo
         KQHK1VKUnBihJkrBDCqVZdBF3KJvEv5s6bqZ9fETBBX2xAP/Z3JHLHXtFTF+JkyQIg87
         1lFWdjFidUHN0L6cmD+cOpcBySRj2lCZO/AJbzAtu3FCGbJ2jGzO0ok2u0TB6HK6kqt9
         HuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CdVf4SgFHjgLpfIEcLy499lStPfmxw/48zFjBHeHUoI=;
        b=N+hz5utOroFeaxnsn13i6/W7gKOLh6KVM1M37Kp/B6pEq3zClKgRfnrsniFOg8QbUl
         xs64ggti7LPODWWxxwY/jIw1Dh9fIfWO1ap7MG4ZAy9+hNSP3/bOMtOBgdMm0aN1jHGn
         cj0wlrNm2cEMNhXgszV8/NqN1HuX0qPt7+rka6/yN0q6QFxEbV9v/7g5txcNcjVAltUs
         Yw0Li6zYb1G7ZQ5QCHqRQ3R7+V0Ljnsk06IcQd8i0tav67ZWKqcyzu/6MioUD1fujvpb
         pGmpKobKVlG5tK8gWsWUnbWap0uIIHj3ouGp2ovMWpebYf/X/Am3B9tQz5Q+C4SaxveA
         FLZQ==
X-Gm-Message-State: AGi0PubxUxyLV3oM6Gt9sZi+SXrt29AaDqgKbPATbjV9hbViZJe9GNTK
        DpAJ1JbcYjK6hn9sFLK7J9cyaRzcy3WSsi+b5Sh1Ew==
X-Google-Smtp-Source: APiQypLLWL+zJYh56/QnAXykLr4ls5csPc2oYZvuX26lgVFhd34E9IawxXyEkvOTiXiMyq+CRSwuAwFMOwDRAxuM+EE=
X-Received: by 2002:a05:6638:1131:: with SMTP id f17mr547219jar.61.1589362122397;
 Wed, 13 May 2020 02:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200513043908.GA25216@f3> <20200513091754.32090-1-jengelh@inai.de>
In-Reply-To: <20200513091754.32090-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 13 May 2020 02:28:25 -0700
Message-ID: <CANP3RGfNH1m=-rFdkAmGUt3vxFqaGmJnW+RKP-faU6WwOKWoZg@mail.gmail.com>
Subject: Re: [PATCH v3] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

you still missed: succesful -> successful

On Wed, May 13, 2020 at 2:17 AM Jan Engelhardt <jengelh@inai.de> wrote:
>
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>
> Spello fix near "indiscriminately".
>
>  extensions/libip6t_REJECT.man | 20 ++++++++++++++++++++
>  extensions/libipt_REJECT.man  | 20 ++++++++++++++++++++
>  2 files changed, 40 insertions(+)
>
> diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.ma=
n
> index 0030a51f..7387436c 100644
> --- a/extensions/libip6t_REJECT.man
> +++ b/extensions/libip6t_REJECT.man
> @@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful=
 for blocking
>  hosts (which won't accept your mail otherwise).
>  \fBtcp\-reset\fP
>  can only be used with kernel versions 2.6.14 or later.
> +.PP
> +\fIWarning:\fP You should not indiscriminately apply the REJECT target t=
o
> +packets whose connection state is classified as INVALID; instead, you sh=
ould
> +only DROP these.
> +.PP
> +Consider a source host transmitting a packet P, with P experiencing so m=
uch
> +delay along its path that the source host issues a retransmission, P_2, =
with
> +P_2 being succesful in reaching its destination and advancing the connec=
tion
> +state normally. It is conceivable that the late-arriving P may be consid=
ered to
> +be not associated with any connection tracking entry. Generating a rejec=
t
> +packet for this packet would then terminate the healthy connection.
> +.PP
> +So, instead of:
> +.PP
> +-A INPUT ... -j REJECT
> +.PP
> +do consider using:
> +.PP
> +-A INPUT ... -m conntrack --ctstate INVALID -j DROP
> +-A INPUT ... -j REJECT
> diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
> index 8a360ce7..618a766c 100644
> --- a/extensions/libipt_REJECT.man
> +++ b/extensions/libipt_REJECT.man
> @@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful=
 for blocking
>  hosts (which won't accept your mail otherwise).
>  .IP
>  (*) Using icmp\-admin\-prohibited with kernels that do not support it wi=
ll result in a plain DROP instead of REJECT
> +.PP
> +\fIWarning:\fP You should not indiscriminately apply the REJECT target t=
o
> +packets whose connection state is classified as INVALID; instead, you sh=
ould
> +only DROP these.
> +.PP
> +Consider a source host transmitting a packet P, with P experiencing so m=
uch
> +delay along its path that the source host issues a retransmission, P_2, =
with
> +P_2 being succesful in reaching its destination and advancing the connec=
tion
> +state normally. It is conceivable that the late-arriving P may be consid=
ered to
> +be not associated with any connection tracking entry. Generating a rejec=
t
> +packet for this packet would then terminate the healthy connection.
> +.PP
> +So, instead of:
> +.PP
> +-A INPUT ... -j REJECT
> +.PP
> +do consider using:
> +.PP
> +-A INPUT ... -m conntrack --ctstate INVALID -j DROP
> +-A INPUT ... -j REJECT
> --
> 2.26.2
>
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
