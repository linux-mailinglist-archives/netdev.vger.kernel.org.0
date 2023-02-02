Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741A66878BB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjBBJZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjBBJYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:24:37 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BA16F738
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:24:13 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so3233203wma.1
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=loFRZrXnz+aOvOnIW1TDeotB4dD8Rm1UFKhNxjH6JWg=;
        b=HaqlQBXO+AKhs8sLL5wO2ZQt2UNfLwo7YX3PnQ/V3Dahgs+2VFOTCmd+7LQXYZ4sP0
         Yk6K5YN7nTcr078+hhT6UvMRIBHx8AvDutQ4sfLDoA91Wv8FGYLXvqSE/zUqTrqD97o5
         pGY9a/5Z7TXhEGKYvJKTBlvBYEnJ3mZ/5n+qOFJcKHC08uIDBNmE9fhLfce16rgg86ZA
         42aD0ygkbNQHhuzRVOO19l7jkJaNU4pSW237B+Dlc60J2QInqZVHMCxp4zJt0BH36cIx
         5yq5iH+mY3VGAw3kr96fX3R159DlNSfcyeDgvUGyxpR25eYAzZ3jnx6CHbmy7v/t/X/z
         5k2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=loFRZrXnz+aOvOnIW1TDeotB4dD8Rm1UFKhNxjH6JWg=;
        b=nPawq+HTGIUuNtzU1CYyAjvTp29lLj73Wv2fdJMw8AHOTTCusuG6CtNBjKgya09vBW
         zH6JctL+GlElounxhLjc57Ffv4kce+UL8rlB8tvV6cV2jV4hLGnr5AubGrET93UGcqb7
         qaOnMGMPsHmj69oOLTkVT2AqUOCo+mMbVpG6lSEpjMSpjvYNMzSbHJnLCa31Anzs+71o
         yFC+9SRp0BAy6OSY7E4t7suVNrMH5qYmn3FEXR1FT90VwMHVV7kg2PORgF9jFuI4o6pr
         A8tDAmf8Lk8F5nuKPDhuYHEMS44TYNfankFZXVQSxfvQw8UPB4vWOJpL38ERemctwDh7
         VKWA==
X-Gm-Message-State: AO0yUKWMiX/53WXKhoVs8Xf+hUVd2h9m85IG1dM6XyhAJHAoq+da5zM/
        isSj9cQpH/A4Ru9XEv2X/7pJgw==
X-Google-Smtp-Source: AK7set/M7wjRuuTzBhhvQBdAOXsn0HcmQfarQb5W3PUfCmezJJb8GjNiE8FbdtajckfyF6asGOASag==
X-Received: by 2002:a05:600c:4f90:b0:3db:419:8d3b with SMTP id n16-20020a05600c4f9000b003db04198d3bmr5436362wmq.39.1675329851845;
        Thu, 02 Feb 2023 01:24:11 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:8c67:99af:2126:3484? ([2a02:578:8593:1200:8c67:99af:2126:3484])
        by smtp.gmail.com with ESMTPSA id m13-20020a05600c3b0d00b003dc51c48f0bsm4648019wms.19.2023.02.02.01.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 01:24:11 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------oV0eRJy1Z2K0jCbLOUihV4mA"
Message-ID: <de811bf3-e2d8-f727-72bc-c8a754a9d929@tessares.net>
Date:   Thu, 2 Feb 2023 10:24:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCHv4 net-next 10/10] net: add support for ipv4 big tcp:
 manual merge
Content-Language: en-GB
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cover.1674921359.git.lucien.xin@gmail.com>
 <637aa55b8dbf0c85c2ee8892df26a8bbbf9f2ef5.1674921359.git.lucien.xin@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <637aa55b8dbf0c85c2ee8892df26a8bbbf9f2ef5.1674921359.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------oV0eRJy1Z2K0jCbLOUihV4mA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

(I reduced the Cc list to the maintainers of the files modified by this
patch)

On 28/01/2023 16:58, Xin Long wrote:
> Similar to Eric's IPv6 BIG TCP, this patch is to enable IPv4 BIG TCP.
> 
> Firstly, allow sk->sk_gso_max_size to be set to a value greater than
> GSO_LEGACY_MAX_SIZE by not trimming gso_max_size in sk_trim_gso_size()
> for IPv4 TCP sockets.
> 
> Then on TX path, set IP header tot_len to 0 when skb->len > IP_MAX_MTU
> in __ip_local_out() to allow to send BIG TCP packets, and this implies
> that skb->len is the length of a IPv4 packet; On RX path, use skb->len
> as the length of the IPv4 packet when the IP header tot_len is 0 and
> skb->len > IP_MAX_MTU in ip_rcv_core(). As the API iph_set_totlen() and
> skb_ip_totlen() are used in __ip_local_out() and ip_rcv_core(), we only
> need to update these APIs.
> 
> Also in GRO receive, add the check for ETH_P_IP/IPPROTO_TCP, and allows
> the merged packet size >= GRO_LEGACY_MAX_SIZE in skb_gro_receive(). In
> GRO complete, set IP header tot_len to 0 when the merged packet size
> greater than IP_MAX_MTU in iph_set_totlen() so that it can be processed
> on RX path.
> 
> Note that by checking skb_is_gso_tcp() in API iph_totlen(), it makes
> this implementation safe to use iph->len == 0 indicates IPv4 BIG TCP
> packets.

(...)

> diff --git a/net/core/gro.c b/net/core/gro.c
> index 506f83d715f8..b15f85546bdd 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -162,16 +162,18 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  	struct sk_buff *lp;
>  	int segs;
>  
> -	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
> -	gro_max_size = READ_ONCE(p->dev->gro_max_size);
> +	/* pairs with WRITE_ONCE() in netif_set_gro(_ipv4)_max_size() */
> +	gro_max_size = p->protocol == htons(ETH_P_IPV6) ?
> +			READ_ONCE(p->dev->gro_max_size) :
> +				READ_ONCE(p->dev->gro_ipv4_max_size);
>  
FYI, we got a small conflict when merging -net in net-next in the MPTCP
tree due to another patch from -net:

  7d2c89b32587 ("skb: Do mix page pool and page referenced frags in GRO")

and this one applied in net-next:

  b1a78b9b9886 ("net: add support for ipv4 big tcp")

The conflict has been resolved on our side[1] by keeping the
modifications from both sides and the resolution we suggest is attached
to this email.

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/56e08652439a
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------oV0eRJy1Z2K0jCbLOUihV4mA
Content-Type: text/x-patch; charset=UTF-8;
 name="56e08652439ad5b87d5dc668e8a40ab934b58a45.patch"
Content-Disposition: attachment;
 filename="56e08652439ad5b87d5dc668e8a40ab934b58a45.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIG5ldC9jb3JlL2dyby5jCmluZGV4IDRiYWM3ZWE2ZTAyNSxiMTVmODU1NDZi
ZGQuLmJiMjhmNDAzOGVkNAotLS0gYS9uZXQvY29yZS9ncm8uYworKysgYi9uZXQvY29yZS9n
cm8uYwpAQEAgLTE2MiwxNyAtMTYyLDEwICsxNjIsMTkgQEBAIGludCBza2JfZ3JvX3JlY2Vp
dmUoc3RydWN0IHNrX2J1ZmYgKnAsIAogIAlzdHJ1Y3Qgc2tfYnVmZiAqbHA7CiAgCWludCBz
ZWdzOwogIAogKwkvKiBEbyBub3Qgc3BsaWNlIHBhZ2UgcG9vbCBiYXNlZCBwYWNrZXRzIHcv
IG5vbi1wYWdlIHBvb2wKICsJICogcGFja2V0cy4gVGhpcyBjYW4gcmVzdWx0IGluIHJlZmVy
ZW5jZSBjb3VudCBpc3N1ZXMgYXMgcGFnZQogKwkgKiBwb29sIHBhZ2VzIHdpbGwgbm90IGRl
Y3JlbWVudCB0aGUgcmVmZXJlbmNlIGNvdW50IGFuZCB3aWxsCiArCSAqIGluc3RlYWQgYmUg
aW1tZWRpYXRlbHkgcmV0dXJuZWQgdG8gdGhlIHBvb2wgb3IgaGF2ZSBmcmFnCiArCSAqIGNv
dW50IGRlY3JlbWVudGVkLgogKwkgKi8KICsJaWYgKHAtPnBwX3JlY3ljbGUgIT0gc2tiLT5w
cF9yZWN5Y2xlKQogKwkJcmV0dXJuIC1FVE9PTUFOWVJFRlM7CiArCi0gCS8qIHBhaXJzIHdp
dGggV1JJVEVfT05DRSgpIGluIG5ldGlmX3NldF9ncm9fbWF4X3NpemUoKSAqLwotIAlncm9f
bWF4X3NpemUgPSBSRUFEX09OQ0UocC0+ZGV2LT5ncm9fbWF4X3NpemUpOworIAkvKiBwYWly
cyB3aXRoIFdSSVRFX09OQ0UoKSBpbiBuZXRpZl9zZXRfZ3JvKF9pcHY0KV9tYXhfc2l6ZSgp
ICovCisgCWdyb19tYXhfc2l6ZSA9IHAtPnByb3RvY29sID09IGh0b25zKEVUSF9QX0lQVjYp
ID8KKyAJCQlSRUFEX09OQ0UocC0+ZGV2LT5ncm9fbWF4X3NpemUpIDoKKyAJCQkJUkVBRF9P
TkNFKHAtPmRldi0+Z3JvX2lwdjRfbWF4X3NpemUpOwogIAogIAlpZiAodW5saWtlbHkocC0+
bGVuICsgbGVuID49IGdyb19tYXhfc2l6ZSB8fCBOQVBJX0dST19DQihza2IpLT5mbHVzaCkp
CiAgCQlyZXR1cm4gLUUyQklHOwo=

--------------oV0eRJy1Z2K0jCbLOUihV4mA--
