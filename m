Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852911B2B77
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgDUPmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726043AbgDUPmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 11:42:53 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770B9C061A10;
        Tue, 21 Apr 2020 08:42:51 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id u13so16992646wrp.3;
        Tue, 21 Apr 2020 08:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=smCulfeM0i6IfFInFyIPYZ1woXDKmy7XMohFywAgL4M=;
        b=onCE8a9sWDTMpHJ5MLfvbv+ZBUE9S/7Cs3Xj9v4QkmAOq146uMO5Q88FIh8aXfQI5Y
         S5YfUqv+qeERvhQWTYVuY3JFHiVAHuW3PkT9/FFhAFrpc0JdmvZS/pM/knaJqY134q8d
         e9aS1UdmHDsVjdyyXVBIirNFNxefJ+GJ/M4zBG3bBftaJzoMOBcicD44bKlI22xHawvX
         Jr0rfBxUllcL0/m985SIa/9kUhDjqPhwWxSwSPS809RIT/w6F3avUqO09VZQopgtm7SM
         NAyszST8DbAVDFgcqYB9jWb2BAi0byTeYKdvhOOtay3WGhEB1OWQLf/9bs8UkV3Z3TKr
         nZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=smCulfeM0i6IfFInFyIPYZ1woXDKmy7XMohFywAgL4M=;
        b=UXgG1vdHycWVsaA4cIpRepZf4cybBIF2iZF7Cn29yl7wUJghmUkJZN3+oBHpIPyflc
         wrcbCeVaAcgz4LOpMSbbyeNPeIeloY+hJfwI9PqlCBCUXgkOTIVN/NxGH4B1HIGdF8C/
         RqBRq+gwFB72h6OMEAoEl8hMZ/jSYwJbLfn8QxxPR0yvYdjeYKF1TmaKGA2ryCOty5R/
         muhbbOIdKiSnMNUgKjj+LE1OG+l40BwOT+t516fKqgLUapfsHIuV454SRQxM6zFWgcvI
         KTVMjyjvxq5Hpxd3Vy1CF/BCWHNrGedoF7oH3jeK7fW1K7bR4w4YT4XoiMuijUEQ/reA
         buyw==
X-Gm-Message-State: AGi0Pube5k/d55r+PMhXDhqYTC1BzT73o5DR65kdDg3b19FVJvw0ZPgO
        rDGSrwiFydZabQ+7YjXoz+k=
X-Google-Smtp-Source: APiQypLxhyUQuMLlC/lZYEOaNY6oE6EnQ7qLe9/IuAI2gTFFfZgl+/1BfhPKJow73lUllSKMMFd6mA==
X-Received: by 2002:adf:e7ca:: with SMTP id e10mr25267486wrn.18.1587483770237;
        Tue, 21 Apr 2020 08:42:50 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id a20sm4428579wra.26.2020.04.21.08.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 08:42:48 -0700 (PDT)
Date:   Tue, 21 Apr 2020 16:42:46 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, Gerard Garcia <ggarcia@abra.uab.cat>,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] vsock/virtio: postpone packet delivery to monitoring
 devices
Message-ID: <20200421154246.GA47385@stefanha-x1.localdomain>
References: <20200421092527.41651-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20200421092527.41651-1-sgarzare@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2020 at 11:25:27AM +0200, Stefano Garzarella wrote:
> We delivering packets to monitoring devices, before to check if
> the virtqueue has enough space.

"We [are] delivering packets" and "before to check" -> "before
checking".  Perhaps it can be rewritten as:

  Packets are delivered to monitoring devices before checking if the
  virtqueue has enough space.

>=20
> If the virtqueue is full, the transmitting packet is queued up
> and it will be sent in the next iteration. This causes the same
> packet to be delivered multiple times to monitoring devices.
>=20
> This patch fixes this issue, postponing the packet delivery
> to monitoring devices, only when it is properly queued in the

s/,//

> virqueue.

s/virqueue/virtqueue/

> @@ -137,6 +135,11 @@ virtio_transport_send_pkt_work(struct work_struct *w=
ork)
>  			break;
>  		}
> =20
> +		/* Deliver to monitoring devices all correctly transmitted
> +		 * packets.
> +		 */
> +		virtio_transport_deliver_tap_pkt(pkt);
> +

The device may see the tx packet and therefore receive a reply to it
before we can call virtio_transport_deliver_tap_pkt().  Does this mean
that replies can now appear in the packet capture before the transmitted
packet?

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6fFHYACgkQnKSrs4Gr
c8gyawf/T+a2xJRtBkyZjuaj7XH+djH+xU923vloo0YRur+sYDLhisPt7kU7x0E9
NXQvUSZKmd8iUUUDDBeJPpa86l7OisNvebRkWrpj1pOWKl0aOiRG7h7nsRM7+0O4
hZZ84Hpaq05u6KYAJvtwMXGBtb+Vn3m3CqLf2fEt+Z1xZ+laJhgQD66f/6/HEeVz
Y2bBrSwjULMJSzy5rGaqDAeewofwWYdK6XPnNXsOHcfcCN3a3Ioy9/GcRfx/8paa
vswqRKN0nbWhj/xk0dsWoK64CmBFZ7S2wDOztjQ6gtqZ9oG1LzMCWvv/JZADJAPX
Z64ss/NhhySeVpAIhPrpkFXBVYFuLA==
=zD+X
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
