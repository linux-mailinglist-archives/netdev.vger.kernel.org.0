Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844B6632406
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiKUNk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiKUNkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:40:39 -0500
Received: from canardo.dyn.mork.no (fwa5cad-106.bb.online.no [88.92.173.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C679B8FB2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:40:33 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9c:2c02:34cc:c78d:869d:3d9d])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 2ALDeJ2k1857060
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 14:40:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1669038019; bh=nZalgc/HsUitZSnJesrfvKfSowiiPHUBrtexHfBOww4=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=CON5u1fn3xngG77JeSZdgLOtrwMBig7gmlyu9SJP6PgihQVWEsF7MGxpIMI9v0p9o
         CbJwjT9zykJi92zStFtWJ9w+uE+Fwdwjc1ZIrq3qP2xleav0K/VVYQHd/c0/7wnHUh
         jR6NCbaE7jOXA5J3O87pNM5bM13GgIjVe9s/3btk=
Received: (nullmailer pid 197193 invoked by uid 1000);
        Mon, 21 Nov 2022 13:40:18 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Davide Tronchin <davide.tronchin.94@gmail.com>
Cc:     netdev@vger.kernel.org, marco.demarco@posteo.net
Subject: Re: [PATCH] net: usb: qmi_wwan: add u-blox 0x1342 composition
Organization: m
References: <20221121125455.66307-1-davide.tronchin.94@gmail.com>
Date:   Mon, 21 Nov 2022 14:40:18 +0100
In-Reply-To: <20221121125455.66307-1-davide.tronchin.94@gmail.com> (Davide
        Tronchin's message of "Mon, 21 Nov 2022 13:54:55 +0100")
Message-ID: <87tu2sh1dp.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SORBS_DUL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Davide Tronchin <davide.tronchin.94@gmail.com> writes:

> Add RmNet support for LARA-L6.
>
> LARA-L6 module can be configured (by AT interface) in three different
> USB modes:
> * Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
> interfaces
> * RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
> interfaces and 1 RmNet virtual network interface
> * CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
> interface and 1 CDC-ECM virtual network interface
>
> In RmNet mode LARA-L6 exposes the following interfaces:
> If 0: Diagnostic
> If 1: AT parser
> If 2: AT parser
> If 3: AT parset/alternative functions
> If 4: RMNET interface
>
> Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>


Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
