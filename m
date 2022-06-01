Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69F539CE7
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243355AbiFAGEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbiFAGE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:04:29 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AC966C93;
        Tue, 31 May 2022 23:04:27 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 25163bpO1194431
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 07:03:38 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9d:7e02:9be5:c549:1a72:4709])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 25163VY73277715
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 08:03:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1654063412; bh=Z8VQepQywpNhUdP9sxuS8hnvH4ZlltBtmsUuhQTli2c=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=fod5sVP1nRIUCLjzh5U/9k1uJkaqhtnrbBpk9XMMyVd9rS53i36+NN5b3jvPIqmjE
         6ODblHo1JzsyA1n42cglXvZw8FJoMgVVvkO5ha2kZ66mD2WZXrEuNbGmrKnp+jpdFI
         uY5Dxv/K2gzDJWEYyS1pNIqfODeBOoQUJ8Xrop3c=
Received: (nullmailer pid 1032539 invoked by uid 1000);
        Wed, 01 Jun 2022 06:03:31 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV31 with
 new baseline
Organization: m
References: <20220601040531.6016-1-slark_xiao@163.com>
Date:   Wed, 01 Jun 2022 08:03:31 +0200
In-Reply-To: <20220601040531.6016-1-slark_xiao@163.com> (Slark Xiao's message
        of "Wed, 1 Jun 2022 12:05:31 +0800")
Message-ID: <87o7zcly30.fsf@miraculix.mork.no>
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

Slark Xiao <slark_xiao@163.com> writes:

> Adding support for Cinterion device MV31 with Qualcomm
> new baseline. Use different PIDs to separate it from
> previous base line products.
> All interfaces settings keep same as previous.
>
> T:  Bus=3D03 Lev=3D01 Prnt=3D01 Port=3D00 Cnt=3D01 Dev#=3D  7 Spd=3D480 M=
xCh=3D 0
> D:  Ver=3D 2.10 Cls=3Def(misc ) Sub=3D02 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D1e2d ProdID=3D00b9 Rev=3D04.14
> S:  Manufacturer=3DCinterion
> S:  Product=3DCinterion PID 0x00B9 USB Mobile Broadband
> S:  SerialNumber=3D90418e79
> C:  #Ifs=3D 4 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D50 Drive=
r=3Dqmi_wwan
> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D40 Drive=
r=3Doption
> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D60 Drive=
r=3Doption
> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3D30 Drive=
r=3Doption
>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Thanks

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
