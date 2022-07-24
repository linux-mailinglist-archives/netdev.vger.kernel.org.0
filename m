Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8777557F73A
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 23:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiGXVkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 17:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXVkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 17:40:46 -0400
X-Greylist: delayed 568 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 24 Jul 2022 14:40:44 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EE6DFFC;
        Sun, 24 Jul 2022 14:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1658698271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=STY0G7UjVAsIewBHvisrVxnFHtCqH1f3rEMAP8NVJFo=;
        b=yYZ8RmsB9S2snpK16i15T2CYsHd+vHUjG/L9+m0nyQR/JcdLzo92upn7/r5gHo6okNIpzE
        6p0H27apnA6z5MpPcuEAVCgPC2WkdGvuPA6M4vPVmC4DOgOaDAaBUYowGA9ebIQeOijIzk
        VHq5PObcAVmxH5lO6MtunZWHmYrMTHU=
From:   Sven Eckelmann <sven@narfation.org>
To:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: Re: [for-next][PATCH 17/23] batman-adv: tracing: Use the new __vstring() helper
Date:   Sun, 24 Jul 2022 23:31:01 +0200
Message-ID: <8828005.nfsgNN4c79@sven-l14>
In-Reply-To: <20220714164331.060725040@goodmis.org>
References: <20220714164256.403842845@goodmis.org> <20220714164331.060725040@goodmis.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5204823.eLehfEbLRh"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5204823.eLehfEbLRh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: Re: [for-next][PATCH 17/23] batman-adv: tracing: Use the new __vstring() helper
Date: Sun, 24 Jul 2022 23:31:01 +0200
Message-ID: <8828005.nfsgNN4c79@sven-l14>
In-Reply-To: <20220714164331.060725040@goodmis.org>
References: <20220714164256.403842845@goodmis.org> <20220714164331.060725040@goodmis.org>

On Thursday, 14 July 2022 18:43:13 CEST Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Instead of open coding a __dynamic_array() with a fixed length (which
> defeats the purpose of the dynamic array in the first place).

Please also make sure to remove the define of BATADV_MAX_MSG_LEN

Kind regards,
	Sven

[...]
> --- a/net/batman-adv/trace.h
> +++ b/net/batman-adv/trace.h
> @@ -40,16 +40,13 @@ TRACE_EVENT(batadv_dbg,
>  	    TP_STRUCT__entry(
>  		    __string(device, bat_priv->soft_iface->name)
>  		    __string(driver, KBUILD_MODNAME)
> -		    __dynamic_array(char, msg, BATADV_MAX_MSG_LEN)
> +		    __vstring(msg, vaf->fmt, vaf->va)
>  	    ),
>  
>  	    TP_fast_assign(
>  		    __assign_str(device, bat_priv->soft_iface->name);
>  		    __assign_str(driver, KBUILD_MODNAME);
> -		    WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
> -					   BATADV_MAX_MSG_LEN,
> -					   vaf->fmt,
> -					   *vaf->va) >= BATADV_MAX_MSG_LEN);
> +		    __assign_vstr(msg, vaf->fmt, vaf->va);
>  	    ),
>  
>  	    TP_printk(
> 


--nextPart5204823.eLehfEbLRh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmLduhUACgkQXYcKB8Em
e0aflhAAnq0E/OqKeySsgXxGHV1QJ+JeXQfRRXBGdw2v8gJsyCJK6Iq8FohqBmO9
YuNWRE6uw/ZRAdPgx5JqQTuxYVFP/dE0L47RxPviqNAsYJPuRmYNl8AXC9SOJZjq
H1rRbDqVSI8ougx2Z9RH8PnNALSfDjvghQ8t+K3yiVbocdRETwQHvDs4zCD+dJb6
97BXrLlRL41O4U5g25NXpx/OD3PL8aHJsZEF/JkbzSKv3ElyHxiyy3bLnaqYZXOJ
626kdHpgOFHvdun7em66j+l1o9BX97qLdPVkKSe4FCkJvBWH4uy1S8td1+vwrvDm
USDg5WjcvmwsiyqOhNcXLJ/kW5s2PAOdgHZCqYLRn1IdzpbaQA2kX17Rhl+JHoE9
Xj0JPYg409jYFZbVywXdt+BXc3+FGyaxDEMuCke9Er2cslMdEofSwq2XBBlKFAzp
3u3+rX2MgXIyRE7HBiDBlLtCF9rf1qgoXpwztl7Vvkv9AebuEk/igGNKSJW+mRI1
wwqNeKMfsDA+F4lhwlTZzsZzRoxW078Ex7kLqkWoVqM/CTTUaQagc8aUq92YwTll
IUe7PGYVsPketoVWq3EQcvyorWY9QGnuKVxNv0Sgjr+pp4ez0BhK6um40cCRQ6s8
AmTz/TaDt6D7RowsR5k36ymSJ5SNR2cbc2TwZHABSBhdazxVcPc=
=jX4Z
-----END PGP SIGNATURE-----

--nextPart5204823.eLehfEbLRh--



