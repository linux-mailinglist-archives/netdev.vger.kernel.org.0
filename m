Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9AA354112
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbhDEKHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 06:07:01 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49582 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbhDEKHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 06:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1617617213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XbUClHyNVcrpyxtLGnmQfRsXLJPQQq7/WW7r7YRB4U8=;
        b=xmgycBd6jFwJGIyZ0fTL+ZYgns1dXgFWcxQ7KEF0KrviJ3DrpA4NxXEQDle4f87bzvBpih
        9vbCZPPXtKrqz9mCRC1XBWxAJ94xDJd7GVxvcauQKr58nhqjQDLmEoCAsYGIVBl6EMmrSJ
        M05QBAa5u1f0ISJMVIAA0cfQB9RuUn0=
From:   Sven Eckelmann <sven@narfation.org>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date:   Mon, 05 Apr 2021 12:06:40 +0200
Message-ID: <8010915.lm9TqgPHxW@sven-l14>
In-Reply-To: <b98babbe-eb85-2b78-d7a4-d3ac6cda5e5b@i-love.sakura.ne.jp>
References: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp> <6915766.LLSpSeZOKX@sven-l14> <b98babbe-eb85-2b78-d7a4-d3ac6cda5e5b@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3037839.BsjkTRi589"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3037839.BsjkTRi589
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date: Mon, 05 Apr 2021 12:06:40 +0200
Message-ID: <8010915.lm9TqgPHxW@sven-l14>
In-Reply-To: <b98babbe-eb85-2b78-d7a4-d3ac6cda5e5b@i-love.sakura.ne.jp>
References: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp> <6915766.LLSpSeZOKX@sven-l14> <b98babbe-eb85-2b78-d7a4-d3ac6cda5e5b@i-love.sakura.ne.jp>

On Monday, 5 April 2021 12:02:02 CEST Tetsuo Handa wrote:
[...]
> > Thanks but this patch is incomplete. Please also fix 
> > batadv_tt_prepare_tvlv_global_data (exactly the same way)
> 
> Indeed. Hmm, batadv_send_tt_request() is already using kzalloc().
> Which approach ( "->reserved = 0" or "kzalloc()") do you prefer for
> batadv_tt_prepare_tvlv_global_data() and batadv_tt_prepare_tvlv_local_data() ?


Lets stick with the approach you've used in your v1 version  - "->reserved = 0"

Kind regards,
	Sven
--nextPart3037839.BsjkTRi589
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmBq4TAACgkQXYcKB8Em
e0YECw//YNoDX1Tn+ziyePJtIE2EapUiR/gDV3yPPeNI4/zlp8MHcdVowEEvM+gK
cZsj/KscJ7Wm2ysf3xfzOvZFnKC5FGRZhgdTBtVSPaPY3SE90W3UHG12mkDXx+86
mDIYmNhHZQr6XNpQ7bFkri2e8kHGWDCWOU1a0homGSaGHXu0pbEL3IWfkpvm7Q84
PPa5wqSvpX6b3CREo6g7B3h2TlryEFHuKgV/g0Q5AVPlk1hw+DPb+Ay1maX/ZXu3
sb6f+hau2Q6q5m9rSRud/2zeFY0OgVed+s0CjZ2RMpXNgPi0J1e/x1vN+73VobTW
jY814qkLWGAEcP8CbHsHhW4PwDL2sTnRVuPElV130I9/oddSey6fBUCs6LjVr5Sf
rs0Im1Lkd2wbQYa7Z89Xi8CuzLy/6UoHlRdEEF1TxfFDAM3rpdsG004BI+iH9qG1
a2Sn/YO0QghqgDximniltSOA8XP85b9+5NQdqOvj7zThlIssnjjhalg2FHWdzfim
6sVShcIUTy1RI9Y/x2VMQ2iqIi53UvAJlHf6swQI9jt5dgUEDzcYFtWrA8IlOFau
YTtDWq5xDRJ4ayAZNo4m9SqokPhG1M8rssRVH3xbc1M1bRjyEts1CXwEB6l/NVTa
zwXaxRHt95tfaVkmLFw6YZI5G+Aqkrpt/kS+daAzl+cAwGjAd1Q=
=ZL1p
-----END PGP SIGNATURE-----

--nextPart3037839.BsjkTRi589--



