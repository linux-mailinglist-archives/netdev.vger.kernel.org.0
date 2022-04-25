Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC0B50D8A2
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 07:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbiDYFKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 01:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbiDYFKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 01:10:44 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0149CAFB0F;
        Sun, 24 Apr 2022 22:07:38 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 23P57A471258693
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 06:07:12 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9d:7e02:9be5:c549:1a72:4709])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 23P575rU1176295
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 07:07:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1650863225; bh=Hq8Mv9+KR67ox4XgcIprQtQiD4GPXI565Ev+TCu5pBQ=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=OIx2r+9x9A10d3G+cgYXwp43SGizI8868JZh6j9sk3vXn07ItAHkoYZNLPHueQf7K
         +TZ3W22OTm35ulR0ByCqzgG9rZdnxVRSIooIcjKOS5/mzXxTKMWBVwSUAFbW/DhWXk
         f2I9maDHXnq9+bSb5joJR/BXA5VtxTZdoQdIbA+c=
Received: (nullmailer pid 1105769 invoked by uid 1000);
        Mon, 25 Apr 2022 05:07:04 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Ethan Yang <ipis.yang@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gchiang@sierrawireless.com,
        Ethan Yang <etyang@sierrawireless.com>
Subject: Re: [PATCH] add support for Sierra Wireless EM7590 0xc081 composition.
Organization: m
References: <20220425031411.4030-1-etyang@sierrawireless.com>
Date:   Mon, 25 Apr 2022 07:07:04 +0200
In-Reply-To: <20220425031411.4030-1-etyang@sierrawireless.com> (Ethan Yang's
        message of "Mon, 25 Apr 2022 11:14:11 +0800")
Message-ID: <87bkwpkayv.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethan Yang <ipis.yang@gmail.com> writes:

> add support for Sierra Wireless EM7590 0xc081 composition.
>
> Signed-off-by: Ethan Yang <etyang@sierrawireless.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 3353e761016d..fa220a13edb6 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1351,6 +1351,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_QUIRK_SET_DTR(0x1199, 0x907b, 8)},	/* Sierra Wireless EM74xx */
>  	{QMI_QUIRK_SET_DTR(0x1199, 0x907b, 10)},/* Sierra Wireless EM74xx */
>  	{QMI_QUIRK_SET_DTR(0x1199, 0x9091, 8)},	/* Sierra Wireless EM7565 */
> +	{QMI_QUIRK_SET_DTR(0x1199, 0xc081, 8)},	/* Sierra Wireless EM7590 */
>  	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alca=
tel One Touch L100V LTE) */
>  	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
>  	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */


Hello!

The diff looks fine to me, but there are some minor issues with the
commit message.  This is how it ended up looking in for me with "git
log":

---
commit 5e3f386fdb23c8e5ba7c24ff5efd6beb73db3e85 (HEAD -> bugfix-master)
Author: Ethan Yang <ipis.yang@gmail.com>
Date:   Mon Apr 25 11:14:11 2022 +0800

    add support for Sierra Wireless EM7590 0xc081 composition.
=20=20=20=20
    add support for Sierra Wireless EM7590 0xc081 composition.
=20=20=20=20
    Signed-off-by: Ethan Yang <etyang@sierrawireless.com>
---

The issues I see there are:


 1) subject should have a prefix - e.g. "net: usb: qmi_wwan:"
=20
 2) don't repeat the subject in the body - that's redundant and ends up
    looking like a duplicate line in the commit message.  Write
    something addding more information instead.  Anything you find
    relevant
=20

 3) I guess you send from a gmail address for a reason.  But you most
    likely want the Author field to match your Signed-off-by?  You can fix
    this by including something like this as the *first* line of the
    message body:

       From: Ethan Yang <etyang@sierrawireless.com>



FYI: checkpatch warns about the last issue:

bjorn@miraculix:/usr/local/src/git/linux$ scripts/checkpatch.pl /tmp/xx
WARNING: From:/Signed-off-by: email address mismatch: 'From: Ethan Yang <ip=
is.yang@gmail.com>' !=3D 'Signed-off-by: Ethan Yang <etyang@sierrawireless.=
com>'

total: 0 errors, 1 warnings, 0 checks, 7 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplac=
e.

/tmp/xx has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.







Bj=C3=B8rn
