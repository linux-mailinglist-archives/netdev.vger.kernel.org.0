Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57CE3CB12F
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 05:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhGPDpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 23:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhGPDpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 23:45:18 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8293C06175F;
        Thu, 15 Jul 2021 20:42:24 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GQxrZ28dkz9sX3;
        Fri, 16 Jul 2021 13:42:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626406942;
        bh=srvcUE0sX7HNjoJm4FGpd6Cconxnde2JnUpdddMfw1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tcwy78yRM534iYBSALkOYZEhryTdanGCqXY6KiUkPIR3L3Dm1Cb0GmLVXYwi53S3k
         qvGZIauR3YqyzAtsVQDJx+dcgHlwNMLJ8CV2vUrQq4tI16p8z3mwD8ve5Nm/yG8KMq
         MBjFfX6BO3C5izL30Br0Qa1aPVg6wraG9LKK9d8HVQlZwGKPzqGuT0NwopiWOiS+sf
         hTRRB8Slghq3Zjz+gU9cTkWwuB1zflwjqsQ/oifXWOOlISF9+UIx8ALXH/QuA+It3/
         rWgjJu0QlSEowa6Q5DX3BMIRNxlT32SSmr7mGRcpE2BrVIdb8SdAn93GJMUDTv51Dt
         YfU1DheHl0rjw==
Date:   Fri, 16 Jul 2021 13:42:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Richard Laing <richard.laing@alliedtelesis.co.nz>
Subject: Re: linux-next: manual merge of the mhi tree with the net-next tree
Message-ID: <20210716134221.726a81af@canb.auug.org.au>
In-Reply-To: <20210716133738.0d163701@canb.auug.org.au>
References: <20210716133738.0d163701@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Qocc/fuL1PA3KbGR.fCF1lB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Qocc/fuL1PA3KbGR.fCF1lB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 16 Jul 2021 13:37:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> @@@ -254,7 -256,7 +258,8 @@@ static const struct mhi_pci_dev_info mh
>   	.config =3D &modem_qcom_v1_mhiv_config,
>   	.bar_num =3D MHI_PCI_DEFAULT_BAR_NUM,
>   	.dma_data_width =3D 32,
>  +	.mru_default =3D 32768
> + 	.sideband_wake =3D false,
>   };

I added the missing ',' after the mru_default line above.

--=20
Cheers,
Stephen Rothwell

--Sig_/Qocc/fuL1PA3KbGR.fCF1lB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDxAB0ACgkQAVBC80lX
0Gy3vwf+Ngdo0sBWbroifbrtfr1j3CiOjtEOxkKu/2I44X0n96mkhAieCMHZAKg5
qG+HCgNPW7pamF4VR9ckcRND4r43kKEjtHMztJWkoSzpG6y0vJCrM1T5sQWKYmf+
+0QqqpJZZVLU6RfltvXD+Fn+lKz5sGQaF9HYCMp9KVZQmTcUrgiUo3qNeYqfVvWF
gJ4YUajfiCi9NMyxTHT+a0SYS/BKDJEv0XVWnAx5AVibW7ocy7xKwINvt1JniH9k
yqr6sMWx9i/g7sT1WCp5ruOxwesEiy8gAz0kX7+YSa/SkgAjVsd0LThAcc32Apa+
tsekgL2hjkppWhKrdNhI9BnhfG6k5Q==
=UsSI
-----END PGP SIGNATURE-----

--Sig_/Qocc/fuL1PA3KbGR.fCF1lB--
