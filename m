Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9121E62C742
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiKPSJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKPSJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:09:44 -0500
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64A765DC;
        Wed, 16 Nov 2022 10:09:42 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9c:2c00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 2AGI9CfT1223379
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 18:09:14 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9c:2c02:34cc:c78d:869d:3d9d])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 2AGI97Nh3152598
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 19:09:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1668622147; bh=jtyIbh1dY7XyEMajfvkSl+SKwUTaVXtQNcZ1xCMTwYQ=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=PhNyJRin7mlxIxKx/2Jse+2p+9InxdBMxDkQNOWQ3IGG2XKyMpHzbfwCPJK+pB+Bk
         4sJH8sIEUAcw36yjFHEQfM7SnvHCPGIIe7GWZBwSWMcpdnLavLfVXxexz4vBAyXZGC
         htPbhUVKupI7xOCvpQa+uvfX7cFTe/WVD5IgVb7U=
Received: (nullmailer pid 458000 invoked by uid 1000);
        Wed, 16 Nov 2022 18:09:07 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Enrico Sau <enrico.sau@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x103a composition
Organization: m
References: <20221115105859.14324-1-enrico.sau@gmail.com>
Date:   Wed, 16 Nov 2022 19:09:07 +0100
In-Reply-To: <20221115105859.14324-1-enrico.sau@gmail.com> (Enrico Sau's
        message of "Tue, 15 Nov 2022 11:58:59 +0100")
Message-ID: <87y1sa7ovw.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enrico Sau <enrico.sau@gmail.com> writes:

> Add the following Telit LE910C4-WWX composition:
>
> 0x103a: rmnet
>
> Signed-off-by: Enrico Sau <enrico.sau@gmail.com>

Looks good.  Thanks

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
