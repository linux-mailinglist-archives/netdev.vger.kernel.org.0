Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300FB57FA4F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiGYHeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiGYHeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:34:08 -0400
X-Greylist: delayed 36172 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Jul 2022 00:34:06 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB25D12082;
        Mon, 25 Jul 2022 00:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1658734444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V6Vf2jAltQTipO89H4jWJtpPrrxkmjRYpJzgCKIpSjc=;
        b=aE9rdpdnJp0XGhoj+EVCPaQdSHqT4XThP85IOwkxY0e4GyNl0Lunqc9JWSAz3PFzDtJrS7
        oEQ7mhkkYF+kkbQiXnmnsqNgXaV3yjvfv9CMc8+1xedtIoVpyzDpNCtbTADzG4ka4/tmCD
        KeAhU68Wk7YiiAQDk4EYNZY3FjjowgE=
From:   Sven Eckelmann <sven@narfation.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: [PATCH v2] batman-adv: tracing: Use the new __vstring() helper
Date:   Mon, 25 Jul 2022 09:33:56 +0200
Message-ID: <3133019.BU9PzZYyX2@ripper>
In-Reply-To: <20220724191650.236b1355@rorschach.local.home>
References: <20220724191650.236b1355@rorschach.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2457081.NBQ8aREyQt"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2457081.NBQ8aREyQt
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] batman-adv: tracing: Use the new __vstring() helper
Date: Mon, 25 Jul 2022 09:33:56 +0200
Message-ID: <3133019.BU9PzZYyX2@ripper>
In-Reply-To: <20220724191650.236b1355@rorschach.local.home>
References: <20220724191650.236b1355@rorschach.local.home>

On Monday, 25 July 2022 01:16:50 CEST Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Instead of open coding a __dynamic_array() with a fixed length (which
> defeats the purpose of the dynamic array in the first place). Use the new
> __vstring() helper that will use a va_list and only write enough of the
> string into the ring buffer that is needed.

Acked-by: Sven Eckelmann <sven@narfation.org>

(and sorry for taking such a long time to respond to the v1 version of the 
patch).

> ---
> Changes since v1:  https://lkml.kernel.org/r/20220705224751.080390002@goodmis.org
> 
>  - Removed no longer used BATADV_MAX_MSG_LEN
> 
>  net/batman-adv/trace.h | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/net/batman-adv/trace.h b/net/batman-adv/trace.h
> index d673ebdd0426..31c8f922651d 100644
> --- a/net/batman-adv/trace.h
> +++ b/net/batman-adv/trace.h
> @@ -28,8 +28,6 @@
>  
>  #endif /* CONFIG_BATMAN_ADV_TRACING */
>  
> -#define BATADV_MAX_MSG_LEN	256
> -
>  TRACE_EVENT(batadv_dbg,
>  
>  	    TP_PROTO(struct batadv_priv *bat_priv,
> @@ -40,16 +38,13 @@ TRACE_EVENT(batadv_dbg,
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


--nextPart2457081.NBQ8aREyQt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmLeR2QACgkQXYcKB8Em
e0b++BAA1XfqNG8IgHveLdrDXzvP9gh02aQZJljfpbrrsVoc4G4wUNFttNnxxY62
fcFyFXGm4UXe0QxcgW2H0oazYxwOBP68I80Q5kqAPzeVyWny9piJ3Gk0izE0x5St
uM7nIs3GO+uAF2qEKjAJIvf8V/RzBt+ZSjqiS1rFXw8uSwB//3mhuoO8rLvzT4Sz
GfRkx8P+YvYHERQDJiFd8jco5an1zNJcM6SA//XfIfg2onaI07aO11fJ+izIRvyo
nP6bwmQSp3ct/6ESTfzVqEk6EluYIR3g20n7j6qHZp9PylMKzKg2Vi6Tjuh2ATpf
EEhTHB9m5EjANyX/tmRllLetsRTq9sw5Nvgd+RaUYZPhJFDfSnRPDtELCZknkD4F
kfA95tY3/YHwsyw+/yP2CSK68tSIleR2dZHWFeMUoC9xxE3tX7VpZjv2fWhhOZ9X
upX9AyS21y/i++eWHPn4YGjMSkxP9zuMAzNK6gvFEgeA69CdnKovwph4zv6+5pca
RFQrVImbU81RkQaTihFrZPGVosc8/uNRpOkJ3a5k6jTRtV8NquAKjjVGfClGU6zC
1oJCpK4z7542bGU29BGTXOEKzp0H/VhynrSmFEO8aukEsPsNvBjjz/7FIfiLTg6s
H1yEZdH0ovjpAi4jieIBJs1wh9Q5wCrjJK52+pyw5LHB7s+7wko=
=i8q+
-----END PGP SIGNATURE-----

--nextPart2457081.NBQ8aREyQt--



