Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F1B381734
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhEOJZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 05:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbhEOJZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 05:25:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A411C06174A;
        Sat, 15 May 2021 02:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LLYaJflt7X2EcBwnrjcvWHS4RrYDGI37jewhLUeMQfo=; b=hK6f2QgZDu5EyunitIS6XZR+NX
        bvU5wst3CRfBNcfqHo1FZJuzPI0U+oVxjn9tdnCSEGxwhLl5/453K16L8aroMHorKRjqQerfTGpwQ
        wQ2674BBELprQAsvRpbeKTZ/jKrHfKiRmn1TjOtF3Trd05+LXYljpkhtResjFcAYKi6lN1amEhfq9
        O4Eu40enbcCQCqcZTSn4/v0B+vOGORoJalDwOCAQQ1ceV8/asIWmEJ515PBdprgTMCwcY3o+PmB+c
        O3zDzRFN0oyzBRhFs2luuHf31lpJ4CjcavZMDfrlehbrgDZEvS2Zhu5Y+m5sMN/icTUc/VZDN+MKB
        n2k7fhTQ==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lhqXE-00CT1z-1l; Sat, 15 May 2021 09:24:36 +0000
Message-ID: <c2a4cb8457823685ecba6833d57047d059b36fbb.camel@infradead.org>
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
Date:   Sat, 15 May 2021 10:24:28 +0100
In-Reply-To: <20210515102239.2ffd0451@coco.lan>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
         <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
         <20210514102118.1b71bec3@coco.lan>
         <61c286b7afd6c4acf71418feee4eecca2e6c80c8.camel@infradead.org>
         <20210515102239.2ffd0451@coco.lan>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-u7lujVc2VeBAWx71Tyhx"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-u7lujVc2VeBAWx71Tyhx
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: quoted-printable

On Sat, 2021-05-15 at 10:22 +-0200, Mauro Carvalho Chehab wrote:
+AD4 +AD4 +AD4      Here, +ADw-CTRL+AD4APA-SHIFT+AD4-U is not working. No i=
dea why. I haven't=20
+AD4 +AD4 +AD4      test it for +ACo-years+ACo, as I din't see any reason w=
hy I would
+AD4 +AD4 +AD4      need to type UTF-8 characters by numbers until we start=
ed
+AD4 +AD4 +AD4      this thread. =20
+AD4 +AD4=20
+AD4 +AD4 Please provide the bug number for this+ADs I'd like to track it.
+AD4=20
+AD4 Just opened a BZ and added you as c/c.

Thanks.

+AD4 Let's take one step back, in order to return to the intents of this
+AD4 UTF-8, as the discussions here are not centered into the patches, but
+AD4 instead, on what to do and why.
+AD4=20
+AD4 -
+AD4=20
+AD4 This discussion started originally at linux-doc ML.
+AD4=20
+AD4 While discussing about an issue when machine's locale was not set
+AD4 to UTF-8 on a build VM,=20

Stop. Stop +ACo-right+ACo there before you go any further.

The machine's locale should have +ACo-nothing+ACo to do with anything.

When you view this email, it comes with a Content-Type: header which
explicitly tells you the character set that the message is encoded in,=20
which I think I've set to UTF-7.

When showing you the mail, your system has to interpret the bytes of
the content using +ACo-that+ACo character set encoding. Anything else is ju=
st
fundamentally broken. Your system locale has +ACo-nothing+ACo to do with it=
.

If your local system is running EBCDIC that doesn't +ACo-matter+ACo.

Now, the character set encoding of the kernel source and documentation
text files is UTF-8. It isn't EBCDIC, it isn't ISO8859-15 or any of the
legacy crap. It isn't system locale either, unless your system locale
+ACo-happens+ACo to be UTF-8.

UTF-8 +ACo-happens+ACo to be compatible with ASCII for the limited subset o=
f
characters which ASCII contains, sure +IBQ just as +ACo-many+ACo, but not a=
ll, of
the legacy 8-bit character sets are also a superset of ASCII's 7 bits.

But if the docs contain +ACo-any+ACo characters which aren't ASCII, and you
build them with a broken build system which assumes ASCII, you are
going to produce wrong output. There is +ACo-no+ACo substitute for fixing t=
he
+ACo-actual+ACo bug which started all this, and ensuring your build system =
(or
whatever) uses the +ACo-actual+ACo encoding of the text files it's processi=
ng,
instead of making stupid and bogus assumptions based on a system
default.

You concede keeping U+-00a9 +AKk COPYRIGHT SIGN. And that's encoded in UTF-
8 as two bytes 0xC2 0xA9. If some broken build system +ACo-assumes+ACo thos=
e
bytes are ISO8859-15 it'll take them to mean two separate characters

    U+-00C2 +AMI LATIN CAPITAL LETTER A WITH CIRCUMFLEX
    U+-00A9 +AKk COPYRIGHT SIGN

Your broken build system that started all this is never going to be
+ACo-anything+ACo other than broken. You can only paper over the cracks and
make it slightly less likely that people will notice in the common
case, perhaps? That's all you do by +ACo-reducing+ACo the use of non-ASCII,
unless you're going to drag us all the way back to the 1980s and
strictly limit us to pure ASCII, using the equivalent of trigraphs for
+ACo-anything+ACo outside the 0-127 character ranges.

And even if you did that, systems which use EBCDIC as their local
encoding would +ACo-still+ACo be broken, if they have the same bug you star=
ted
from. Because EBCDIC isn't compatible with ASCII +ACo-even+ACo for the firs=
t 7
bits.


+AD4 we discovered that some converted docs ended
+AD4 with BOM characters. Those specific changes were introduced by some
+AD4 of my convert patches, probably converted via pandoc.
+AD4=20
+AD4 So, I went ahead in order to check what other possible weird things
+AD4 were introduced by the conversion, where several scripts and tools
+AD4 were used on files that had already a different markup.
+AD4=20
+AD4 I actually checked the current UTF-8 issues, and asked people at
+AD4 linux-doc to comment what of those are valid usecases, and what
+AD4 should be replaced by plain ASCII.

No, these aren't +ACI-UTF-8 issues+ACI. Those are +ACo-conversion+ACo issue=
s, and
would still be there if the output of the conversion had been UTF-7,
UCS-16, etc. Or +ACo-even+ACo if the output of the conversion had been
trigraph-like stuff like '--' for emdash. It's +ACo-nothing+ACo to do with =
the
encoding that we happen to be using.

Fixing the conversion issues makes a lot of sense. Try to do it without
making +ACo-any+ACo mention of UTF-8 at all.

+AD4 In summary, based on the discussions we have so far, I suspect that
+AD4 there's not much to be discussed for the above cases.
+AD4=20
+AD4 So, I'll post a v3 of this series, changing only:
+AD4=20
+AD4         - U+-00a0 (' '): NO-BREAK SPACE
+AD4         - U+-feff ('+/v8'): ZERO WIDTH NO-BREAK SPACE (BOM)

Ack, as long as those make +ACo-no+ACo mention of UTF-8. Except perhaps to
note that BOM is redundant because UTF-8 doesn't have a byteorder.

+AD4 ---
+AD4=20
+AD4 Now, this specific patch series address also this extra case:
+AD4=20
+AD4 5. curly commas:
+AD4=20
+AD4         - U+-2018 ('+IBg'): LEFT SINGLE QUOTATION MARK
+AD4         - U+-2019 ('+IBk'): RIGHT SINGLE QUOTATION MARK
+AD4         - U+-201c ('+IBw'): LEFT DOUBLE QUOTATION MARK
+AD4         - U+-201d ('+IB0'): RIGHT DOUBLE QUOTATION MARK
+AD4=20
+AD4 IMO, those should be replaced by ASCII commas: ' and +ACI.
+AD4=20
+AD4 The rationale is simple:=20
+AD4=20
+AD4 - most were introduced during the conversion from Docbook,
+AD4   markdown and LaTex+ADs
+AD4 - they don't add any extra value, as using +ACI-foo+ACI of +IBw-foo+IB=
0 means
+AD4   the same thing+ADs
+AD4 - Sphinx already use +ACI-fancy+ACI commas at the output.=20
+AD4=20
+AD4 I guess I will put this on a separate series, as this is not a bug
+AD4 fix, but just a cleanup from the conversion work.
+AD4=20
+AD4 I'll re-post those cleanups on a separate series, for patch per patch
+AD4 review.

Makes sense.=20

The left/right quotation marks exists to make human-readable text much
easier to read, but the key point here is that they are redundant
because the tooling already emits them in the +ACo-output+ACo so they don't
need to be in the source, yes?

As long as the tooling gets it +ACo-right+ACo and uses them where it should=
,
that seems sane enough.

However, it +ACo-does+ACo break 'grep', because if I cut/paste a snippet fr=
om
the documentation and try to grep for it, it'll no longer match.

Consistency is good, but perhaps we should actually be consistent the
other way round and always use the left/right versions in the source
+ACo-instead+ACo of relying on the tooling, to make searches work better?
You claimed to care about that, right?

+AD4 The remaining cases are future work, outside the scope of this v2:
+AD4=20
+AD4 6. Hyphen/Dashes and ellipsis
+AD4=20
+AD4         - U+-2212 ('+IhI'): MINUS SIGN
+AD4         - U+-00ad ('+AK0'): SOFT HYPHEN
+AD4         - U+-2010 ('+IBA'): HYPHEN
+AD4=20
+AD4             Those three are used on places where a normal ASCII hyphen=
/minus
+AD4             should be used instead. There are even a couple of C files=
 which
+AD4             use them instead of '-' on comments.
+AD4=20
+AD4             IMO are fixes/cleanups from conversions and bad cut-and-pa=
ste.

That seems to make sense.

+AD4         - U+-2013 ('+IBM'): EN DASH
+AD4         - U+-2014 ('+IBQ'): EM DASH
+AD4         - U+-2026 ('+ICY'): HORIZONTAL ELLIPSIS
+AD4=20
+AD4             Those are auto-replaced by Sphinx from +ACI---+ACI, +ACI--=
--+ACI and +ACI...+ACI,
+AD4             respectively.
+AD4=20
+AD4             I guess those are a matter of personal preference about
+AD4             weather using ASCII or UTF-8.
+AD4=20
+AD4             My personal preference (and Ted seems to have a similar
+AD4             opinion) is to let Sphinx do the conversion.
+AD4=20
+AD4             For those, I intend to post a separate series, to be
+AD4             reviewed patch per patch, as this is really a matter
+AD4             of personal taste. Hardly we'll reach a consensus here.
+AD4=20

Again using the trigraph-like '--' and '...' instead of just using the
plain text '+IBQ' and '+ICY' breaks searching, because what's in the output
doesn't match the input. Again consistency is good, but perhaps we
should standardise on just putting these in their plain text form
instead of the trigraphs?

+AD4 7. math symbols:
+AD4=20
+AD4         - U+-00d7 ('+ANc'): MULTIPLICATION SIGN
+AD4=20
+AD4            This one is used mostly do describe video resolutions, but =
this is
+AD4            on a smaller changeset than the ones that use +ACI-x+ACI le=
tter.

I think standardising on +ANc for video resolutions in documentation would
make it look better and be easier to read.

+AD4=20
+AD4         - U+-2217 ('+Ihc'): ASTERISK OPERATOR
+AD4=20
+AD4            This is used only here:
+AD4                 Documentation/filesystems/ext4/blockgroup.rst:filesyst=
em size to 2+AF4-21 +Ihc 2+AF4-27 +AD0 2+AF4-48bytes or 256TiB.
+AD4=20
+AD4            Probably added by some conversion tool. IMO, this one shoul=
d
+AD4            also be replaced by an ASCII asterisk.
+AD4=20
+AD4 I guess I'll post a patch for the ASTERISK OPERATOR.

That makes sense.

--=-u7lujVc2VeBAWx71Tyhx
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
NTE1MDkyNDI4WjAvBgkqhkiG9w0BCQQxIgQg49GQz/BbeEPj001ez4MuF6hd0h51zt25HOFj2G8v
OQEwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAChecHYKH1pVDQ14kpVQyKM/0TfFVqChrg+BV+F5I4XDPsXAbXtzIRgpKq0mubC7
AWub/8FyhZyd78JqnN1Hn4t32RZJzKoOg17VH6cMdko33uHc4IMzNzbQYDeNGaRz1rZnK2VLStPS
hwZBoREvfRk1IEapEVfsL7FKU5k/3pk9QeB/fub8w2OsifwcmWarIEfEdlN1zFdv/CWg3t9sJANE
CfBdV9U2MCB1/Wadvd/R/O53ljOC7I9i0dK89gWWSC+vnQqlmiAAhpDwTD6lA/XP8s67Ic5r0+Yf
y81ku4xSOAaCwM6VXj3tSVck3A6WbQzCne3NSF/EJu9Tv2qKsssAAAAAAAA=


--=-u7lujVc2VeBAWx71Tyhx--

