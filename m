Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B0E6A4FAF
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 00:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjB0XfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 18:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjB0XfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 18:35:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430E623321;
        Mon, 27 Feb 2023 15:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6A2AB80C94;
        Mon, 27 Feb 2023 23:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A5CC433EF;
        Mon, 27 Feb 2023 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677540904;
        bh=1utzo10uAmMF/26nJZf2EhfUMs6ZWXfW3bGazBQ+oR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IxDESo6p78DEc2xrjH44dO6Rvu5BFSD0/YufMoLBkYiH3Wu3V3+RT4qYjhaBUfSfb
         3qFFCl+FooJHouSg+7fBZzbwvUNrdBlc6z3SfLs+5AJz1ishoJTAl2g485oPAmsFmv
         e+h5kLIqQ0yYrb8pcKm/0nzBKwD+5WtPKulU6eXlEDfr7w6SH7tvqWuEi9+ICr5J3x
         pCum5p60LUbPrrp+xYYN92NvSf8iibCjb/OEYFxdZ3/qrZWjJkSsqHOKqLReltQIEH
         KXsUvU2h8sPbNFuBtlOqdW+mMeldD3xyDMzBTIiAX1yRpy88RQeGjHMK/SoQXU1N7Z
         zIDz4AMZ9eg6Q==
Date:   Mon, 27 Feb 2023 15:35:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Rix <trix@redhat.com>
Cc:     Juergen Gross <jgross@suse.com>, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netback: remove unused variables pending_idx and
 index
Message-ID: <20230227153503.3bc54eaf@kernel.org>
In-Reply-To: <f3f8584e-e97d-abe9-5749-da5bf3587a57@suse.com>
References: <20230226163429.2351600-1-trix@redhat.com>
        <f3f8584e-e97d-abe9-5749-da5bf3587a57@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Feb 2023 09:29:30 +0100 Juergen Gross wrote:
> On 26.02.23 17:34, Tom Rix wrote:
> > building with gcc and W=3D1 reports
> > drivers/net/xen-netback/netback.c:886:21: error: variable
> >    =E2=80=98pending_idx=E2=80=99 set but not used [-Werror=3Dunused-but=
-set-variable]
> >    886 |                 u16 pending_idx;
> >        |                     ^~~~~~~~~~~
> >=20
> > pending_idx is not used so remove it.  Since index was only
> > used to set pending_idx, remove index as well.
> >=20
> > Signed-off-by: Tom Rix <trix@redhat.com> =20
>=20
> Reviewed-by: Juergen Gross <jgross@suse.com>

Applied, thanks!
