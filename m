Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93CE55023C
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiFRDA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbiFRDAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404B76C54C;
        Fri, 17 Jun 2022 20:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEC8261F54;
        Sat, 18 Jun 2022 03:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFDEC3411B;
        Sat, 18 Jun 2022 03:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655521223;
        bh=UMr/1+0FrNuGQb7+Yt5Da2Cu5dJKXSTV8zpjYu54Dq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lenzuug8vP1f4zq1Ws3M1PhEgdCNwCysDI9h7x800dZ3vjZD9rgg6+X32ZKhiC9hB
         /zXZz8bJNCXH52Ff2QSPlLC0WlqCrNacXf+x9eeJR5aTPS9iB3eq814gxAvgVQYJ72
         kpkqX15VdRsI2Q9Ckndeq2LOF2x4k3jlVEJRCE9R9xKtDzx8xlOeKv06BMKa7Gv94p
         UTS262GWGX4Ia1zvtAiHagm69add1HCwyAZv21qyW8DauOR7lxs0zC987O5HDa8RhW
         lf+O5e9RqIw+ViAdJ7P/gyXYx3oqwIF2MQO1/OSD4hlgNnmmS56bK9xGMUjr7WjU/N
         wAf+yx9a67kzg==
Date:   Fri, 17 Jun 2022 20:00:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: export symbol for tracepoint_consume_skb
Message-ID: <20220617200021.02ad8ffc@kernel.org>
In-Reply-To: <20220617034809epcms1p20e0e7e0bdb87c5807c6e12cb1ca73c52@epcms1p2>
References: <CGME20220617034809epcms1p20e0e7e0bdb87c5807c6e12cb1ca73c52@epcms1p2>
        <20220617034809epcms1p20e0e7e0bdb87c5807c6e12cb1ca73c52@epcms1p2>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jun 2022 12:48:09 +0900 =EB=B0=B0=EC=84=9D=EC=A7=84 wrote:
> From:=C2=A0Soukjin=C2=A0Bae=C2=A0<soukjin.bae@samsung.com>
> Date:=C2=A0Fri,=C2=A017=C2=A0Jun=C2=A02022=C2=A012:38:29=C2=A0+0900
>=20
> Subject:=C2=A0[PATCH]=C2=A0net:=C2=A0export=C2=A0symbol=C2=A0for=C2=A0tra=
cepoint_consume_skb
>=20
> Need=C2=A0to=C2=A0use=C2=A0the=C2=A0tracepoint_consume_skb=C2=A0symbol=C2=
=A0at=C2=A0module=C2=A0driver
>=20
> Signed-off-by:=C2=A0Soukjin=C2=A0Bae=C2=A0<soukjin.bae@samsung.com>

You should send the emails to the mailing list in plan text, emails
which contain HTML will be rejected.

We don't accept patches which export APIs for out of tree modules.
Please post your module for merging upstream.
