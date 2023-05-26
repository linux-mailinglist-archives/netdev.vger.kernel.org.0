Return-Path: <netdev+bounces-5761-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 780DA712AB6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34F6B281981
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC76261F7;
	Fri, 26 May 2023 16:35:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA502CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:35:47 +0000 (UTC)
X-Greylist: delayed 900 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 May 2023 09:35:45 PDT
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6572ED3;
	Fri, 26 May 2023 09:35:45 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
	(authenticated bits=0)
	by dilbert.mork.no (8.17.1.9/8.17.1.9) with ESMTPSA id 34QFqPX1797238
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 26 May 2023 16:52:27 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:964:4b0a:9af7:269:d286:bcf0])
	(authenticated bits=0)
	by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 34QFqJ1F2011317
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 26 May 2023 17:52:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
	t=1685116340; bh=GqbFcD7yraD0qaPrbNtQUGcrPYRPswzOt7XR2SN11+E=;
	h=From:To:Cc:Subject:References:Date:Message-ID:From;
	b=Y/Xaol3V1MRldmRYnRbpikXEPfecco266dCzGGkBtSuyB2HzS+yG1Dzd3ImI9/no8
	 QRYScO8rfVLwVcNxUO9a1Hh5MR1k9db0XYIogSIl4DoGy/hiO9gbhbFzc9IUtGEtv6
	 TJd5eggpLOiy+C8pr+9mAagiMiTybMnzjjIvn8Gc=
Received: (nullmailer pid 1073735 invoked by uid 1000);
	Fri, 26 May 2023 15:52:14 -0000
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>, Bob Ham <bob.ham@puri.sm>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@puri.sm, stable@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Set DTR quirk for BroadMobi BM818
Organization: m
References: <20230526-bm818-dtr-v1-1-64bbfa6ba8af@puri.sm>
Date: Fri, 26 May 2023 17:52:14 +0200
In-Reply-To: <20230526-bm818-dtr-v1-1-64bbfa6ba8af@puri.sm> (Sebastian
	Krzyszkowiak's message of "Fri, 26 May 2023 16:38:11 +0200")
Message-ID: <877csvt7ip.fsf@miraculix.mork.no>
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

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm> writes:

> BM818 is based on Qualcomm MDM9607 chipset.
>
> Fixes: 9a07406b00cd ("net: usb: qmi_wwan: Add the BroadMobi BM818 card")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

