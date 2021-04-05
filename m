Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AD353C3E
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 09:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhDEHtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 03:49:14 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:46644 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbhDEHtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 03:49:14 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2021 03:49:13 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1617608393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5uVHC4wQ6FlbPBFZq+nqEhyjmvDRykRRhBKERQcVG6A=;
        b=NDu0LxfH73CCJvWmPe7jTRIghdpSBGm3/zPjF5YNq4CAKtxiAvSJq+5YGEnAsCuxEvPrcA
        NVr7HJfhbqdJl3PCR19bkpsvMHX5Y2sr4QCsyJnWuPmyDdeNc5KYemsSfpGYHBXxj8n3yY
        DEbEo4kJvpd4wqp68eri5S1CW6OIP1c=
From:   Sven Eckelmann <sven@narfation.org>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date:   Mon, 05 Apr 2021 09:39:50 +0200
Message-ID: <6915766.LLSpSeZOKX@sven-l14>
In-Reply-To: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2830896.hENeXy47Wg"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2830896.hENeXy47Wg
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: netdev@vger.kernel.org, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date: Mon, 05 Apr 2021 09:39:50 +0200
Message-ID: <6915766.LLSpSeZOKX@sven-l14>
In-Reply-To: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp>

On Monday, 5 April 2021 07:33:06 CEST Tetsuo Handa wrote:
[...]
> ---
>  net/batman-adv/translation-table.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
> index f8761281aab0..eb82576557e6 100644
> --- a/net/batman-adv/translation-table.c
> +++ b/net/batman-adv/translation-table.c
> @@ -973,6 +973,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
>  
>  		tt_vlan->vid = htons(vlan->vid);
>  		tt_vlan->crc = htonl(vlan->tt.crc);
> +		tt_vlan->reserved = 0;
>  
>  		tt_vlan++;
>  	}
> 

Thanks but this patch is incomplete. Please also fix 
batadv_tt_prepare_tvlv_global_data (exactly the same way)

Kind regards,
	Sven

--nextPart2830896.hENeXy47Wg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmBqvsYACgkQXYcKB8Em
e0Yusg/6AxfjdXLgogTL2mANdd/Nz7SOoKHtXAVupSewoAmqil8GyFf5cNWHgphS
RuWWfoloFT5qiFUAI17z6e0h6SkbSUP3XYp8epkzDIyzA09NersxqBX4GKsy71fJ
BO2k49RWysrn1F+Pq6e65HBMgjLMfgaa198kZKSRv3aeI2N9G6juI18fxvAEbp5i
6j716OHHp7n4lAX7jfYDUlCCJhpKDC/rQRg9c5rDH+PrwG6ZlJCZsGPTbwuWbPl8
VdS5sg9qIQPycCld6DNUUKfwPFC5zB7/Ru27ItB8u0z3ndL8t6VhxKZ9Leo+bYgC
lUbFJiDEfI9oBOLW0nAVYRDy2+ZRoKcyh9V2YwpmRFQHt8P4UQFxXPZiYTI+SuCd
U5iDIu9z35GpyiMJ2lSZsTbbuu2vqjLpwESDzZis9oC4dSwKVDvNIjGQVpWlFXgh
2krd2NwZ/UrXsIPMjtuEfntxuwtPERN5iGs8+eiGXV8eyd4YL9/olT116wfLiZun
uLEdqVywJ0jKBlYEvzSjKY+0OFiFesRk+xnqrkEVNY9o+sM8OOeaZQGwo6DuQ4Ib
YeAjgQP3UqRKIlLdWP+j8uUCZh9/fhjyPqEt3MbVzTpjRO+kT8UE387D60tdcqjD
JyoHpDzpBDyYdnwIQR/sLdmX4WLHT3S2D/d99kh7r9DQW2AMKy4=
=VqOn
-----END PGP SIGNATURE-----

--nextPart2830896.hENeXy47Wg--



