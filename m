Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9077D67949E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 10:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbjAXJ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 04:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjAXJ6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 04:58:04 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5F437F38
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 01:58:02 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d2so13292431wrp.8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 01:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnD7x+LquuXd9eqgq6vzDPsb/grBFPcAf8olwrc15Fk=;
        b=kx18Z2si5/UyMoX4+arN/hKvj/uxrtaCSFRIKmb2zi7KdQVCkncoaryIuErzarYKNW
         3Qn7yOJuJJCCBWFYBPjgJAx79MnPNe6fwSZYuGEaXJlA5abvVkSshR+LhyDaYsMC5tGe
         9Md8SvGG+p8aR1OULHFAJwgMxn2qro+oJlaa33N/eAasJff6D6qilQMVzkNoMtI31CZu
         Z2YKNQs3Ki+bbGKFTDzSOIA0SzHbbZsoNOjzqijiNr3Td6ZDz2k2pUV8cfSL/FvqK3c+
         wUSWNI17iy2U/jh6Bu8KPkADC5zuvoaB0ZNjaIG35dtnw7WQ7gF2Szgatu63ftybVaqg
         NM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BnD7x+LquuXd9eqgq6vzDPsb/grBFPcAf8olwrc15Fk=;
        b=ot+Z2hiGdS3I2XaAIWduYzpkaVqRWiB5+azMEf1pmr/OMw4EULGyfav+bDoZ7k1tuD
         pMUbEBdsJByDKpUSK6yy6eUsMUv5HvsSiEOw4u8miEPCV0AB4NmNvRn7tGlITZwg38Ur
         n/QHJnieVkcyGPZUWxoQqCJb/RX/BaPtDyiS3ymV/szIlQmdzOKJShCCFhGZHfN75nGP
         Vt9RzoQOt1qWqjlrfDyZSp5qw3VlauYRlW3b801bDHDFpoM6YqX3UdT6/gevMIczBYKN
         IyFCbt7cJ3dxapwTh6R0ceI7Nng7SeZV6J2uOQsP1HeB/VAShIRXGFLTg9hxSTL4hygU
         fXgg==
X-Gm-Message-State: AFqh2kooU2zJ7EnsGGZvICIAJp/nLQrU4V9TSlycViY1RnI8raoxsvCt
        kKRBckFgQ8FCMKg4ZuBteA2XPQ==
X-Google-Smtp-Source: AMrXdXtRxsPJpsCWbfTy9Reijg6XDK1VCY9JcQZ5d9XcuFAlBQYQhTPhnXMyd6uSAZl7OVklWuFv9w==
X-Received: by 2002:adf:dcc8:0:b0:2bf:950f:d4bc with SMTP id x8-20020adfdcc8000000b002bf950fd4bcmr9549767wrm.11.1674554280356;
        Tue, 24 Jan 2023 01:58:00 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:aa20:891c:fc72:f8f? ([2a02:578:8593:1200:aa20:891c:fc72:f8f])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d50c5000000b00241bd7a7165sm1445981wrt.82.2023.01.24.01.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 01:57:59 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------huW3oKL2vytUMj2evfQ8dg0J"
Message-ID: <14d5e179-807c-cd9d-d156-ca90c2a03ed6@tessares.net>
Date:   Tue, 24 Jan 2023 10:57:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: linux-next: build failure after merge of the net-next tree
Content-Language: en-GB
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230124100249.5ec4512c@canb.auug.org.au>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230124100249.5ec4512c@canb.auug.org.au>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------huW3oKL2vytUMj2evfQ8dg0J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Stephen,

On 24/01/2023 00:02, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from net/ethtool/netlink.c:6:
> net/ethtool/netlink.h:177:20: error: redefinition of 'ethnl_update_bool'
>   177 | static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
>       |                    ^~~~~~~~~~~~~~~~~
> net/ethtool/netlink.h:125:20: note: previous definition of 'ethnl_update_bool' with type 'void(bool *, const struct nlattr *, bool *)' {aka 'void(_Bool *, const struct nlattr *, _Bool *)'}
>   125 | static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
>       |                    ^~~~~~~~~~~~~~~~~

Thank you for the patch, we had the same issue in MPTCP tree when
merging net and net-next.

> Caused by commit
> 
>   dc0b98a1758f ("ethtool: Add and use ethnl_update_bool.")
> 
> merging badly with commit
> 
>   7c494a7749a7 ("net: ethtool: netlink: introduce ethnl_update_bool()")
> 
> from the net tree.
> 
> I applied the following merge fix up.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 24 Jan 2023 09:58:16 +1100
> Subject: [PATCH] fix up for "ethtool: Add and use ethnl_update_bool."
> 
> interacting with "net: ethtool: netlink: introduce ethnl_update_bool()"
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/ethtool/netlink.h | 26 --------------------------
>  1 file changed, 26 deletions(-)
> 
> diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
> index 4992fab0d06b..b01f7cd542c4 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -111,32 +111,6 @@ static inline void ethnl_update_u8(u8 *dst, const struct nlattr *attr,
>  	*mod = true;
>  }
>  
> -/**
> - * ethnl_update_bool() - update bool from NLA_U8 attribute
> - * @dst:  value to update
> - * @attr: netlink attribute with new value or null
> - * @mod:  pointer to bool for modification tracking
> - *
> - * Use the u8 value from NLA_U8 netlink attribute @attr to set bool variable
> - * pointed to by @dst to false (if zero) or 1 (if not); do nothing if @attr is
> - * null. Bool pointed to by @mod is set to true if this function changed the
> - * logical value of *dst, otherwise it is left as is.
> - */
> -static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
> -				     bool *mod)
> -{
> -	u8 val;
> -
> -	if (!attr)
> -		return;
> -	val = !!nla_get_u8(attr);
> -	if (*dst == val)
> -		return;
> -
> -	*dst = val;
> -	*mod = true;
> -}

Small detail: should we not remove the other one -- introduced by commit
dc0b98a1758f ("ethtool: Add and use ethnl_update_bool.") -- instead? The
other one has some typos in the description and is using "!!*dst" while
it is not needed if I'm not mistaken.

In MPTCP tree for the moment, I removed the other one but I will follow
up on which one I need to discard :)
Just in case, I attached the patch I used. I can send it properly if needed.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------huW3oKL2vytUMj2evfQ8dg0J
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-ethtool-fix-up-for-ethtool-Add-and-use-ethnl_upd.patch"
Content-Disposition: attachment;
 filename*0="0001-net-ethtool-fix-up-for-ethtool-Add-and-use-ethnl_upd.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBkY2EzZGJmOTBhNGZkZjQxOTExMjJhZGRlMjI3ZmMzMTgwNzI2NGViIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVn
Lm9yZy5hdT4KRGF0ZTogVHVlLCAyNCBKYW4gMjAyMyAxMDowMjo0OSArMTEwMApTdWJqZWN0
OiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogZXRodG9vbDogZml4IHVwIGZvciAiZXRodG9vbDog
QWRkIGFuZCB1c2UKIGV0aG5sX3VwZGF0ZV9ib29sLiIKCkFmdGVyIG1lcmdpbmcgdGhlIG5l
dC1uZXh0IHRyZWUsIHRvZGF5J3MgbGludXgtbmV4dCBidWlsZCAocG93ZXJwYwpwcGM2NF9k
ZWZjb25maWcpIGZhaWxlZCBsaWtlIHRoaXM6CgogIEluIGZpbGUgaW5jbHVkZWQgZnJvbSBu
ZXQvZXRodG9vbC9uZXRsaW5rLmM6NjoKICBuZXQvZXRodG9vbC9uZXRsaW5rLmg6MTc3OjIw
OiBlcnJvcjogcmVkZWZpbml0aW9uIG9mICdldGhubF91cGRhdGVfYm9vbCcKICAgIDE3NyB8
IHN0YXRpYyBpbmxpbmUgdm9pZCBldGhubF91cGRhdGVfYm9vbChib29sICpkc3QsIGNvbnN0
IHN0cnVjdCBubGF0dHIgKmF0dHIsCiAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgXn5+
fn5+fn5+fn5+fn5+fn4KICBuZXQvZXRodG9vbC9uZXRsaW5rLmg6MTI1OjIwOiBub3RlOiBw
cmV2aW91cyBkZWZpbml0aW9uIG9mICdldGhubF91cGRhdGVfYm9vbCcgd2l0aCB0eXBlICd2
b2lkKGJvb2wgKiwgY29uc3Qgc3RydWN0IG5sYXR0ciAqLCBib29sICopJyB7YWthICd2b2lk
KF9Cb29sICosIGNvbnN0IHN0cnVjdCBubGF0dHIgKiwgX0Jvb2wgKiknfQogICAgMTI1IHwg
c3RhdGljIGlubGluZSB2b2lkIGV0aG5sX3VwZGF0ZV9ib29sKGJvb2wgKmRzdCwgY29uc3Qg
c3RydWN0IG5sYXR0ciAqYXR0ciwKICAgICAgICB8ICAgICAgICAgICAgICAgICAgICBefn5+
fn5+fn5+fn5+fn5+fgoKQ2F1c2VkIGJ5OgoKICBjb21taXQgZGMwYjk4YTE3NThmICgiZXRo
dG9vbDogQWRkIGFuZCB1c2UgZXRobmxfdXBkYXRlX2Jvb2wuIikKCm1lcmdpbmcgYmFkbHkg
d2l0aDoKCiAgY29tbWl0IDdjNDk0YTc3NDlhNyAoIm5ldDogZXRodG9vbDogbmV0bGluazog
aW50cm9kdWNlIGV0aG5sX3VwZGF0ZV9ib29sKCkiKQoKZnJvbSB0aGUgbmV0IHRyZWUuCgpU
aGUgdmVyc2lvbiBmcm9tIG5ldC1uZXh0IC0tIGNvbW1pdCA3YzQ5NGE3NzQ5YTcgKCJuZXQ6
IGV0aHRvb2w6Cm5ldGxpbms6IGludHJvZHVjZSBldGhubF91cGRhdGVfYm9vbCgpIikgLS0g
aGFzIGJlZW4gdGFrZW4sIGtlZXBpbmcgdGhlCm9uZSBmcm9tIG5ldC4KCkZpeGVzOiBkYzBi
OThhMTc1OGYgKCJldGh0b29sOiBBZGQgYW5kIHVzZSBldGhubF91cGRhdGVfYm9vbC4iKQpD
by1kZXZlbG9wZWQtYnk6IE1hdHRoaWV1IEJhZXJ0cyA8bWF0dGhpZXUuYmFlcnRzQHRlc3Nh
cmVzLm5ldD4KU2lnbmVkLW9mZi1ieTogTWF0dGhpZXUgQmFlcnRzIDxtYXR0aGlldS5iYWVy
dHNAdGVzc2FyZXMubmV0PgpTaWduZWQtb2ZmLWJ5OiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJA
Y2FuYi5hdXVnLm9yZy5hdT4KLS0tCiBuZXQvZXRodG9vbC9uZXRsaW5rLmggfCAyNiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI2IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL25ldC9ldGh0b29sL25ldGxpbmsuaCBiL25ldC9ldGh0b29sL25l
dGxpbmsuaAppbmRleCA0OTkyZmFiMGQwNmIuLjI5YWVmMzk0NzZlYiAxMDA2NDQKLS0tIGEv
bmV0L2V0aHRvb2wvbmV0bGluay5oCisrKyBiL25ldC9ldGh0b29sL25ldGxpbmsuaApAQCAt
MTYzLDMyICsxNjMsNiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZXRobmxfdXBkYXRlX2Jvb2wz
Mih1MzIgKmRzdCwgY29uc3Qgc3RydWN0IG5sYXR0ciAqYXR0ciwKIAkqbW9kID0gdHJ1ZTsK
IH0KIAotLyoqCi0gKiBldGhubF91cGRhdGVfYm9vbCgpIC0gdXBkYXRlYiBib29sIHVzZWQg
YXMgYm9vbCBmcm9tIE5MQV9VOCBhdHRyaWJ1dGUKLSAqIEBkc3Q6ICB2YWx1ZSB0byB1cGRh
dGUKLSAqIEBhdHRyOiBuZXRsaW5rIGF0dHJpYnV0ZSB3aXRoIG5ldyB2YWx1ZSBvciBudWxs
Ci0gKiBAbW9kOiAgcG9pbnRlciB0byBib29sIGZvciBtb2RpZmljYXRpb24gdHJhY2tpbmcK
LSAqCi0gKiBVc2UgdGhlIGJvb2wgdmFsdWUgZnJvbSBOTEFfVTggbmV0bGluayBhdHRyaWJ1
dGUgQGF0dHIgdG8gc2V0IGJvb2wgdmFyaWFibGUKLSAqIHBvaW50ZWQgdG8gYnkgQGRzdCB0
byAwIChpZiB6ZXJvKSBvciAxIChpZiBub3QpOyBkbyBub3RoaW5nIGlmIEBhdHRyIGlzCi0g
KiBudWxsLiBCb29sIHBvaW50ZWQgdG8gYnkgQG1vZCBpcyBzZXQgdG8gdHJ1ZSBpZiB0aGlz
IGZ1bmN0aW9uIGNoYW5nZWQgdGhlCi0gKiBsb2dpY2FsIHZhbHVlIG9mICpkc3QsIG90aGVy
d2lzZSBpdCBpcyBsZWZ0IGFzIGlzLgotICovCi1zdGF0aWMgaW5saW5lIHZvaWQgZXRobmxf
dXBkYXRlX2Jvb2woYm9vbCAqZHN0LCBjb25zdCBzdHJ1Y3QgbmxhdHRyICphdHRyLAotCQkJ
CSAgICAgYm9vbCAqbW9kKQotewotCXU4IHZhbDsKLQotCWlmICghYXR0cikKLQkJcmV0dXJu
OwotCXZhbCA9ICEhbmxhX2dldF91OChhdHRyKTsKLQlpZiAoISEqZHN0ID09IHZhbCkKLQkJ
cmV0dXJuOwotCi0JKmRzdCA9IHZhbDsKLQkqbW9kID0gdHJ1ZTsKLX0KLQogLyoqCiAgKiBl
dGhubF91cGRhdGVfYmluYXJ5KCkgLSB1cGRhdGUgYmluYXJ5IGRhdGEgZnJvbSBOTEFfQklO
QVJZIGF0dHJpYnV0ZQogICogQGRzdDogIHZhbHVlIHRvIHVwZGF0ZQotLSAKMi4zOC4xCgo=


--------------huW3oKL2vytUMj2evfQ8dg0J--
