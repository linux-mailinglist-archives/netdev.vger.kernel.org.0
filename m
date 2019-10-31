Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE7EB4F4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfJaQpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:45:46 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:56938 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJaQpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1572540344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u+tUIBYHKvIkuL4G7fc5AXLA5rHt3MekdCaxn1sE414=;
        b=P4vIvrUd4lipMC3PeEFVUQRsUdQPvM6OSOh/PPMV99gRQ+QAiB5CWAmb9kdnSDU56Tlu9c
        Y5b0ky0JpNSjnnBed6B/UlAxMbbbS7CozSdxZCD3QlzcxEKlcM6tZLZgdIL0LFO6mN0t9z
        Rzj4PgXZIeN+q4U/b9ONfNCv8p6rICw=
From:   Sven Eckelmann <sven@narfation.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] batman-adv: Axe 'aggr_list_lock'
Date:   Thu, 31 Oct 2019 17:45:40 +0100
Message-ID: <34947339.t7yNZRQCJl@sven-edge>
In-Reply-To: <20191031085240.7116-1-christophe.jaillet@wanadoo.fr>
References: <20191031085240.7116-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1950623.Tr5mk9XeTM"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1950623.Tr5mk9XeTM
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, 31 October 2019 09:52:40 CET Christophe JAILLET wrote:
> 'aggr_list.lock' can safely be used in place of another explicit spinlock
> when access to 'aggr_list' has to be guarded.
> 
> This avoids to take 2 locks, knowing that the 2nd one is always successful.
> 
> Now that the 'aggr_list.lock' is handled explicitly, the lock-free
> __sbk_something() variants should be used when dealing with 'aggr_list'.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only.

Applied together with your other patch.

Thanks,
	Sven

--nextPart1950623.Tr5mk9XeTM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl27D7QACgkQXYcKB8Em
e0ZQrhAAwKtHzM6URp++7gAYx8jfbNu1SHKYF4CFTq0mjqjQZBLuZaWg8eYALQDa
Quv7JVBrkEog8zGs8k9mqnL8TfgXvwKQvmvhHV4eecC/slqSn0wF+VzSdaUY3CXG
BHCtj8kbiu0dmBPHt31agMDjNBoyF6UwhIT1SK1C8UfJq+Rsc3hUXxmPwm7BX8rU
dzTeUTpZ+BmIVFWlnvcNYMNTmwM8U7NLZ/rpHXw+gsOFcA5F7+ven4L+2wTmutJL
IGAhrIuGZsEhYe+xu7WRahNed8CcoeeU//qg6E6JKNETE27sf4tgzQbsQmSWAqgf
dbm2LSby6BCdYUTYkDmQR3Ds6pNbUfg2jyhliNCrDtsvn5MMiR4RaXl0pkEoEt+v
/EK3jrAR13mUcAcelIJrHOG0HzhX+vVGLySKegGoM5mElltIxQ3g/9hnGUvtU6t4
JvHdQZARYGuMDGK2U9fDSO9dMVr+qq20PX3hNacE6U6Q7uknW9H2jHfmv/hg0bJO
DjfcXdYuBw4qEPdPCRFEUkDJLvGrXBnfKqkHjARHK4DBdyWRBl5mT4lppgT5wcCk
KWxvT9ImoWFiDAeJAMVzXyYMrYny6vqyMTgebMz98K666ue6e34znyY4cCj2kY8O
iy5kw2J7v0u30kwHd/fdota1yKA0j28TVTDxmjyEEhZWhyb4bzA=
=Hpom
-----END PGP SIGNATURE-----

--nextPart1950623.Tr5mk9XeTM--



