Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77622EC5FE
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhAFWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbhAFWGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:06:35 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D5BC061575;
        Wed,  6 Jan 2021 14:05:55 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DB3Mz23TNz9sSs;
        Thu,  7 Jan 2021 09:05:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1609970752;
        bh=vUUzf81NNkRzeMSJOm3zRfcOUmv4NcIoF/8trZU4cFM=;
        h=Date:From:To:Cc:Subject:From;
        b=FB9Vld3I+FyjDwEYa6U2Ocl2IeqIf/BHrDzFV7T6lgkECtXzuDic2qPm/3iYtSuv1
         7EyKahPIPfvQxEmSFXoIJFY3j4KBTTapm/pMBLLbzfXRBnxikneMsDU/zDWHKUTSYd
         V3p75rUtM7IuYVRlZUqwsqohflRnS8bYg1TEEEv/omsnR2w5xh79bi1iOPCxzIzouD
         Hb/7ELUTNfny+WOp8HvGLUWPFa8SBRZmlaCVQK5AXwSwt4IIJNnZ1jG34ETPxWfkzP
         FmrIKDdaouL0ZHJxUs/++Pw92VtlKNiNt/0EOkS0ac1Tq4V9GqZQMpb7FppaoZz2nq
         1vC/lfHwC4j2Q==
Date:   Thu, 7 Jan 2021 09:05:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the origin tree
Message-ID: <20210107090550.725f9dc9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hKUzPdJDCGxA0lI_vQUunC0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hKUzPdJDCGxA0lI_vQUunC0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Building Linus' tree, today's linux-next build (htmldocs) produced
this warning:

include/net/mac80211.h:4200: warning: Function parameter or member 'set_sar=
_specs' not described in 'ieee80211_ops'

Introduced by commit

  c534e093d865 ("mac80211: add ieee80211_set_sar_specs")

Sorry, I missed this earlier.

--=20
Cheers,
Stephen Rothwell

--Sig_/hKUzPdJDCGxA0lI_vQUunC0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/2ND4ACgkQAVBC80lX
0GwlQwgAknn42f+D0DSILrFEmsLexZLYVggo50TMgNqZFSesMUi1RZ3inq60/WpS
lpB2DB3Jnv45hv2TujSQZ/UJn26nt1syuE/TiWaDW3NVdGp9dvBZbLTEhQiTXUYm
4M0a8e2lFACWfJtP9Y9G+f4NJOqMd+GeFEiVJnwPrWvfbg+LGO9rvjMRfWfuV9TR
IzRfLYKIjCsoB/1gPF7lLBlLB4UyrltneNzY9io3Dbrl4OhSRz0iQVoyuSC0hmUt
xq3aWXcV64y8A1O8j7OXWCRFsHl1aDQfnLN67rfWCPDELlFCECA7VJcFGSCXtgM7
TkFalj2HyaVBkyhMI7etS/k6cXLy/g==
=7l6C
-----END PGP SIGNATURE-----

--Sig_/hKUzPdJDCGxA0lI_vQUunC0--
