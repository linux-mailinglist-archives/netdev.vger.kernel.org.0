Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BB110580A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKURJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:09:21 -0500
Received: from ms.lwn.net ([45.79.88.28]:34168 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfKURJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 12:09:21 -0500
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id A354B6D9;
        Thu, 21 Nov 2019 17:09:20 +0000 (UTC)
Date:   Thu, 21 Nov 2019 10:09:19 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Robert Schwebel <r.schwebel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/5] docs: networking: nfc: fix code block syntax
Message-ID: <20191121100919.1b483fab@lwn.net>
In-Reply-To: <20191121155503.52019-4-r.schwebel@pengutronix.de>
References: <20191121155503.52019-1-r.schwebel@pengutronix.de>
        <20191121155503.52019-4-r.schwebel@pengutronix.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 16:55:02 +0100
Robert Schwebel <r.schwebel@pengutronix.de> wrote:

> Silence this warning:
> 
> Documentation/networking/nfc.rst:113: WARNING: Definition list ends without
> a blank line; unexpected unindent.
> 
> Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
> ---
>  Documentation/networking/nfc.txt | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/networking/nfc.txt b/Documentation/networking/nfc.txt
> index af69b3a90eaa..63e483f6afb4 100644
> --- a/Documentation/networking/nfc.txt
> +++ b/Documentation/networking/nfc.txt
> @@ -105,12 +105,14 @@ LOW-LEVEL DATA EXCHANGE:
>  The userspace must use PF_NFC sockets to perform any data communication with
>  targets. All NFC sockets use AF_NFC:
>  
> -struct sockaddr_nfc {
> -       sa_family_t sa_family;
> -       __u32 dev_idx;
> -       __u32 target_idx;
> -       __u32 nfc_protocol;
> -};
> +.. code-block:: none
> +
> +        struct sockaddr_nfc {
> +               sa_family_t sa_family;
> +               __u32 dev_idx;
> +               __u32 target_idx;
> +               __u32 nfc_protocol;
> +        };

Rather than cluttering the text with ".. code-block::", you can just use
the literal-block shortcut:

	targets. All NFC sockets use AF_NFC::

	    struct sockaddr_nfc {

Thanks,

jon

>  
>  To establish a connection with one target, the user must create an
>  NFC_SOCKPROTO_RAW socket and call the 'connect' syscall with the sockaddr_nfc
