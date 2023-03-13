Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13946B6F4E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 06:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCMFxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 01:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCMFxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 01:53:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3949029;
        Sun, 12 Mar 2023 22:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7AC6B80DDC;
        Mon, 13 Mar 2023 05:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143CFC433D2;
        Mon, 13 Mar 2023 05:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678686781;
        bh=fKbUh9P1CYdgNOyUqjuVHWtV/UeXm6zn5tamtvw/WfE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=evAQ3fgS4zslKxiKpjkeq8ORk6XSkx6/dxGV49rHK9KaQAcoeEjyNbFZqycugobeD
         L+Lw1I5fL94VdcznObeWwvhQHbKiH1+YI65cB1z54CaBAcic62Dgj4IXW2w+A3El+X
         iNEyGGvfzkMOoeni3iOfOpog/kbGw9yX2uwBrXsk94gb+clnYq/Qp08CTc5Dm/26A5
         uY1irwcZIxitYGR2/Zvlxdjb+83HhKwgq8fKNgmeJYmckL2vAJAzvAsrAaBGNLBcX3
         kBgzDhGYyOCD1xrjZ7qKZExGYidwMTdDDWFGNeeBoHSZ2DUQP2cJiw5cU/SvDaAami
         ylof7UXYIKYBQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sireesh Kodali <sireeshkodali1@gmail.com>
Cc:     loic.poulain@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        linux-kernel@vger.kernel.org,
        Vladimir Lypak <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 1/1] net: wireless: ath: wcn36xx: add support for pronto-v3
References: <20230311150647.22935-1-sireeshkodali1@gmail.com>
        <20230311150647.22935-2-sireeshkodali1@gmail.com>
Date:   Mon, 13 Mar 2023 07:52:54 +0200
In-Reply-To: <20230311150647.22935-2-sireeshkodali1@gmail.com> (Sireesh
        Kodali's message of "Sat, 11 Mar 2023 20:36:47 +0530")
Message-ID: <87y1o1xknd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sireesh Kodali <sireeshkodali1@gmail.com> writes:

> From: Vladimir Lypak <vladimir.lypak@gmail.com>
>
> Pronto v3 has a different DXE address than prior Pronto versions. This
> patch changes the macro to return the correct register address based on
> the pronto version.
>
> Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/dxe.c     | 23 +++++++++++-----------
>  drivers/net/wireless/ath/wcn36xx/dxe.h     |  4 ++--
>  drivers/net/wireless/ath/wcn36xx/main.c    |  1 +
>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
>  4 files changed, 16 insertions(+), 13 deletions(-)

The title should be:

wifi: wcn36xx: add support for pronto-v3

I can fix that, no need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
