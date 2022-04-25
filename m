Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DAD50D8EC
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 07:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241373AbiDYFre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 01:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbiDYFrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 01:47:10 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B1E167C6;
        Sun, 24 Apr 2022 22:44:07 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 23P5hjwM1259869
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 06:43:47 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9d:7e02:9be5:c549:1a72:4709])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 23P5he0X1180515
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 07:43:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1650865420; bh=ubeZAY5nG60pdB6+hliBhW+n40tOFGvsik1n3S1XKFM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=BfVZ1/I7oUZ4/JUQTdMT1MpihZUzbQjbVz07QISdZirP8T1FkpJLSVHq+9h57hDKR
         gujLPuzfxSOqLYy91u2Zee8aboweR13xLwB8Imp4+IachGjj9m5+Z2f1XDwZ2QcgHL
         vxxkRKm6dhidiGoEzMJzT1m2upqJ7IvnYA1w0h1Y=
Received: (nullmailer pid 1107055 invoked by uid 1000);
        Mon, 25 Apr 2022 05:43:40 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     ipis.yang@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gchiang@sierrawireless.com,
        Ethan Yang <etyang@sierrawireless.com>
Subject: Re: [PATCH v2] net: usb: qmi_wwan: add support for Sierra Wireless
 EM7590
Organization: m
References: <87bkwpkayv.fsf@miraculix.mork.no>
        <20220425054028.5444-1-etyang@sierrawireless.com>
Date:   Mon, 25 Apr 2022 07:43:40 +0200
In-Reply-To: <20220425054028.5444-1-etyang@sierrawireless.com> (ipis yang's
        message of "Mon, 25 Apr 2022 13:40:28 +0800")
Message-ID: <8735i1k99v.fsf@miraculix.mork.no>
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

Thanks!

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
