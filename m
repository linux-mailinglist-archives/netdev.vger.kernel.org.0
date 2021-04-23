Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB7368D32
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 08:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbhDWG1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 02:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbhDWG1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 02:27:47 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ED9C06138B
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 23:27:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j18so75904578lfg.5
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 23:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UaLpQ1STBJ3djn7BvenYPfKeT30znCG7395QctSkfQY=;
        b=Oo6R7FobKIJW9Od8FqNcKW4kowhygFTVFrzwCrQAIoVXY+rqskfQ+MFX86IiYVjesg
         BXgT7RPLNq9B0/2V1YRc1ZDfNeyd1w7cS3fuf44y3FzKu/PuwPZSJ2Bqah9VrsGUolKP
         ZWANJzTOq6LGgUhnoex0Otu1xms4hIkeTt0FYHbjgnGIFmHl73CDQGk5wBFomQptLzhD
         Y+I3cdMhUmDl+Ua8ZadwEDqc4pEjosV2mK2Sf3XmvN4R08EJ98d5LIGmU+PvQptmk9/y
         l4zN6fsE93pH2cM7oWateT9Iwwty4v51zr2t7h5XqR10gryt+U/vLHuI6djDtGE87TtJ
         f8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UaLpQ1STBJ3djn7BvenYPfKeT30znCG7395QctSkfQY=;
        b=czFOpaJhM2KUCe+S/uDNT74QCQ8H90x0IK3oj67/9MvT4JuH0ecBuwpbw1rMKO/Yp5
         QFzwFquj5wbBZj6bcLAADtx4bSU3c41DbOM3OnFDKRK+ceKPTrIrEGGgJjiuXvQRQptI
         VJtwnpOnBR8XxIW/vmiZpwouxvdIf2KAXk51VaQxTYE00XKgFNJDPsmN3583EwiS/n9Y
         a7y14bL/Dfvd/fp77e7kPzX7LtG+HgTFd3PayFq4/gFyodoX0uIu/6RDQ/B+5d1yjNYs
         7WVEknaOYPs/dQS0rWt4nzdKFr2CNgjRqdhSSWgOAdQkCGFEBT3h/2KW9iDn+c9No0QT
         TGsA==
X-Gm-Message-State: AOAM532GCDCRPx//UW2Qklz1OymqgFtbsMLcaWozs0XFAP47foWA/wqG
        Ufo+C+GFgA/5UXKV1Ktu1Ns8m1xXk1pMOZHtFYsmQQ==
X-Google-Smtp-Source: ABdhPJxwVNFz3aKPzwkMWWBUlqtIdr0gCVWb25meiGsqk5X/pr6U5Kjm8pNj2Whr4PHav4ogcf3/EODMFeeeiu7k4ZA=
X-Received: by 2002:a05:6512:138e:: with SMTP id p14mr1534510lfa.47.1619159227671;
 Thu, 22 Apr 2021 23:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618388989.git.npache@redhat.com> <YHyK+5xJEMcDDhVy@mit.edu>
 <dbe6abeb-0082-e309-1208-9c43c6f127ae@redhat.com>
In-Reply-To: <dbe6abeb-0082-e309-1208-9c43c6f127ae@redhat.com>
From:   David Gow <davidgow@google.com>
Date:   Fri, 23 Apr 2021 14:26:55 +0800
Message-ID: <CABVgOSmW=HPhpY05PJ2aj7q6G42YK1LfvifQY5EtheFE+of2RQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] kunit: Fix formatting of KUNIT tests to meet the standard
To:     Nico Pache <npache@redhat.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Brendan Higgins <brendanhiggins@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ext4@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        rafael@kernel.org, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        Mark Brown <broonie@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>, mptcp@lists.linux.dev
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a0e53f05c09de2c8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a0e53f05c09de2c8
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 23, 2021 at 4:39 AM Nico Pache <npache@redhat.com> wrote:
>
> On 4/18/21 3:39 PM, Theodore Ts'o wrote:
>
> > On Wed, Apr 14, 2021 at 04:58:03AM -0400, Nico Pache wrote:
> >> There are few instances of KUNIT tests that are not properly defined.
> >> This commit focuses on correcting these issues to match the standard
> >> defined in the Documentation.
> > The word "standard" seems to be over-stating things.  The
> > documentation currently states, "they _usually_ have config options
> > ending in ``_KUNIT_TEST'' (emphasis mine).  I can imagine that there
> > might be some useful things we can do from a tooling perspective if we
> > do standardize things, but if you really want to make it a "standard",
> > we should first update the manpage to say so,
>
> KUNIT Maintainers, should we go ahead and make this the "standard"?
>
> As Ted has stated...  consistency with 'grep' is my desired outcome.
>

The intention here is for this to be a "standard", with the caveat
that there may be reasons for not following said standard, though they
should be rare and may result in incompatibility with some tooling.
This is broadly laid out in the opening of the
Development/dev-tools/style.rst document, albeit still referring to
"guidelines" rather than a "standard". The rest of the document does,
as Ted pointed out, become more descriptive than prescriptive in some
sections (like the Kconfig entry one): assuming no-one is particularly
unhappy with that being tightened up, I've no problem with rewording
it.

That being said, when it comes to tooling, the Kconfig name does seem
like it's less important than it could've been: the existence of a
KUNIT_ALL_TESTS option, as well as support for having
per-directory/per-subsystem .kunitconfig files should hopefully mean
there's no need for tools to search for entries ending in _KUNIT_TEST.
(I do agree that it makes using 'grep' more convenient, though.)

> > and explain why (e.g.,
> > so that we can easily extract out all of the kunit test modules, and
> > perhaps paint a vision of what tools might be able to do with such a
> > standard).
> >
> > Alternatively, the word "standard" could perhaps be changed to
> > "convention", which I think more accurately defines how things work at
> > the moment.

Cheers,
-- David

--000000000000a0e53f05c09de2c8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPnAYJKoZIhvcNAQcCoIIPjTCCD4kCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz2MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
ILbFHw0h01NI0v+AeczGMEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwgZoGCCsGAQUF
BwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9jYS9nc2F0
bGFzcjNzbWltZWNhMjAyMDBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNv
bS9jYWNlcnQvZ3NhdGxhc3Izc21pbWVjYTIwMjAuY3J0MB8GA1UdIwQYMBaAFHzMCmjXouseLHIb
0c1dlW+N+/JjMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vY2Ev
Z3NhdGxhc3Izc21pbWVjYTIwMjAuY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQCNr3LBERPjVctGdVEb
/hN6/N6F2eUWxZLSUbuV7fOle0OvI8xz2AUBrOYQLp94ox9LqmsATKPsBl2uiktsvfs/AXNMcmOz
qsWHzfqp4XlvNgQsC/UyUMWxZoEyTDfTSat09yQjkFJ7viwzrqqscmTx5oTZz8TPRt0mbxwx3qry
wDzYxadSUQXNpNnfi0FBDYUUfuCLFWPsPsAXmgh483u0RbNik9OY/ozNq1Gvg/U0jQOlJf2IiKbE
kUL5Vq8gDDu6bETx5bHmRmSjHhwo7eVbxywczpzdFsU3dauZ3BzqhLy2pRGGzZybSH/3mf7o9y15
gmRHE7WzPLrsULHG/TM8MYICajCCAmYCAQEwaDBUMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
YmFsU2lnbiBudi1zYTEqMCgGA1UEAxMhR2xvYmFsU2lnbiBBdGxhcyBSMyBTTUlNRSBDQSAyMDIw
AhABm/kO+4pd09krN7Fjk8ypMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCh7i1G
xEa2Zy4mEF14lMt4G1bH/lllueUJtLj1vySixjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yMTA0MjMwNjI3MDhaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqG
SIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAjnHCdN9RnYjqXdO7bXdKmary
TYS/w5AwbUbQ5IYadX5M4PTbGNa3bxfHfrz3NrUWF0bmJecomzt5SJe3NmDVzkntxuLGzZyUv2F4
vk2p8uY0TMZad94dMfI+L3LsWngr7WNPqjDg/DXt+1dRhWbgVZSHnLMSOveUUCWV8ej/yaoSeRMQ
YqxCK5e3VquVBt10CL/0cgXsj0AkhmddkHqkUyLQKioDONQWHfVSAeIyenaOU8TLhRDFfct1JL0I
lfEWQWgYDhgY7tc3G0E0h9J2OBwUCmsuW3+czPgLLST8nvxkeyJKRykuAXcfEoBFGr233twR4UMQ
aSowOoDaOEf06A==
--000000000000a0e53f05c09de2c8--
