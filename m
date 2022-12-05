Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F80764217E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 03:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiLECXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 21:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiLECXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 21:23:49 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6E8C75F
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 18:23:48 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c17so5334445edj.13
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 18:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BTlZqUf+l5D9L/PndYJA9DpuLLc85L9FhYV9TE8wfqs=;
        b=YTszJzILOVYHSzWD3gmrVylwXNjPbyUBk5OK2z2zy2vYjlZvXfzNCQMBvTmZLp0r6n
         0ona6m51bghsG6cUVhyUfRpYBKwMDjEMIQSESB6hDHcyIkgwPyC99/kPVlDeAUaUfecr
         EyuQzcrYZbXOw/8GO4o61tLaAtNnaKGFJIF+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BTlZqUf+l5D9L/PndYJA9DpuLLc85L9FhYV9TE8wfqs=;
        b=aBZRyIDEUp2+3T0P7IBtap1onE9fbstpq6N5ZKBoCjGqfbdjAg0vjF0iHfEBEGMAHq
         2D/xLXmb9F7OTDtnPjOYuQmXQzytvQEjsKyyBKUUtoLUOJf0bPhxQeNhz2cO3LOoGQbF
         oPDElTuOYwX9MI4NmFsxML6NQZIr+3zVO3R6XyQbEcWq/SK/WYoiljxNQefIRqS1fGJo
         LT5RQWuUo0CP/e/hBleIoyoMsAzOXiN77CKWHVVd1hKLlg86vfyjxYGXKAXIe+9mXAXj
         Fl0+Vvlfm8vJ65WGmyj+IRyZZnm2jruw4/F2khgSjbAO16XhTLGf2Lqt5fUlEk+W/W32
         v0dQ==
X-Gm-Message-State: ANoB5pk4fKsUDpnrFgniYsg+c11jhjG/Ltqi0yYymF1rA2g56lvMsnP5
        T+txHOboRyMBUzy0GQH8OTSX1MNiIpNWSR5qdo5mIg==
X-Google-Smtp-Source: AA0mqf4DmX7wZUxhT4zOpYN5SaAv/Z6+CDSAb92H3nFnUjNsuxhN+YPu66OGXHOteaj2kVDjUjshE9oBDzyFzs+yz+A=
X-Received: by 2002:a05:6402:3789:b0:467:7664:c7f4 with SMTP id
 et9-20020a056402378900b004677664c7f4mr29786079edb.99.1670207026549; Sun, 04
 Dec 2022 18:23:46 -0800 (PST)
MIME-Version: 1.0
References: <20221202221213.236564-1-lixiaoyan@google.com>
In-Reply-To: <20221202221213.236564-1-lixiaoyan@google.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 4 Dec 2022 18:23:35 -0800
Message-ID: <CACKFLi=SUqiwXk6FATk0O53XUn9QPMMFtNu4WoDsdb=uBR2FUQ@mail.gmail.com>
Subject: Re: [RFC net-next v4 1/2] IPv6/GRO: generic helper to remove
 temporary HBH/jumbo header in driver
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008a828705ef0b60f7"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008a828705ef0b60f7
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 2, 2022 at 2:12 PM Coco Li <lixiaoyan@google.com> wrote:
>
> IPv6/TCP and GRO stacks can build big TCP packets with an added
> temporary Hop By Hop header.
>
> Is GSO is not involved, then the temporary header needs to be removed in
> the driver. This patch provides a generic helper for drivers that need
> to modify their headers in place.
>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  include/net/ipv6.h     | 35 +++++++++++++++++++++++++++++++++++
>  net/ipv6/ip6_offload.c | 27 ++++-----------------------
>  2 files changed, 39 insertions(+), 23 deletions(-)
>
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index d383c895592a..08adec74f067 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -500,6 +500,41 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
>         return jhdr->nexthdr;
>  }
>
> +/* Return 0 if HBH header is successfully removed
> + * Or if HBH removal is unnecessary (packet is not big TCP)
> + * Return error to indicate dropping the packet
> + */
> +static inline int ipv6_hopopt_jumbo_remove(struct sk_buff *skb)
> +{
> +       const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> +       int nexthdr = ipv6_has_hopopt_jumbo(skb);
> +       struct ipv6hdr *h6;
> +
> +       if (!nexthdr)
> +               return 0;
> +
> +       if (skb_cow_head(skb, 0))
> +               return -1;
> +
> +       /* Remove the HBH header.
> +        * Layout: [Ethernet header][IPv6 header][HBH][L4 Header]
> +        */
> +       memmove(skb_mac_header(skb) + hophdr_len, skb_mac_header(skb),
> +               skb_network_header(skb) - skb_mac_header(skb) +
> +               sizeof(struct ipv6hdr));
> +
> +       if (unlikely(!pskb_may_pull(skb, hophdr_len)))
> +               return -1;
> +

This version doesn't seem to work.  I think you need to add hophdr_len
to skb->data and subtract it from skb->len.

> +       skb->network_header += hophdr_len;
> +       skb->mac_header += hophdr_len;
> +
> +       h6 = ipv6_hdr(skb);
> +       h6->nexthdr = nexthdr;
> +
> +       return 0;
> +}
> +
>  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
>  {
>         /* If forwarding is enabled, RA are not accepted unless the special
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index 3ee345672849..00dc2e3b0184 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -77,7 +77,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
>         struct sk_buff *segs = ERR_PTR(-EINVAL);
>         struct ipv6hdr *ipv6h;
>         const struct net_offload *ops;
> -       int proto, nexthdr;
> +       int proto, err;
>         struct frag_hdr *fptr;
>         unsigned int payload_len;
>         u8 *prevhdr;
> @@ -87,28 +87,9 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
>         bool gso_partial;
>
>         skb_reset_network_header(skb);
> -       nexthdr = ipv6_has_hopopt_jumbo(skb);
> -       if (nexthdr) {
> -               const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> -               int err;
> -
> -               err = skb_cow_head(skb, 0);
> -               if (err < 0)
> -                       return ERR_PTR(err);
> -
> -               /* remove the HBH header.
> -                * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> -                */
> -               memmove(skb_mac_header(skb) + hophdr_len,
> -                       skb_mac_header(skb),
> -                       ETH_HLEN + sizeof(struct ipv6hdr));
> -               skb->data += hophdr_len;
> -               skb->len -= hophdr_len;
> -               skb->network_header += hophdr_len;
> -               skb->mac_header += hophdr_len;
> -               ipv6h = (struct ipv6hdr *)skb->data;
> -               ipv6h->nexthdr = nexthdr;
> -       }
> +       err = ipv6_hopopt_jumbo_remove(skb);
> +       if (err)
> +               return ERR_PTR(err);
>         nhoff = skb_network_header(skb) - skb_mac_header(skb);
>         if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
>                 goto out;
> --
> 2.39.0.rc0.267.gcb52ba06e7-goog
>

--0000000000008a828705ef0b60f7
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOc41MiwxUt+8cedBIbuL/69cg441AUe
ZuX7ytGoLwUsMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTIw
NTAyMjM0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCePiT7dP5qfU5dXD+io2k1xOJ50TqgubPf1W19LXEGO9QmcKIc
c75wCUbQND9UvUgKpelwCjlkAEYDAWUbmS3lg3DUS+yPXGpLpxNcLq/iM/CN3oun1no6TttsXaTc
QrQ1INL5/6hPMcqeljJX6v+MVkydamcFC+a5usMcWPban7omXt2b4oZcdGdObt9PDhG7ILInHOW5
N7QB+Zug9TlONi5mNojAjeXxBmb1NuqluA6PILPa66NcoTaq97Dpi4cF+CwFuLwZhTzkydfQYsaC
dbrvzvq4lYSMHQD737AlhrB37YJ5DASiaEPMC4U7/j2jSdYc27HwHBVpa/yEa+TH
--0000000000008a828705ef0b60f7--
