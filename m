Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F52F6476D7
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiLHTye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiLHTyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:54:31 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61B45BD4C
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:54:30 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n21so6510551ejb.9
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6XHtRsIDJhqGYJ9kIPhluCYH/KG34j9Emeq/Hy4r1PE=;
        b=SgGKtKvAXyV0X6IpZnKzkofi9fJ95nV9g4abR5T6ZDimK9GpziDacRWftXiE2wfQCp
         O+3luAiwilFnVdzKIBoRFGcMZtQxAlRPNE2ztZP46ovXOvgWQv8vrJV2KaLH9GziLUSc
         EWXJDNBKdoDtcETbjzAplDvMTouO42oMMBTtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6XHtRsIDJhqGYJ9kIPhluCYH/KG34j9Emeq/Hy4r1PE=;
        b=RxOjXx5BjrSvCHt86C4pDiEhtfq2fXQ2/4H9OomTfOjmTPzBH4YJmj1sSxUGTEbavd
         pE/71ksvf7aC3oNKjLQb4L/pub8JB039CdZQHDW3ju0RBNUWDflhNXqAUyhdnLcpto9/
         jXEbdkvI63pPyp3Y+0fz95tV6oiLuxbN4tumzWGEOQD+/KFSrbD3m0HhfoNEgHTfHHU9
         EksXuKMgyAGgVyB3z63qxALjGIhQ1eZpPFARVGrPdXekMbHlOOvv8FKEUuC/jZ/d16k9
         KPqVK6WwDNTtx5E8cgtRNG/ioDQkGQe0jipgApJ8zBki/Fqrvueu4RmrDgvJL70ni4Db
         3oBA==
X-Gm-Message-State: ANoB5pk9Xd1kXZ83dHjEjWPiUXvskKuKR428h8SoDwmyxuzVJw8Z+7fN
        xvTWzLyYnPnlenxFuj5zuK1fd4u10eH6ljTJ/z7Gtw==
X-Google-Smtp-Source: AA0mqf50mkyNf4ARV701ZG/LUrz2fUXLJ1GGe/FgkMIvY8UbUPQ5uTsO+P6eXbHC/BJ5iJw+FTZgRG1TSrA1vzG+G2M=
X-Received: by 2002:a17:906:a41a:b0:7c0:e80e:5af0 with SMTP id
 l26-20020a170906a41a00b007c0e80e5af0mr15656997ejz.235.1670529268819; Thu, 08
 Dec 2022 11:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20221207225435.1273226-1-lixiaoyan@google.com> <20221207225435.1273226-2-lixiaoyan@google.com>
In-Reply-To: <20221207225435.1273226-2-lixiaoyan@google.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 8 Dec 2022 11:54:17 -0800
Message-ID: <CACKFLimL-+MGBsisQSnkvDfj7TJPAR4V59ec0DOubxxfH50RmA@mail.gmail.com>
Subject: Re: [RFC net-next v5 2/2] bnxt: Use generic HBH removal helper in tx path
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ae4d6005ef5667d0"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ae4d6005ef5667d0
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 7, 2022 at 2:54 PM Coco Li <lixiaoyan@google.com> wrote:
>
> Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
> for IPv6 traffic. See patch series:
> 'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'
>
> This reduces the number of packets traversing the networking stack and
> should usually improves performance. However, it also inserts a
> temporary Hop-by-hop IPv6 extension header.
>
> Using the HBH header removal method in the previous path, the extra header
> be removed in bnxt drivers to allow it to send big TCP packets (bigger
> TSO packets) as well.
>
> Tested:
> Compiled locally
>
> To further test functional correctness, update the GSO/GRO limit on the
> physical NIC:
>
> ip link set eth0 gso_max_size 181000
> ip link set eth0 gro_max_size 181000
>
> Note that if there are bonding or ipvan devices on top of the physical
> NIC, their GSO sizes need to be updated as well.
>
> Then, IPv6/TCP packets with sizes larger than 64k can be observed.
>
> Big TCP functionality is tested by Michael, feature checks not yet.
>
> Tested by Michael:
> I've confirmed with our hardware team that this is supported by our
> chips, and I've tested it up to gso_max_size of 524280.  Thanks.
>
> Tested-by: Michael Chan <michael.chan@broadcom.com>
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>

If you have made changes since the last version, please drop these
tags.  Reviewers will provide new tags after reviewing the new
version.

> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 0fe164b42c5d..6ba1cd342a80 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
>                         return NETDEV_TX_BUSY;
>         }
>
> +       if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> +               goto tx_free;
> +
>         length = skb->len;
>         len = skb_headlen(skb);
>         last_frag = skb_shinfo(skb)->nr_frags;
> @@ -11315,6 +11318,7 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
>                               u8 **nextp)
>  {
>         struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
> +       struct hop_jumbo_hdr *jhdr;
>         int hdr_count = 0;
>         u8 *nexthdr;
>         int start;
> @@ -11342,9 +11346,27 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
>
>                 if (hdrlen > 64)
>                         return false;
> +
> +               /* The ext header may be a hop-by-hop header inserted for
> +                * big TCP purposes. This will be removed before sending
> +                * from NIC, so do not count it.
> +                */
> +               if (*nexthdr == NEXTHDR_HOP) {
> +                       if (likely(skb->len <= GRO_LEGACY_MAX_SIZE))
> +                               goto increment_hdr;
> +
> +                       jhdr = (struct hop_jumbo_hdr *)nexthdr;

I already explained when reviewing your last version that nexthdr
initially points to the next header field within the ipv6 header so
this won't work.  If you cast it to jhdr, jhdr will be at offset 6 of
the ipv6 header.  It won't be pointing to the extension header.  You
need to do:

jhdr = (struct hop_jumbo_hdr *)hp

hp is pointing to the extension header.

Thanks.

> +                       if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
> +                           jhdr->nexthdr != IPPROTO_TCP)
> +                               goto increment_hdr;
> +
> +                       goto next_hdr;
> +               }
> +increment_hdr:
> +               hdr_count++;
> +next_hdr:
>                 nexthdr = &hp->nexthdr;
>                 start += hdrlen;
> -               hdr_count++;
>         }
>         if (nextp) {
>                 /* Caller will check inner protocol */

--000000000000ae4d6005ef5667d0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEjIi+Q2OIv9cdcKLHy9OH8qqYkfPa+a
fbjI3Ae3WQQwMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIw
ODE5NTQyOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBXdaIZsCmcZn1xdqbTHJnvrU7uojZb9OvsXIi2reFaVEuH1NC5
VkYmhmYKICltVmgVuBUDfE6/qZbgPWIy8LKFCvFbWWiLXQUSRljB5lxf/giIbSXGj4mbeivpJU7i
2nw61Apa78Um4LxjzW1s63DpJUNjuL8s+ZZU0bNu46tVirY4YNM+vw897nl3+drVOl2JV8nA+ZZR
NmgLpN1RpTirWDbFVeknIm6y9pLHe0Q5Aga8UtBw4+UDpk/3KZyXfXhOcNve8dsbLGQij6qsMb53
MQEwmxuGQwqfJvAEE2v4bzlRSARDsUKspLdlW/tY7Eh8i4ceOw0h4M/rLdbTDH9c
--000000000000ae4d6005ef5667d0--
