Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BECCD0E0F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfJILyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:54:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51662 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfJILyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:54:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so2227673wme.1;
        Wed, 09 Oct 2019 04:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K8xuIIKxM4jr1Ezc8qWxiUcuTrmdodaACnbuRgrOwy4=;
        b=GxeHshJj+pdQQGjLZMzMN4EUBZaXzB04GuP45+JvMpVKsr3ERgg4f1ZQEsslNFQgVV
         5fdzzDUW1CKqZD7zcCNIogsT5shD3oQG/dKx9UAXikI4JgTgn9UYj7XkluVRFNbB0Tz7
         TUaxxYn3QH0oHUo/tMnl6EAP13Ze+HSDtziaHGgvnjKvEcqX4zFh74vIAB5wdfeOuux/
         ppK7L2kobeIinaHOPQtgDHv7O3MgN6NWhMon6AVidemhPFfqAwzO9A81fx8zR/1bBnV3
         QbcnoA00+0ZVLHd+lii0sTPxLS87csmc4par/EdmeSMwPC1qihpecG587Ol6WNNgH4qX
         e8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K8xuIIKxM4jr1Ezc8qWxiUcuTrmdodaACnbuRgrOwy4=;
        b=VkvkdFh5ffgq55C5USts+CFt0HZVVu8tRmmUKJBRWMxztQvW7s/HhkStXX6eb7hvnm
         RfGs3safhSiWGTDRvffKf+f8v4gLmQr+RQCsq3rAuXjNbLUBptrEQQKualatU5uGX5If
         aiwC0MUkVLCUOnIWiO53vvNgRBS7iOaX/sHrzUjIX/yHo0bc/axz0IKdPtgXz2qm8wvf
         L7S7mC/IsaDhorVmxB/wuZqssdT0eKtBD+gfTwsnOMtG54bXRSu6Pnf+4/HOuT5ysVVZ
         m6rD3zkfNgJUtrVjRfL4GjitqhMZEuwfV2uSF9iTqSliUQ6ZmPY9L+LbY4NbkcbeoUpJ
         Aa5g==
X-Gm-Message-State: APjAAAU/brntEcn1REL8m8fLOYdy+vYVG7lMVGtnQqk8FppTw2NYTj9m
        hnJ2+2cx/A2enGdsgFEfCLOJTn5ay3k=
X-Google-Smtp-Source: APXvYqwzyNhjFy4mMbFEikZ//E8PDfqotwLY5TpxA1ZDPjhg8ZiTa057fShpgEBfYZvhww31eMEocQ==
X-Received: by 2002:a7b:c049:: with SMTP id u9mr2276879wmc.12.1570622075184;
        Wed, 09 Oct 2019 04:54:35 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id z9sm1734307wrp.26.2019.10.09.04.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:54:34 -0700 (PDT)
Date:   Wed, 9 Oct 2019 12:54:33 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 06/13] vsock: add 'struct vsock_sock *' param to
 vsock_core_get_transport()
Message-ID: <20191009115433.GG5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-7-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S5HS5MvDw4DmbRmb"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-7-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--S5HS5MvDw4DmbRmb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2019 at 01:26:56PM +0200, Stefano Garzarella wrote:
> -const struct vsock_transport *vsock_core_get_transport(void)
> +const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk)
>  {
>  	/* vsock_register_mutex not taken since only the transport uses this
>  	 * function and only while registered.
>  	 */
> -	return transport_single;

This comment is about protecting transport_single.  It no longer applies
when using vsk->transport.  Please drop it.

Otherwise:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--S5HS5MvDw4DmbRmb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2dyngACgkQnKSrs4Gr
c8jpGwf+OKGaK9OPf0rceIKo+5pdDJMkf+lhw9ooooqK7bZFZkqZFYhUYOP9qYqk
iPKeaY6YWLpuWMJRuh2EObxLrC1VrmfYA1lPcNXDEq6yVOloX43zrBM5Zec2GVq3
GVJHTW2tw1bTyRAtLI/zSYy9hblQlWcG6BKmK1WBNFIyQ9JLGvRqFGKobpJPP2LS
/7z3MWkRsZkFTUnJGocbhjbkZk2dLUwY9cy/IrOzfPAgX79WB7DSl7RpjH/hx7+b
M8cDi9WDJ53vRN81sXNSHg8JQA3x+DoErU3TdY1sTxSyHqcZiPgI13LXZmIw3wSS
W8aTJLNML/vAaTn6rvoGHkQXwt3Izw==
=2X/V
-----END PGP SIGNATURE-----

--S5HS5MvDw4DmbRmb--
