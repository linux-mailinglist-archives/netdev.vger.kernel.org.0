Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697AE483AE8
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiADDRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiADDRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08D8C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 19:17:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E67BAB8103C
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 03:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFF4C36AEF;
        Tue,  4 Jan 2022 03:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641266256;
        bh=Pu2jhiryVLh3Rpdgt4350Uq/lwq6dFoNICqVX3Dk9i4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lj6kkXFEPFoG1A+4V9LmuyATjM2ybpLgaCyBAJMYBppdr1aNRYLAwffyGsGaWO0cR
         xvnrzGeB4lpJbCwu9t4J+jO7HCjOa8fQw47oUHjfIP8LWfLmlfWdF8HuahtW9J4nwx
         y1zS2DBNl2ILDxXsKJjCPsvul6k7BLUU0JJAKCq3LZsAyG6p6jeWV296C1Y8AGBec7
         w34G1UgWvDl06XuqIRLb26Cza8OYkFZwXU/eKfa70/x8d1g+YtlFEQY+jslhL3nQUC
         DwgTBcOdyNIKSzRNksalnhpz8Z6yaLd/ymj6voSbkMwzr1668q4k0ipgpOPz9R5Kag
         T9gyuYTcUEyRg==
Date:   Mon, 3 Jan 2022 19:17:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v3 8/8] net/fungible: Kconfig, Makefiles, and
 MAINTAINERS
Message-ID: <20220103190838.102886d5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104010933.1770777-9-dmichail@fungible.com>
References: <20220104010933.1770777-1-dmichail@fungible.com>
        <20220104010933.1770777-9-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jan 2022 17:09:33 -0800 Dimitris Michailidis wrote:
> Hook up the new driver to configuration and build.

bpf-next merge brought in some changes last week:

drivers/net/ethernet/fungible/funeth/funeth_rx.c:180:17: error: too few arg=
uments to function =E2=80=98bpf_warn_invalid_xdp_action=E2=80=99
  180 |                 bpf_warn_invalid_xdp_action(act);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
