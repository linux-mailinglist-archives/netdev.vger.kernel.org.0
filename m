Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3CF4FC275
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348506AbiDKQg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348553AbiDKQgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:36:22 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E972E7E;
        Mon, 11 Apr 2022 09:34:05 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9f:8600:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 23BGXc7W674600
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 17:33:40 +0100
Received: from miraculix.mork.no (ip-60-18-248-87.eidsiva.net [87.248.18.60] (may be forged))
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 23BGXcDQ3493261
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 18:33:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1649694818; bh=uqwVfZl85irAGcKmQTCFWVKvrirB5WC2P3nhY5ZmQwI=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=SfiUidB+b2fSEPq7suo8IpjEH99O6kn0jfWUgajv3jbmtwJmf4OrmrkxSt8C6zgqO
         hyNwythEc//lwkPPghjgLrrSbpPCE3zPxMA1LeIoJosmXU4EoZrGHDaWG9tx25B4S7
         hDkOtXYB1FgP4B7ECzilJ3aeMfdFvF7cXZOuuWnk=
Received: (nullmailer pid 831328 invoked by uid 1000);
        Mon, 11 Apr 2022 16:33:33 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: usb: qmi_wwan: add Telit 0x1057 composition
Organization: m
References: <20220411135943.4067264-1-dnlplm@gmail.com>
Date:   Mon, 11 Apr 2022 18:33:33 +0200
In-Reply-To: <20220411135943.4067264-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Mon, 11 Apr 2022 15:59:43 +0200")
Message-ID: <877d7vwpeq.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Add the following Telit FN980 composition:
>
> 0x1057: tty, adb, rmnet, tty, tty, tty, tty, tty
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
