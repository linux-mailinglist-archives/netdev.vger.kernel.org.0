Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2262D3818A3
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhEOMDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 08:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhEOMDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 08:03:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE5CC061573;
        Sat, 15 May 2021 05:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4HwhbcACMsQ6s8PrbvOFRolJmBpaq4E6wTiGJdn+Rfg=; b=oAopGDw6kOXXXvbnLCgClsmskk
        MeZ5Tr5aCNXfbglGv/GQq7DT63pvWOsnjfyHwLojAKtJXOOGUdlek5QEPpzWWZARiMob6rFJzsAqp
        A47PKtxwi8QpabQy3/MvPt7FOkWXhi3JJMnnNB8BGVr3q16MNigyeXbdWkwfNyu+JTSscFsGG41a7
        AAgxmh3wi7yKwuV7jH2ilVQO/m/+kbsO7cfD2craR18FEN8yJlt/HjVuP3chUTi6QreT9MUNZUPcM
        DLa7Z0NvOA2HbMBZNfPZDhUJNfj1hTPSaPLdbi47CrU3ntBymsfvGDiutxgZiwVHSRI346gyg8kUe
        otwkz9MQ==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lhszy-00CW1g-Ev; Sat, 15 May 2021 12:02:28 +0000
Message-ID: <74696d9a8906e3c16dcdff558aaab4f9663b06f5.camel@infradead.org>
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
From:   David Woodhouse <dwmw2@infradead.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
        keyrings@vger.kernel.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Date:   Sat, 15 May 2021 13:02:18 +0100
In-Reply-To: <20210515132344.0206c8fc@coco.lan>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
         <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
         <20210514102118.1b71bec3@coco.lan>
         <61c286b7afd6c4acf71418feee4eecca2e6c80c8.camel@infradead.org>
         <20210515102239.2ffd0451@coco.lan>
         <c2a4cb8457823685ecba6833d57047d059b36fbb.camel@infradead.org>
         <20210515132344.0206c8fc@coco.lan>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-0pItJwY7zPHv3JqMO44E"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-0pItJwY7zPHv3JqMO44E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2021-05-15 at 13:23 +0200, Mauro Carvalho Chehab wrote:
> Em Sat, 15 May 2021 10:24:28 +0100
> David Woodhouse <dwmw2@infradead.org> escreveu:
> > > Let's take one step back, in order to return to the intents of this
> > > UTF-8, as the discussions here are not centered into the patches, but
> > > instead, on what to do and why.
> > >=20
> > > This discussion started originally at linux-doc ML.
> > >=20
> > > While discussing about an issue when machine's locale was not set
> > > to UTF-8 on a build VM,  =20
> >=20
> > Stop. Stop *right* there before you go any further.
> >=20
> > The machine's locale should have *nothing* to do with anything.
>
> Now, you're making a lot of wrong assumptions here ;-)
>=20
> 1. I didn't report the bug. Another person reported it at linux-doc;
> 2. I fully agree with you that the building system should work fine
>    whatever locate the machine has;
> 3. Sphinx supported charset for the REST input and its output is UTF-8.

OK, fine. So that's an unrelated issue really, and just happened to be
what historically triggered the discussion. Let's set it aside.

> > > I actually checked the current UTF-8 issues =E2=80=A6=20
> >=20
> > No, these aren't "UTF-8 issues". Those are *conversion* issues, and=20
> > =E2=80=A6 *nothing* to do with the encoding that we happen to be using.
>=20
> Yes. That's what I said.

Er=E2=80=A6 I'm fairly sure you *did* call them "UTF-8 issues". Whatever.




> >=20
> > Fixing the conversion issues makes a lot of sense. Try to do it without
> > making *any* mention of UTF-8 at all.
> >=20
> > > In summary, based on the discussions we have so far, I suspect that
> > > there's not much to be discussed for the above cases.
> > >=20
> > > So, I'll post a v3 of this series, changing only:
> > >=20
> > >         - U+00a0 (' '): NO-BREAK SPACE
> > >         - U+feff ('=EF=BB=BF'): ZERO WIDTH NO-BREAK SPACE (BOM) =20
> >=20
> > Ack, as long as those make *no* mention of UTF-8. Except perhaps to
> > note that BOM is redundant because UTF-8 doesn't have a byteorder.
>=20
> I need to tell what UTF-8 codes are replaced, as otherwise the patch
> wouldn't make much sense to reviewers, as both U+00a0 and whitespaces
> are displayed the same way, and BOM is invisible.
>=20

No. Again, this is *nothing* to do with UTF-8. The encoding we choose
to map between byte in the file and characters is *utterly* irrelevant
here. If we were using UTF-7, UTF-16, or even (in the case of non-
breaking space) one of the legacy 8-bit charsets that includes it like
ISO8859-1, the issue would be precisely the same.=20

It's about the *character* U+00A0 NO-BREAK SPACE; nothing to do with
UTF-8 at all. Don't mention UTF-8. It's *irrelevant* and just shows
that you can't actually bothered to stop and do any critical thinking
about the matter at all.

As I said, the only time that it makes sense to mention UTF-8 in this
context is when talking about *why* the BOM is not needed. And even
then, you could say "because we *aren't* using an encoding where
endianness matters, such as UTF-16", instead of actually mentioning
UTF-8. Try it =E2=98=BA

> >=20
> > > ---
> > >=20
> > > Now, this specific patch series address also this extra case:
> > >=20
> > > 5. curly commas:
> > >=20
> > >         - U+2018 ('=E2=80=98'): LEFT SINGLE QUOTATION MARK
> > >         - U+2019 ('=E2=80=99'): RIGHT SINGLE QUOTATION MARK
> > >         - U+201c ('=E2=80=9C'): LEFT DOUBLE QUOTATION MARK
> > >         - U+201d ('=E2=80=9D'): RIGHT DOUBLE QUOTATION MARK
> > >=20
> > > IMO, those should be replaced by ASCII commas: ' and ".
> > >=20
> > > The rationale is simple:=20
> > >=20
> > > - most were introduced during the conversion from Docbook,
> > >   markdown and LaTex;
> > > - they don't add any extra value, as using "foo" of =E2=80=9Cfoo=E2=
=80=9D means
> > >   the same thing;
> > > - Sphinx already use "fancy" commas at the output.=20
> > >=20
> > > I guess I will put this on a separate series, as this is not a bug
> > > fix, but just a cleanup from the conversion work.
> > >=20
> > > I'll re-post those cleanups on a separate series, for patch per patch
> > > review. =20
> >=20
> > Makes sense.=20
> >=20
> > The left/right quotation marks exists to make human-readable text much
> > easier to read, but the key point here is that they are redundant
> > because the tooling already emits them in the *output* so they don't
> > need to be in the source, yes?
>=20
> Yes.
>=20
> > As long as the tooling gets it *right* and uses them where it should,
> > that seems sane enough.
> >=20
> > However, it *does* break 'grep', because if I cut/paste a snippet from
> > the documentation and try to grep for it, it'll no longer match.
> >=20
> > Consistency is good, but perhaps we should actually be consistent the
> > other way round and always use the left/right versions in the source
> > *instead* of relying on the tooling, to make searches work better?
> > You claimed to care about that, right?
>=20
> That's indeed a good point. It would be interesting to have more
> opinions with that matter.
>=20
> There are a couple of things to consider:
>=20
> 1. It is (usually) trivial to discover what document produced a
>    certain page at the documentation.
>=20
>    For instance, if you want to know where the text under this
>    file came from, or to grep a text from it:
>=20
> 	https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html
>=20
>    You can click at the "View page source" button at the first line.
>    It will show the .rst file used to produce it:
>=20
> 	https://www.kernel.org/doc/html/latest/_sources/admin-guide/cgroup-v2.rs=
t.txt
>=20
> 2. If all you want is to search for a text inside the docs,
>    you can click at the "Search docs" box, which is part of the
>    Read the Docs theme.
>=20
> 3. Kernel has several extensions for Sphinx, in order to make life=20
>    easier for Kernel developers:
>=20
> 	Documentation/sphinx/automarkup.py
> 	Documentation/sphinx/cdomain.py
> 	Documentation/sphinx/kernel_abi.py
> 	Documentation/sphinx/kernel_feat.py
> 	Documentation/sphinx/kernel_include.py
> 	Documentation/sphinx/kerneldoc.py
> 	Documentation/sphinx/kernellog.py
> 	Documentation/sphinx/kfigure.py
> 	Documentation/sphinx/load_config.py
> 	Documentation/sphinx/maintainers_include.py
> 	Documentation/sphinx/rstFlatTable.py
>=20
> Those (in particular automarkup and kerneldoc) will also dynamically=20
> change things during ReST conversion, which may cause grep to not work.=
=20
>=20
> 5. some PDF tools like evince will match curly commas if you
>    type an ASCII comma on their search boxes.
>=20
> 6. Some developers prefer to only deal with the files inside the
>    Kernel tree. Those are very unlikely to do grep with curly aspas.
>=20
> My opinion on that matter is that we should make life easier for
> developers to grep on text files, as the ones using the web interface
> are already served by the search box in html format or by tools like
> evince.
>=20
> So, my vote here is to keep aspas as plain ASCII.

OK, but all your reasoning is about the *character* used, not the
encoding. So try to do it without mentioning ASCII, and especially
without mentioning UTF-8.

Your point is that the *character* is the one easily reachable on
standard keyboard layouts, and the one which people are most likely to
enter manually. It has *nothing* to do with charset encodings, so don't
conflate is with talking about charset encodings.

>=20
> >=20
> > > The remaining cases are future work, outside the scope of this v2:
> > >=20
> > > 6. Hyphen/Dashes and ellipsis
> > >=20
> > >         - U+2212 ('=E2=88=92'): MINUS SIGN
> > >         - U+00ad ('=C2=AD'): SOFT HYPHEN
> > >         - U+2010 ('=E2=80=90'): HYPHEN
> > >=20
> > >             Those three are used on places where a normal ASCII hyphe=
n/minus
> > >             should be used instead. There are even a couple of C file=
s which
> > >             use them instead of '-' on comments.
> > >=20
> > >             IMO are fixes/cleanups from conversions and bad cut-and-p=
aste. =20
> >=20
> > That seems to make sense.
> >=20
> > >         - U+2013 ('=E2=80=93'): EN DASH
> > >         - U+2014 ('=E2=80=94'): EM DASH
> > >         - U+2026 ('=E2=80=A6'): HORIZONTAL ELLIPSIS
> > >=20
> > >             Those are auto-replaced by Sphinx from "--", "---" and ".=
..",
> > >             respectively.
> > >=20
> > >             I guess those are a matter of personal preference about
> > >             weather using ASCII or UTF-8.
> > >=20
> > >             My personal preference (and Ted seems to have a similar
> > >             opinion) is to let Sphinx do the conversion.
> > >=20
> > >             For those, I intend to post a separate series, to be
> > >             reviewed patch per patch, as this is really a matter
> > >             of personal taste. Hardly we'll reach a consensus here.
> > >  =20
> >=20
> > Again using the trigraph-like '--' and '...' instead of just using the
> > plain text '=E2=80=94' and '=E2=80=A6' breaks searching, because what's=
 in the output
> > doesn't match the input. Again consistency is good, but perhaps we
> > should standardise on just putting these in their plain text form
> > instead of the trigraphs?
>=20
> Good point.=20
>=20
> While I don't have any strong preferences here, there's something that
> annoys me with regards to EM/EN DASH:
>=20
> With the monospaced fonts I'm using here - both at my e-mailer and
> on my terminals, both EM and EN DASH are displayed look *exactly*
> the same.

Interesting. They definitely show differently in my terminal, and in
the monospaced font in email.


--=-0pItJwY7zPHv3JqMO44E
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
NTE1MTIwMjE4WjAvBgkqhkiG9w0BCQQxIgQgfW+vho0CWarq8S9OvME99jJ1PMHkjC8+kBJcG3U0
p6Mwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBACF4r0vrHTdaJGL5lZsMwS1/Dkh9o3EITVDKNULzCTcMSjUroYNAEiS0NdDrDNwV
LM0bqWq2SQlVSZESZJjwPLYhCcbylYLpdlJfnrQZ02CRbaj3mv6al5tIgVcCkzo+U6e1+FZmUPjr
kzU29zFz8X0c9ha64GYmmewP+XJmmGBlCsriwWB0+2Ne2vyh8VGLZGOiuZ2bx60soXTZD5gANksJ
3J30LCsNqg2oEOkjFpgs38DykfU6OYvCjeuXHXQjSBF1HSXuLkN45DQ5ufbp8s9ML+JW59NOqg8K
u4+VyT08fa+tMV05K2JoAdTVYHbhfobGEo0Qogwl7skUqcE8Af4AAAAAAAA=


--=-0pItJwY7zPHv3JqMO44E--

