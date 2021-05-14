Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC493805E6
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 11:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhENJH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 05:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhENJHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 05:07:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7B5C061574;
        Fri, 14 May 2021 02:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wJ/s2QfMNTOyTmAVrtCY2CXjxIzIo3n63jc+NCKOLVA=; b=qSdZ8XEu7oRfN3BBgzEHopiTqS
        jG82n131hUCIcPhL/w7BpeBcjIKG4Se8cut+H2eYH3uOfbcNc7XGdGIVO0uSQfx4iK4PzAeAUbF47
        s4NeyxYEZrokaZG8vXvllhAVi13S8TKrRyssrgAp/z1xL56gQXAHbyDmNqp2B+nCcPBR4b3vKKP/6
        WZap8/pZ+M0Fu6/S+LcKQXTZOBM21oBFJBC6bs4YY8zXYLoGfBXcTU+OOoEdKTC+f8945eYS5r8vY
        zeI/I13z7D3mRVVokdlbY8t5yWaIvIxQI9QWgqVafmOYRy9Cc/IPb3MSh4WbRqO6atJAiwzvd5UcX
        0kfhSlGA==;
Received: from 54-240-197-239.amazon.com ([54.240.197.239] helo=iad7-dhcp-95-145-115.iad7.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lhTln-00BqP5-JN; Fri, 14 May 2021 09:06:08 +0000
Message-ID: <61c286b7afd6c4acf71418feee4eecca2e6c80c8.camel@infradead.org>
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
From:   David Woodhouse <dwmw2@infradead.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Date:   Fri, 14 May 2021 10:06:01 +0100
In-Reply-To: <20210514102118.1b71bec3@coco.lan>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
         <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
         <20210514102118.1b71bec3@coco.lan>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-yaWQTSPMGuNj6joXfKRG"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-yaWQTSPMGuNj6joXfKRG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-05-14 at 10:21 +0200, Mauro Carvalho Chehab wrote:
> Em Wed, 12 May 2021 18:07:04 +0100
> David Woodhouse <dwmw2@infradead.org> escreveu:
>=20
> > On Wed, 2021-05-12 at 14:50 +0200, Mauro Carvalho Chehab wrote:
> > > Such conversion tools - plus some text editor like LibreOffice  or si=
milar  - have
> > > a set of rules that turns some typed ASCII characters into UTF-8 alte=
rnatives,
> > > for instance converting commas into curly commas and adding non-break=
able
> > > spaces. All of those are meant to produce better results when the tex=
t is
> > > displayed in HTML or PDF formats. =20
> >=20
> > And don't we render our documentation into HTML or PDF formats?=20
>=20
> Yes.
>=20
> > Are
> > some of those non-breaking spaces not actually *useful* for their
> > intended purpose?
>=20
> No.
>=20
> The thing is: non-breaking space can cause a lot of problems.
>=20
> We even had to disable Sphinx usage of non-breaking space for
> PDF outputs, as this was causing bad LaTeX/PDF outputs.
>=20
> See, commit: 3b4c963243b1 ("docs: conf.py: adjust the LaTeX document outp=
ut")
>=20
> The afore mentioned patch disables Sphinx default behavior of
> using NON-BREAKABLE SPACE on literal blocks and strings, using this
> special setting: "parsedliteralwraps=3Dtrue".
>=20
> When NON-BREAKABLE SPACE were used on PDF outputs, several parts of=20
> the media uAPI docs were violating the document margins by far,
> causing texts to be truncated.
>=20
> So, please **don't add NON-BREAKABLE SPACE**, unless you test
> (and keep testing it from time to time) if outputs on all
> formats are properly supporting it on different Sphinx versions.

And there you have a specific change with a specific fix. Nothing to do
with whether NON-BREAKABLE SPACE is =E2=88=89 ASCII, and *certainly* nothin=
g to
do with the fact that, like *every* character in every kernel file
except the *binary* files, it's representable in UTF-8.

By all means fix the specific characters which are typographically
wrong or which, like NON-BREAKABLE SPACE, cause problems for rendering
the documentation.


> Also, most of those came from conversion tools, together with other
> eccentricities, like the usage of U+FEFF (BOM) character at the
> start of some documents. The remaining ones seem to came from=20
> cut-and-paste.

... or which are just entirely redundant and gratuitous, like a BOM in
an environment where all files are UTF-8 and never 16-bit encodings
anyway.

> > > While it is perfectly fine to use UTF-8 characters in Linux, and spec=
ially at
> > > the documentation,  it is better to  stick to the ASCII subset  on su=
ch
> > > particular case,  due to a couple of reasons:
> > >=20
> > > 1. it makes life easier for tools like grep; =20
> >=20
> > Barely, as noted, because of things like line feeds.
>=20
> You can use grep with "-z" to seek for multi-line strings(*), Like:
>=20
> 	$ grep -Pzl 'grace period started,\s*then' $(find Documentation/ -type f=
)
> 	Documentation/RCU/Design/Data-Structures/Data-Structures.rst

Yeah, right. That works if you don't just use the text that you'll have
seen in the HTML/PDF "grace period started, then", and if you instead
craft a *regex* for it, replacing the spaces with '\s*'. Or is that
[[:space:]]* if you don't want to use the experimental Perl regex
feature?

 $ grep -zlr 'grace[[:space:]]\+period[[:space:]]\+started,[[:space:]]\+the=
n' Documentation/RCU
Documentation/RCU/Design/Data-Structures/Data-Structures.rst

And without '-l' it'll obviously just give you the whole file. No '-A5
-B5' to see the surroundings... it's hardly a useful thing, is it?

> (*) Unfortunately, while "git grep" also has a "-z" flag, it
>     seems that this is (currently?) broken with regards of handling multi=
lines:
>=20
> 	$ git grep -Pzl 'grace period started,\s*then'
> 	$

Even better. So no, multiline grep isn't really a commonly usable
feature at all.

This is why we prefer to put user-visible strings on one line in C
source code, even if it takes the lines over 80 characters =E2=80=94 to all=
ow
for grep to find them.

> > > 2. they easier to edit with the some commonly used text/source
> > >    code editors. =20
> >=20
> > That is nonsense. Any but the most broken and/or anachronistic
> > environments and editors will be just fine.
>=20
> Not really.
>=20
> I do use a lot of UTF-8 here, as I type texts in Portuguese, but I rely
> on the US-intl keyboard settings, that allow me to type as "'a" for =C3=
=A1.
> However, there's no shortcut for non-Latin UTF-codes, as far as I know.
>=20
> So, if would need to type a curly comma on the text editors I normally=
=20
> use for development (vim, nano, kate), I would need to cut-and-paste
> it from somewhere[1].

That's entirely irrelevant. You don't need to be able to *type* every
character that you see in front of you, as long as your editor will
render it correctly and perhaps let you cut/paste it as you're editing
the document if you're moving things around.

> [1] If I have a table with UTF-8 codes handy, I could type the UTF-8=20
>     number manually... However, it seems that this is currently broken=
=20
>     at least on Fedora 33 (with Mate Desktop and US intl keyboard with=
=20
>     dead keys).
>=20
>     Here, <CTRL><SHIFT>U is not working. No idea why. I haven't=20
>     test it for *years*, as I din't see any reason why I would
>     need to type UTF-8 characters by numbers until we started
>     this thread.

Please provide the bug number for this; I'd like to track it.

> But even in the best case scenario where I know the UTF-8 and
> <CTRL><SHIFT>U works, if I wanted to use, for instance, a curly
> comma, the keystroke sequence would be:
>=20
> 	<CTRL><SHIFT>U201csome string<CTRL><SHIFT>U201d
>=20
> That's a lot harder than typing and has a higher chances of
> mistakenly add a wrong symbol than just typing:
>=20
> 	"some string"
>=20
> Knowing that both will produce *exactly* the same output, why
> should I bother doing it the hard way?

Nobody's asked you to do it the "hard way". That's completely
irrelevant to the discussion we were having.

> Now, I'm not arguing that you can't use whatever UTF-8 symbol you
> want on your docs. I'm just saying that, now that the conversion=20
> is over and a lot of documents ended getting some UTF-8 characters
> by accident, it is time for a cleanup.

All text documents are *full* of UTF-8 characters. If there is a file
in the source code which has *any* non-UTF8, we call that a 'binary
file'.

Again, if you want to make specific fixes like removing non-breaking
spaces and byte order marks, with specific reasons, then those make
sense. But it's got very little to do with UTF-8 and how easy it is to
type them. And the excuse you've put in the commit comment for your
patches is utterly bogus.


--=-yaWQTSPMGuNj6joXfKRG
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEw
NTE0MDkwNjAxWjAvBgkqhkiG9w0BCQQxIgQgRtNzbeu5bsoNcbDbiy2DI8xBXrnEUoNy+3PeRBi7
ocwwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAG4iEcQoKZbciqO8UTjj3Ul3XZurUfbBSxRFkr4krMkAtIXtGzBe5kw5UgEtQ43c
adrLgLYJ5JYMqy67j+r7p8zEgeXNx9rUvKjuR0eQsUyBEfmTQIuYgX67ChBAONPO/cDR6AqQP2Kc
scoU4Lzl2O+p+KE0kPvscY2Mm91fuwKxarqZY9lNI+VoyW9uYIuD6BSiZIaWpZiuaryxLelhWHay
8OYH/pRSvgjry42MLa1GUePUXm5M4NqeD0vKZVyzpFAftfHc6urFB3TNQ8yjeSBaxw3wkVBShkuB
yhc3/6yoegNWASNgF5veVsrZ/2L+VxVQi7icYamHNJ9gu4g7KkgAAAAAAAA=


--=-yaWQTSPMGuNj6joXfKRG--

