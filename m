Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AB3104F87
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKUJqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:46:21 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35309 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUJqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:46:20 -0500
Received: by mail-wm1-f65.google.com with SMTP id 8so2930396wmo.0;
        Thu, 21 Nov 2019 01:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zq604zfFYaP1lg3EZmX/ZaHb/wgc+8oQ8qyObi+Xugk=;
        b=EqWQIKk+Pc+6l/iTZqHgRlRZKxdn4V5MLvDyH0ww5S+V+fMSCiyEKuvRNjME92kpzR
         xcVvIZLkVoemqT088j6zTquIIRlUtFPaJuPbj1gRvRqz9mkwPyu9vQ6n8z+t2yM32vCz
         pDquaI0iz8FNlE2lh/MIGSO4oj+ofk8tt9/yAQbbgYHMgE+uXnFhDEaOF55hmhCeo6gZ
         LqyQHu1s+IZNMbJwy0SkDh4yiE8HuRicUZlJt7NAsuUyMRaekXE7UDU7Rx6NE/3Efqhc
         grH+DPrIOumY2l92QPIrd6f2xxrX25HXk1PnobD//XAPU3rxd+ttp1nIZ8rmAVLfSebm
         3s0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zq604zfFYaP1lg3EZmX/ZaHb/wgc+8oQ8qyObi+Xugk=;
        b=AM6K2jmbaSoUD1F4Szq71VAX+xRT8cY3f2NmD+rFgLyQu/4lteks7icnqhcVB9bKBj
         3BwJQu48gLTmLwP2MqpkXoV8YokyUGAKdSR2/9N2HkA5hWZrBtxieZ/fZ8ZVWITq/h1Z
         1qdU1QtLWjxbAiqq1+7rSjdjBUJKFpcEuY9K4Z8TXkanEzyTpZ/J3x/cvgIOOo1rf+0S
         AnZofn04Da+Hl1g7QVdZsYu4CTTfJLNf9FdWe9UK5HBDKdCKb48cl6qnHWDrc5kFkKff
         +WzuNpNvuh6WBov5+SyMUWyZAPh84G1B/sI49vqKl0//jg7OPlNNYgUb1c5w25uzyEs9
         Kv9A==
X-Gm-Message-State: APjAAAVgfqFQ6b+bUgUqKe1TgrWOIm05idTZC42dhy7o8Rcxz9XWJeyW
        KrvLwai52/XERqvlKvS2NElskpV6qvI=
X-Google-Smtp-Source: APXvYqyZ8t14KdyBL7WZHEesuhWgOkStCUSzngEXJC35eulov2avg9DZSJMo7BWYsnIIGFoYvTWJJg==
X-Received: by 2002:a1c:a406:: with SMTP id n6mr9076240wme.90.1574329576856;
        Thu, 21 Nov 2019 01:46:16 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id i203sm1972471wma.35.2019.11.21.01.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 01:46:15 -0800 (PST)
Date:   Thu, 21 Nov 2019 09:46:14 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 5/6] vsock: use local transport when it is loaded
Message-ID: <20191121094614.GC439743@stefanha-x1.localdomain>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-6-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <20191119110121.14480-6-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2019 at 12:01:20PM +0100, Stefano Garzarella wrote:
> @@ -420,9 +436,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>  		new_transport = transport_dgram;
>  		break;
>  	case SOCK_STREAM:
> -		if (remote_cid <= VMADDR_CID_HOST ||
> -		    (transport_g2h &&
> -		     remote_cid == transport_g2h->get_local_cid()))
> +		if (vsock_use_local_transport(remote_cid))
> +			new_transport = transport_local;
> +		else if (remote_cid == VMADDR_CID_HOST ||
> +			 remote_cid == VMADDR_CID_HYPERVISOR)
>  			new_transport = transport_g2h;
>  		else
>  			new_transport = transport_h2g;

We used to send VMADDR_CID_RESERVED to the host.  Now we send
VMADDR_CID_RESERVED (LOCAL) to the guest when there is no
transport_local loaded?

If this is correct, is there a justification for this change?  It seems
safest to retain existing behavior.

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3WXOYACgkQnKSrs4Gr
c8iT+Qf9ESuEFX++6Sq/wJtYnpiX6cvGw7bvw+fxkdiksMzIPBWT6ZbC/ZrRv87z
zBMNmGrLElTPu3lN4ISYgd1gjrLn1iTTnkj/A42X5VvjEqfQYXNz84gBMP7jRcxo
XufjkgajBvxcssZgAPOAMjx/4BbGlW3cwUNoTa7oy9PCQlhBPVDvqPWSM4sQ61cP
GJ2hFaCeYTmCbYKnyrvqmoXIewMF1XAjAuuXSHz7zVlCpbHL21piJByTKAUnqL7N
6W6nMibNjso9qI0AYAOsCkFRnhIshBqRhRhO96/1ZEBmLe7kH6gXYpgScRs4IRYD
V7w4kz76mzwiZZZLiW4/K5FOBe8v9Q==
=HSd8
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
