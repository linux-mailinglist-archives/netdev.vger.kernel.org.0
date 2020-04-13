Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7BD1A612E
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 02:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDMAFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 20:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDMAFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 20:05:37 -0400
Received: from ozlabs.org (ozlabs.org [203.11.71.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED498C0A3BE0;
        Sun, 12 Apr 2020 17:05:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 490pmH1ym0z9sSY;
        Mon, 13 Apr 2020 10:05:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1586736336;
        bh=dramMfk588s2jJtFy8Pg62RjgWHnwM4lRUBlleiswLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NmXLHzUVFgpYfIkXNtBrLAvpgCWBDgIaJ8rBaxFuSYPE8CQRtowT1jc4rxd72Di8M
         8rTMerL3KVZmb1Lc3P8t3v6Xk1GnfNLyvT0/eA+GJrj0cZOatwBMDbCEGGifb8LTtM
         wwq3CiPdp9nQbnJHIWbGOycViyJUO5qt3B5iEllafPvhaWIznDcJM9mcK3Bn9nhCZ9
         bYhWujX3RoLoeerZTyc5rY2SC0PE8z0onq1mMfO05Kp5r+PLyi8TXMtIJ1kCD5iUQZ
         AD0sZpPSXtCoA0L53jPoAS18bv4yjcuWUwGBWWM0/HRsUBBIE8EX5VG5Xsfpb1wUb5
         VzPYb/PG9xXUA==
Date:   Mon, 13 Apr 2020 10:05:34 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Message-ID: <20200413100534.057a688e@canb.auug.org.au>
In-Reply-To: <ace96f9842592c35458e970af900ec7a43029ae5.camel@mellanox.com>
References: <20200310210130.04bd5e2f@canb.auug.org.au>
        <ace96f9842592c35458e970af900ec7a43029ae5.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/u60VxkABfhHT0n7WCvP_NEE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/u60VxkABfhHT0n7WCvP_NEE
Content-Type: multipart/mixed; boundary="MP_/2j=.nCjV0fDN8vzf6+dYZf/"

--MP_/2j=.nCjV0fDN8vzf6+dYZf/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Saeed,

On Tue, 10 Mar 2020 23:57:31 +0000 Saeed Mahameed <saeedm@mellanox.com> wro=
te:
>
> On Tue, 2020-03-10 at 21:01 +1100, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Commits
> >=20
> >   b63293e759a1 ("net/mlx5e: Show/set Rx network flow classification
> > rules on ul rep")
> >   6783e8b29f63 ("net/mlx5e: Init ethtool steering for representors")
> >   01013ad355d6 ("net/mlx5e: Show/set Rx flow indir table and RSS hash
> > key on ul rep")
> >  =20
>=20
> Hi Stephen,=20
>=20
> checkpatch doesn't seem to catch such problems..=20
>=20
> I count on our CI to do such checks for me, so instead of me writing a=20
> new script every time we hit a new unforeseen issue, i was wondering
> where can i find the set of test/scripts you are running ?=20

I have attached my scripts ...

--=20
Cheers,
Stephen Rothwell

--MP_/2j=.nCjV0fDN8vzf6+dYZf/
Content-Type: application/x-shellscript
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=check_commits

IyEvYmluL2Jhc2gKCmlmIFsgIiQjIiAtbHQgMSBdOyB0aGVuCglwcmludGYgJ1VzYWdlOiAlcyA8
Y29tbWl0IHJhbmdlPlxuJyAiJDAiIDE+JjIKCWV4aXQgMQpmaQoKY29tbWl0cz0kKGdpdCByZXYt
bGlzdCAtLW5vLW1lcmdlcyAiJEAiKQppZiBbIC16ICIkY29tbWl0cyIgXTsgdGhlbgoJcHJpbnRm
ICdObyBjb21taXRzXG4nCglleGl0IDAKZmkKCiIkKHJlYWxwYXRoICIkKGRpcm5hbWUgIiQwIiki
KS9jaGVja19maXhlcyIgIiRAIgoKZGVjbGFyZSAtYSBhdXRob3JfbWlzc2luZyBjb21taXR0ZXJf
bWlzc2luZwoKcHJpbnRfY29tbWl0cygpCnsKCWlmIFsgIiQjIiAtZXEgMSBdOyB0aGVuCgkJcmV0
dXJuCglmaQoKCWxvY2FsIHQ9IiQxIgoKCXNoaWZ0CgoJcz0KCWlzPSdpcycKCWl0cz0naXRzJwoJ
aWYgWyAiJCMiIC1ndCAxIF07IHRoZW4KCQlzPSdzJwoJCWlzPSdhcmUnCgkJaXRzPSd0aGVpcicK
CWZpCglwcmludGYgJ0NvbW1pdCVzXG5cbicgIiRzIgoJZ2l0IGxvZyAtLW5vLXdhbGsgLS1wcmV0
dHk9J2Zvcm1hdDogICVoICgiJXMiKScgIiRAIgoJcHJpbnRmICdcbiVzIG1pc3NpbmcgYSBTaWdu
ZWQtb2ZmLWJ5IGZyb20gJXMgJXMlcy5cblxuJyBcCgkJIiRpcyIgIiRpdHMiICIkdCIgIiRzIgp9
CgpjaGVja191bmV4cGVjdGVkX2ZpbGVzKCkKewoJbG9jYWwgZmlsZXMKCglyZWFkYXJyYXkgZmls
ZXMgPCA8KGdpdCBkaWZmLXRyZWUgLXIgLS1kaWZmLWZpbHRlcj1BIC0tbmFtZS1vbmx5IC0tbm8t
Y29tbWl0LWlkICIkMSIgJyoucmVqJyAnKi5vcmlnJykKCWlmIFsgIiR7I2ZpbGVzW0BdfSIgLWVx
IDAgXTsgdGhlbgoJCXJldHVybgoJZmkKCglzPQoJdGhpcz0ndGhpcycKCWlmIFsgIiR7I2ZpbGVz
W0BdfSIgLWd0IDEgXTsgdGhlbgoJCXM9J3MnCgkJdGhpcz0ndGhlc2UnCglmaQoKCXByaW50ZiAn
Q29tbWl0XG5cbicKCWdpdCBsb2cgLS1uby13YWxrIC0tcHJldHR5PSdmb3JtYXQ6ICAlaCAoIiVz
IiknICIkMSIKCXByaW50ZiAnXG5hZGRlZCAlcyB1bmV4cGVjdGVkIGZpbGUlczpcblxuJyAiJHRo
aXMiICIkcyIKCXByaW50ZiAnICAlc1xuJyAiJHtmaWxlc1tAXX0iCn0KCmZvciBjIGluICRjb21t
aXRzOyBkbwoJYWU9JChnaXQgbG9nIC0xIC0tZm9ybWF0PSc8JWFlPiVuPCVhRT4lbiAlYW4gJW4g
JWFOICcgIiRjIiB8IHNvcnQgLXUpCgljZT0kKGdpdCBsb2cgLTEgLS1mb3JtYXQ9JzwlY2U+JW48
JWNFPiVuICVjbiAlbiAlY04gJyAiJGMiIHwgc29ydCAtdSkKCXNvYj0kKGdpdCBsb2cgLTEgLS1m
b3JtYXQ9JyViJyAiJGMiIHwKCQlzZWQgLUVuICdzL15ccypTaWduZWQtb2ZmLWJ5Oj9ccyovIC9p
cCcpCgoJaWYgISBncmVwIC1pIC1GIC1xICIkYWUiIDw8PCIkc29iIjsgdGhlbgoJCWF1dGhvcl9t
aXNzaW5nKz0oIiRjIikKCWZpCglpZiAhIGdyZXAgLWkgLUYgLXEgIiRjZSIgPDw8IiRzb2IiOyB0
aGVuCgkJY29tbWl0dGVyX21pc3NpbmcrPSgiJGMiKQoJZmkKCgljaGVja191bmV4cGVjdGVkX2Zp
bGVzICIkYyIKZG9uZQoKcHJpbnRfY29tbWl0cyAnYXV0aG9yJyAiJHthdXRob3JfbWlzc2luZ1tA
XX0iCnByaW50X2NvbW1pdHMgJ2NvbW1pdHRlcicgIiR7Y29tbWl0dGVyX21pc3NpbmdbQF19IgoK
ZXhlYyBnaXRrICIkQCIK

--MP_/2j=.nCjV0fDN8vzf6+dYZf/
Content-Type: application/x-shellscript
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=check_fixes

IyEvYmluL2Jhc2gKCmlmIFsgIiQjIiAtbHQgMSBdOyB0aGVuCiAgICAgICAgcHJpbnRmICdVc2Fn
ZTogJXMgPGNvbW1pdCByYW5nZT5cbicsICIkMCIgMT4mMgogICAgICAgIGV4aXQgMQpmaQoKY29t
bWl0cz0kKGdpdCByZXYtbGlzdCAtLW5vLW1lcmdlcyAtaSAtLWdyZXA9J15bWzpzcGFjZTpdXSpG
aXhlczonICIkQCIpCmlmIFsgLXogIiRjb21taXRzIiBdOyB0aGVuCiAgICAgICAgZXhpdCAwCmZp
CgojIFRoaXMgc2hvdWxkIGJlIGEgZ2l0IHRyZWUgdGhhdCBjb250YWlucyAqb25seSogTGludXMn
IHRyZWUKTGludXNfdHJlZT0iJHtIT01FfS9rZXJuZWxzL2xpbnVzLmdpdCIKCnNwbGl0X3JlPSde
KFtDY11bT29dW01tXVtNbV1bSWldW1R0XSk/W1s6c3BhY2U6XV0qKFtbOnhkaWdpdDpdXXs1LH0p
KFtbOnNwYWNlOl1dKikoLiopJCcKbmw9JCdcbicKdGFiPSQnXHQnCgojIFN0cmlwIHRoZSBsZWFk
aW5nIGFuZCB0cmFpbmluZyBzcGFjZXMgZnJvbSBhIHN0cmluZwpzdHJpcF9zcGFjZXMoKQp7Cglb
WyAiJDEiID1+IF5bWzpzcGFjZTpdXSooLipbXls6c3BhY2U6XV0pW1s6c3BhY2U6XV0qJCBdXQoJ
ZWNobyAiJHtCQVNIX1JFTUFUQ0hbMV19Igp9Cgpmb3IgYyBpbiAkY29tbWl0czsgZG8KCgljb21t
aXRfbG9nPSQoZ2l0IGxvZyAtMSAtLWZvcm1hdD0nJWggKCIlcyIpJyAiJGMiKQoJY29tbWl0X21z
Zz0iSW4gY29tbWl0CgogICRjb21taXRfbG9nCgoiCgoJZml4ZXNfbGluZXM9JChnaXQgbG9nIC0x
IC0tZm9ybWF0PSclQicgIiRjIiB8CgkJCWdyZXAgLWkgJ15bWzpzcGFjZTpdXSpGaXhlczonKQoK
CXdoaWxlIHJlYWQgLXIgZmxpbmU7IGRvCgkJW1sgIiRmbGluZSIgPX4gXltbOnNwYWNlOl1dKltG
Zl1bSWldW1h4XVtFZV1bU3NdOltbOnNwYWNlOl1dKiguKikkIF1dCgkJZj0iJHtCQVNIX1JFTUFU
Q0hbMV19IgoJCWZpeGVzX21zZz0iRml4ZXMgdGFnCgogICRmbGluZQoKaGFzIHRoZXNlIHByb2Js
ZW0ocyk6CgoiCgkJc2hhPQoJCXN1YmplY3Q9CgkJbXNnPQoJCWlmIFtbICIkZiIgPX4gJHNwbGl0
X3JlIF1dOyB0aGVuCgkJCWZpcnN0PSIke0JBU0hfUkVNQVRDSFsxXX0iCgkJCXNoYT0iJHtCQVNI
X1JFTUFUQ0hbMl19IgoJCQlzcGFjZXM9IiR7QkFTSF9SRU1BVENIWzNdfSIKCQkJc3ViamVjdD0i
JHtCQVNIX1JFTUFUQ0hbNF19IgoJCQlpZiBbICIkZmlyc3QiIF07IHRoZW4KCQkJCW1zZz0iJHtt
c2c6KyR7bXNnfSR7bmx9fSAgLSBsZWFkaW5nIHdvcmQgJyRmaXJzdCcgdW5leHBlY3RlZCIKCQkJ
ZmkKCQkJaWYgWyAteiAiJHN1YmplY3QiIF07IHRoZW4KCQkJCW1zZz0iJHttc2c6KyR7bXNnfSR7
bmx9fSAgLSBtaXNzaW5nIHN1YmplY3QiCgkJCWVsaWYgWyAteiAiJHNwYWNlcyIgXTsgdGhlbgoJ
CQkJbXNnPSIke21zZzorJHttc2d9JHtubH19ICAtIG1pc3Npbmcgc3BhY2UgYmV0d2VlbiB0aGUg
U0hBMSBhbmQgdGhlIHN1YmplY3QiCgkJCWZpCgkJZWxzZQoJCQlwcmludGYgJyVzJXMgIC0gJXNc
bicgIiRjb21taXRfbXNnIiAiJGZpeGVzX21zZyIgJ05vIFNIQTEgcmVjb2duaXNlZCcKCQkJY29t
bWl0X21zZz0nJwoJCQljb250aW51ZQoJCWZpCgkJaWYgISBnaXQgcmV2LXBhcnNlIC1xIC0tdmVy
aWZ5ICIkc2hhIiA+L2Rldi9udWxsOyB0aGVuCgkJCXByaW50ZiAnJXMlcyAgLSAlc1xuJyAiJGNv
bW1pdF9tc2ciICIkZml4ZXNfbXNnIiAnVGFyZ2V0IFNIQTEgZG9lcyBub3QgZXhpc3QnCgkJCWNv
bW1pdF9tc2c9JycKCQkJY29udGludWUKCQlmaQoKCQlpZiBbICIkeyNzaGF9IiAtbHQgMTIgXTsg
dGhlbgoJCQltc2c9IiR7bXNnOiske21zZ30ke25sfX0gIC0gU0hBMSBzaG91bGQgYmUgYXQgbGVh
c3QgMTIgZGlnaXRzIGxvbmcke25sfSAgICBDYW4gYmUgZml4ZWQgYnkgc2V0dGluZyBjb3JlLmFi
YnJldiB0byAxMiAob3IgbW9yZSkgb3IgKGZvciBnaXQgdjIuMTEke25sfSAgICBvciBsYXRlcikg
anVzdCBtYWtpbmcgc3VyZSBpdCBpcyBub3Qgc2V0IChvciBzZXQgdG8gXCJhdXRvXCIpLiIKCQlm
aQoJCSMgcmVkdWNlIHRoZSBzdWJqZWN0IHRvIHRoZSBwYXJ0IGJldHdlZW4gKCkgaWYgdGhlcmUK
CQlpZiBbWyAiJHN1YmplY3QiID1+IF5cKCguKilcKSBdXTsgdGhlbgoJCQlzdWJqZWN0PSIke0JB
U0hfUkVNQVRDSFsxXX0iCgkJZWxpZiBbWyAiJHN1YmplY3QiID1+IF5cKCguKikgXV07IHRoZW4K
CQkJc3ViamVjdD0iJHtCQVNIX1JFTUFUQ0hbMV19IgoJCQltc2c9IiR7bXNnOiske21zZ30ke25s
fX0gIC0gU3ViamVjdCBoYXMgbGVhZGluZyBidXQgbm8gdHJhaWxpbmcgcGFyZW50aGVzZXMiCgkJ
ZmkKCgkJIyBzdHJpcCBtYXRjaGluZyBxdW90ZXMgYXQgdGhlIHN0YXJ0IGFuZCBlbmQgb2YgdGhl
IHN1YmplY3QKCQkjIHRoZSB1bmljb2RlIGNoYXJhY3RlcnMgaW4gdGhlIGNsYXNzZXMgYXJlCgkJ
IyBVKzIwMUMgTEVGVCBET1VCTEUgUVVPVEFUSU9OIE1BUksKCQkjIFUrMjAxRCBSSUdIVCBET1VC
TEUgUVVPVEFUSU9OIE1BUksKCQkjIFUrMjAxOCBMRUZUIFNJTkdMRSBRVU9UQVRJT04gTUFSSwoJ
CSMgVSsyMDE5IFJJR0hUIFNJTkdMRSBRVU9UQVRJT04gTUFSSwoJCXJlMT0kJ15bXCJcdTIwMUNd
KC4qKVtcIlx1MjAxRF0kJwoJCXJlMj0kJ15bXCdcdTIwMThdKC4qKVtcJ1x1MjAxOV0kJwoJCXJl
Mz0kJ15bXCJcJ1x1MjAxQ1x1MjAxOF0oLiopJCcKCQlpZiBbWyAiJHN1YmplY3QiID1+ICRyZTEg
XV07IHRoZW4KCQkJc3ViamVjdD0iJHtCQVNIX1JFTUFUQ0hbMV19IgoJCWVsaWYgW1sgIiRzdWJq
ZWN0IiA9fiAkcmUyIF1dOyB0aGVuCgkJCXN1YmplY3Q9IiR7QkFTSF9SRU1BVENIWzFdfSIKCQll
bGlmIFtbICIkc3ViamVjdCIgPX4gJHJlMyBdXTsgdGhlbgoJCQlzdWJqZWN0PSIke0JBU0hfUkVN
QVRDSFsxXX0iCgkJCW1zZz0iJHttc2c6KyR7bXNnfSR7bmx9fSAgLSBTdWJqZWN0IGhhcyBsZWFk
aW5nIGJ1dCBubyB0cmFpbGluZyBxdW90ZXMiCgkJZmkKCgkJc3ViamVjdD0kKHN0cmlwX3NwYWNl
cyAiJHN1YmplY3QiKQoKCQl0YXJnZXRfc3ViamVjdD0kKGdpdCBsb2cgLTEgLS1mb3JtYXQ9JyVz
JyAiJHNoYSIpCgkJdGFyZ2V0X3N1YmplY3Q9JChzdHJpcF9zcGFjZXMgIiR0YXJnZXRfc3ViamVj
dCIpCgoJCSMgbWF0Y2ggd2l0aCBlbGxpcHNlcwoJCWNhc2UgIiRzdWJqZWN0IiBpbgoJCSouLi4p
CXN1YmplY3Q9IiR7c3ViamVjdCUuLi59IgoJCQl0YXJnZXRfc3ViamVjdD0iJHt0YXJnZXRfc3Vi
amVjdDowOiR7I3N1YmplY3R9fSIKCQkJOzsKCQkuLi4qKQlzdWJqZWN0PSIke3N1YmplY3QjLi4u
fSIKCQkJdGFyZ2V0X3N1YmplY3Q9IiR7dGFyZ2V0X3N1YmplY3Q6IC0keyNzdWJqZWN0fX0iCgkJ
CTs7CgkJKlwgLi4uXCAqKQoJCQlzMT0iJHtzdWJqZWN0JSAuLi4gKn0iCgkJCXMyPSIke3N1Ympl
Y3QjKiAuLi4gfSIKCQkJc3ViamVjdD0iJHMxICRzMiIKCQkJdDE9IiR7dGFyZ2V0X3N1YmplY3Q6
MDokeyNzMX19IgoJCQl0Mj0iJHt0YXJnZXRfc3ViamVjdDogLSR7I3MyfX0iCgkJCXRhcmdldF9z
dWJqZWN0PSIkdDEgJHQyIgoJCQk7OwoJCWVzYWMKCQlzdWJqZWN0PSQoc3RyaXBfc3BhY2VzICIk
c3ViamVjdCIpCgkJdGFyZ2V0X3N1YmplY3Q9JChzdHJpcF9zcGFjZXMgIiR0YXJnZXRfc3ViamVj
dCIpCgoJCWlmIFsgIiRzdWJqZWN0IiAhPSAiJHt0YXJnZXRfc3ViamVjdDowOiR7I3N1YmplY3R9
fSIgXTsgdGhlbgoJCQltc2c9IiR7bXNnOiske21zZ30ke25sfX0gIC0gU3ViamVjdCBkb2VzIG5v
dCBtYXRjaCB0YXJnZXQgY29tbWl0IHN1YmplY3Qke25sfSAgICBKdXN0IHVzZSR7bmx9JHt0YWJ9
Z2l0IGxvZyAtMSAtLWZvcm1hdD0nRml4ZXM6ICVoIChcIiVzXCIpJyIKCQlmaQoJCWxzaGE9JChj
ZCAiJExpbnVzX3RyZWUiICYmIGdpdCByZXYtcGFyc2UgLXEgLS12ZXJpZnkgIiRzaGEiKQoJCWlm
IFsgLXogIiRsc2hhIiBdOyB0aGVuCgkJCWNvdW50PSQoZ2l0IHJldi1saXN0IC0tY291bnQgIiRz
aGEiLi4iJGMiKQoJCQlpZiBbICIkY291bnQiIC1lcSAwIF07IHRoZW4KCQkJCW1zZz0iJHttc2c6
KyR7bXNnfSR7bmx9fSAgLSBUYXJnZXQgaXMgbm90IGFuIGFuY2VzdG9yIG9mIHRoaXMgY29tbWl0
IgoJCQlmaQoJCWZpCgkJaWYgWyAiJG1zZyIgXTsgdGhlbgoJCQlwcmludGYgJyVzJXMlc1xuJyAi
JGNvbW1pdF9tc2ciICIkZml4ZXNfbXNnIiAiJG1zZyIKCQkJY29tbWl0X21zZz0nJwoJCWZpCglk
b25lIDw8PCAiJGZpeGVzX2xpbmVzIgpkb25lCgpleGl0IDAK

--MP_/2j=.nCjV0fDN8vzf6+dYZf/--

--Sig_/u60VxkABfhHT0n7WCvP_NEE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6TrM4ACgkQAVBC80lX
0Gz7+ggAleeuC5UjBl8ZNRGgjS27XWhDTqSdHOVBBByOxqmcdmPpyA0cc9ZCop+v
FgZtXKmzqVkE8Cd34IiYU0VAJhsr2qG/UOEnMDat8PSk4dAW2pqEvjzW4lM5FPml
hottxyZhg43/mJgoUQqoDYjYczxfw/i2/FOjDj6WohpIHzkz1f1/MZNPCaadjcXm
tj6u6lDRB1EREQLNpOZLAzYI9Xlg5OjGzTBxSXqkKd8/AqaRzC8ugYNbw0Mw+G+n
5hQHMktsaZeQeptF+wdniRjVNghz/u81OSO9Dc6uh/B4FPwrHYJgzjeVPx29rUIf
8jcdrKe5ebXuFtciL2Xzp0ncgtmhSw==
=HQQV
-----END PGP SIGNATURE-----

--Sig_/u60VxkABfhHT0n7WCvP_NEE--
