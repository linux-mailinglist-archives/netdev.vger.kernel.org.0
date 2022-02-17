Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2222B4B95FD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiBQCmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:42:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiBQCmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:42:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E4413777A;
        Wed, 16 Feb 2022 18:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6BEB820DC;
        Thu, 17 Feb 2022 02:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B727C004E1;
        Thu, 17 Feb 2022 02:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645065734;
        bh=/eo83eETJirNAW9oZfvwbyr5GBKAdQ4yTXRCims8GSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cCH3ydKVfctBSlN3BoQahkeVLAkhtnr92ZcWyFSxVbgfMdLiNKbxmWsc3CmeLMoGV
         zec6NKzNjsAF4tg6WqYIVYV7bNxAwzldIgGrH7Ycem9BKQq1wRwwn4UcNLEj2Qmrga
         cF2Yw/Q/Rn4Dk24LZOUcL5H+6vWMyLPHWnEdNdCWg9DETLk+Uk8BIRAzlj2jyr8ZH5
         aA/Ld3LNIOZ2LRJASRCHXtyk2p/k1pChzs8Iyi6HeAjBe0O3PpaMjjPMfpWMvyxLSu
         IB4uyKLNB6XLH7GKrW5zahfReILCapck4PGo365c/pj7N3lWlrRMwouXqUZZY3Zhgz
         tM4/qnOjSGr6A==
Date:   Wed, 16 Feb 2022 18:42:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] tw89: core.h: Replace zero-length array with
 flexible-array member
Message-ID: <20220216184213.13328667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220216195047.GA904198@embeddedor>
References: <20220216195047.GA904198@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 13:50:47 -0600 Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use =E2=80=9Cflexible array members=E2=80=9D[1]=
 for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
>=20
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-le=
ngth-and-one-element-arrays
>=20
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

The subject is off.
