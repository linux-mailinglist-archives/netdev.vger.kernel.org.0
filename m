Return-Path: <netdev+bounces-760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD19F6F9AE6
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 20:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5DC3280EBE
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 18:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713178460;
	Sun,  7 May 2023 18:33:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656648825
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 18:33:29 +0000 (UTC)
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450C7A5CC
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 11:33:25 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
	(authenticated bits=0)
	by dilbert.mork.no (8.17.1.9/8.17.1.9) with ESMTPSA id 347IWUYP2239068
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sun, 7 May 2023 19:32:32 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:964:4b0a:9af7:269:d286:bcf0])
	(authenticated bits=0)
	by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 347IWmTd2063124
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sun, 7 May 2023 20:32:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
	t=1683484372; bh=c3j3BZff3ZxiuGutkiPmpfibMn/fulCmnrh81cyL4m0=;
	h=From:To:Cc:Subject:References:Date:Message-ID:From;
	b=idFbGy4hFQPfcBad4p0J+3gR/ggohIqXC3O1lC4F1qLM5N4UxYvg/JARL9lyfr9HS
	 wqUDush5Zd+oPOHqnZBy1iu3WadeVpV6PVYmJM3LjMJ0Gwe7GvfiyA107EiwF3DaW1
	 gtmmJ34AxC8UqALVrTWgbuNJo5/5iStRK1xtnkgI=
Received: (nullmailer pid 40964 invoked by uid 1000);
	Sun, 07 May 2023 18:32:17 -0000
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>,
        Hayes Wang <hayeswang@realtek.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [regression] Kernel OOPS on boot with Kernel 6.3(.1) and
 RTL8153 Gigabit Ethernet Adapter
Organization: m
References: <ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info>
	<87lei36q27.fsf@miraculix.mork.no>
	<20230505120436.6ff8cfca@kernel.org>
Date: Sun, 07 May 2023 20:32:16 +0200
In-Reply-To: <20230505120436.6ff8cfca@kernel.org> (Jakub Kicinski's message of
	"Fri, 5 May 2023 12:04:36 -0700")
Message-ID: <87fs88kn67.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.8 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> writes:

> It's just a hashtable init, I think that we can do:
>
> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index d9c9f45e3529..8a26cd8814c1 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -859,4 +859,4 @@ static int __init bpf_offload_init(void)
>  	return rhashtable_init(&offdevs, &offdevs_params);
>  }
>=20=20
> -late_initcall(bpf_offload_init);
> +core_initcall(bpf_offload_init);
>
>
> Thorsten, how is the communication supposed to work in this case?
> Can you ask the reporter to test this? I don't see them on CC...

FWIW, I tried to reproduce the oops in the hope that I could confirm
a fix.  But I failed. The netdev is successfully deregistered on my
laptop no matter what I do. Tested v6.3 and current net/main, and
tried different tricks to change probe timing.

Guess this is timing sensitive enough that it only shows up on certain
systems.

So we will need the reporter to chime in.


Bj=C3=B8rn

