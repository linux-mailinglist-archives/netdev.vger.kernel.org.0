Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D140D129985
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 18:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfLWRps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 12:45:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44741 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726754AbfLWRps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 12:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577123146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=RRN4umjjL9IE2YCbqRzU+slTNeIOI0xIbWJCqcHPpG8=;
        b=EjDHZno6pdMaTJw0tgpC1mudpMBRsPdjtN5TYimkmDL1jsE4VgpPhYuFc4rReu3HesnsUF
        VsgYyV06c+P9gqKVpQMTEVqEuQZ2p4xJ29MRbEE2jpl1NzOuWSxFk5FTI6TbyrKbuQEQld
        Ajs55HJGZnHYHIpxv7mtPqJdXzOwYEE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-Knr0Y2VZNUaAn1Tflbad8g-1; Mon, 23 Dec 2019 12:45:40 -0500
X-MC-Unique: Knr0Y2VZNUaAn1Tflbad8g-1
Received: by mail-wm1-f69.google.com with SMTP id o24so16956wmh.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=RRN4umjjL9IE2YCbqRzU+slTNeIOI0xIbWJCqcHPpG8=;
        b=NzZ0NFRvIhA6RNkmjl5P0GXe2uKCDT8UYRJmtu06HoNp0aVuQjwMyaauZ2u8xcKflD
         U0KuoH7tlSwqYlDVUnuxa5W30xvqwCXp3AvGL7nJvrGqPUEv1RMZjBz1AM26R1d/Bn1r
         VQQQFdyInZmb5jjXMfeGxx4yyA2q+aCmG0CKq+4yMw52sEv6gAc9aa1h6ooXzghSTbo7
         JPoyHDeDGRWTyan0bKQf7Vb+34SJ1V5xHAI52ANhXCsLk/fDyQPHqAcQ/r93keY/Rhes
         I/f1aJ+LAcnPwSjuCkz9ldEG43d42EnIxLJDn6ZpX/veakXu+rid5tAFXM71jkhPqWqo
         1chQ==
X-Gm-Message-State: APjAAAUYW9vYuBVnQZdS0uXO0kTx2D+LBqxpaYYjbmBtFB5vbksxGG4m
        SfXl00PNEnWgg8S+L54QVn4gVqB7dUk9BCKksCNQNEakI1ck9nNtk1hO3n9BEBE7WnRGSVNswYa
        p0Noenqr+vh8W9rO7
X-Received: by 2002:a1c:638a:: with SMTP id x132mr155134wmb.43.1577123139086;
        Mon, 23 Dec 2019 09:45:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqycckskHP+/gF69MlLzRE3kqAFqGTOLmfDJfW27Z0SBDZoh9jCgzekAXMMaXvHPSGArLZJvvQ==
X-Received: by 2002:a1c:638a:: with SMTP id x132mr155126wmb.43.1577123138872;
        Mon, 23 Dec 2019 09:45:38 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k16sm22390831wru.0.2019.12.23.09.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 09:45:38 -0800 (PST)
Date:   Mon, 23 Dec 2019 18:45:35 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, lucien.xin@gmail.com,
        marcelo.leitner@gmail.com
Subject: SCTP over GRE (w csum)
Message-ID: <20191223174535.GF6274@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GLp9dJVi+aaipsRk"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GLp9dJVi+aaipsRk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I am currently working on the following scenario:

sctp --> ipv4 --> gretap --> ipv6 --> eth

If NETIF_F_SCTP_CRC is not supported by the network device (it is the
case for gre), sctp will fallback computing the crc32 in sw with
sctp_gso_make_checksum(), where SKB_GSO_CB(skb)->csum is set to ~0 by
gso_reset_checksum(). After the gso segmentation, gre_gso_segment()
will try to compute gre csum with gso_make_checksum() even if skb->ip_summed
is set to CHECKSUM_NONE (and so using ~0 as partial).
One possible (trivial and not tested) solution would be to recompute the
gre checksum, doing in gre_gso_segment() something like:

	if (skb->ip_summed == CHECKSUM_NONE) {
		...
		err = skb_checksum_help(skb);
		if (err < 0)
			return return ERR_PTR(err);
	} else {
		*pcsum = gso_make_checksum(skb, 0);
	}

One possible improvement would be offload the GRE checksum computation if the
hw exports this capability in netdev_features and fall back to the sw
implementation if not.
Am I missing something? Is there a better approach?

Regards,
Lorenzo

--GLp9dJVi+aaipsRk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXgD9OwAKCRA6cBh0uS2t
rI14AQCEb7i+CnI3FeBIyW9/vCkwJgI2RnvXyyvs89Zm1a39FgD/dURP89P0Ve17
z/LxnZCC1/gIIEYz6jxr4vAeND2fUAE=
=W/Kj
-----END PGP SIGNATURE-----

--GLp9dJVi+aaipsRk--

