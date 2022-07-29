Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C61585486
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 19:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiG2Rcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 13:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiG2Rcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 13:32:31 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC66F1707F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:32:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bp15so9707940ejb.6
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=CFLaoRvSZHru3HQdsOGbY3058tzPt4G6aYxol0kgPGs=;
        b=uWliBo0qgFw+I0nh4swa/nkyX94E5W8BMd4QSYJTsoSiMXnCnNBBBGN9CDjbQ/MpnR
         2znotFdPC+Lll4RKxslsze+C+7tM1OWb/icwz2iTPbE+p9FsRDT4RHY0U6Y3fayyNjJ3
         C4crpev1cIyEhtSTj/Q0Ik9dwYORsqDfvMlkQO0GpNDhlBbHpiV6HKv0TlSHhqZ5eSl5
         oANOj5ASl8HXUqonPdTtgKEyoZ56A3Ox6/iGot7B8e1szn0WHxOGCebtLyPaLHkNQT+O
         IdfXhcdXr820dmCM3MnQ+F/lYlvEnsP7MKic7kX9alY7kSiLrPDG02xPvv2a1wl3EDjS
         KMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=CFLaoRvSZHru3HQdsOGbY3058tzPt4G6aYxol0kgPGs=;
        b=OHZr9fInpUZAZEyhLW8H0ol7T98U7gAwbwQLwOzOl3cxPagdJ7L7xXp/x/heQgHtD1
         xw5ops7qOvBl4ROGStm/838dkBtAWW4N5CfCWcDPR4cxUK6Wq0xIuA0e7ZqeQMSweTqt
         Q+sVHuSVdOf4pLMwZJz1kIl0P07eEiKigMYKnqM6AYVgouDWmm5F84+GdNVShvL6YyVG
         Hq2EEOJOYw4MeDBQeKVTZs8TS1bMcbJBh9OI/8AYnz/wzrZoydiz7f836hhD42tL6pkS
         c2PnfHQskefPei8mMl0FLPY/3faM17shkFQ2gPYD5ordVPmMNxfv3qq6p8FvesJ7t2K2
         fXcQ==
X-Gm-Message-State: AJIora8+eDdK3r5mwPIkhwuMY1q7lr3G69gbmnXQY4NfoSmOU3p/G0sO
        lemG3PPKDmomKuJBW6MJgC3/TbU39KuvmDKp
X-Google-Smtp-Source: AGRyM1uad1NlO4uqQqdZktk6GRJSEnWODQtcUbvo9bDm7FYnb5/lH7iAMLPHw+6is4M5GQ99Brx0cA==
X-Received: by 2002:a17:907:69b0:b0:72b:8e7b:6c2c with SMTP id ra48-20020a17090769b000b0072b8e7b6c2cmr3727742ejc.61.1659115948178;
        Fri, 29 Jul 2022 10:32:28 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:e755:980d:42b4:512c? ([2a02:578:8593:1200:e755:980d:42b4:512c])
        by smtp.gmail.com with ESMTPSA id ia9-20020a170907a06900b00722e7e48dfdsm1947227ejc.218.2022.07.29.10.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 10:32:27 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------cpt0pvXLjin79DJZvHPiCtD7"
Message-ID: <ffa2ea4f-dba9-5e44-95cb-4f4d3470884c@tessares.net>
Date:   Fri, 29 Jul 2022 19:32:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH net] ax25: fix incorrect dev_tracker usage
Content-Language: en-GB
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Bernard F6BVP <f6bvp@free.fr>,
        Duoming Zhou <duoming@zju.edu.cn>,
        MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220728051821.3160118-1-eric.dumazet@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220728051821.3160118-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------cpt0pvXLjin79DJZvHPiCtD7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 28/07/2022 07:18, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While investigating a separate rose issue [1], and enabling
> CONFIG_NET_DEV_REFCNT_TRACKER=y, Bernard reported an orthogonal ax25 issue [2]
> 
> An ax25_dev can be used by one (or many) struct ax25_cb.
> We thus need different dev_tracker, one per struct ax25_cb.
> 
> After this patch is applied, we are able to focus on rose.

FYI, we got a small conflict when merging -net in net-next in the MPTCP
tree due to this patch applied in -net:

  d7c4c9e075f8 ("ax25: fix incorrect dev_tracker usage")

and this one from net-next:

  d62607c3fe45 ("net: rename reference+tracking helpers")

The conflict has been resolved on our side[1] and the resolution we
suggest is attached to this email.

I'm sharing this thinking it can help others but if it only creates
noise, please tell me! :-)

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/b01791aa6b6c
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------cpt0pvXLjin79DJZvHPiCtD7
Content-Type: text/x-patch; charset=UTF-8;
 name="b01791aa6b6c783778b534f91997581a0e3caeb6.patch"
Content-Disposition: attachment;
 filename="b01791aa6b6c783778b534f91997581a0e3caeb6.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIG5ldC9heDI1L2FmX2F4MjUuYwppbmRleCBiYmFjM2NiNGRjOTksNWI1MzYz
Yzk5ZWQ1Li5kODJhNTFlNjkzODYKLS0tIGEvbmV0L2F4MjUvYWZfYXgyNS5jCisrKyBiL25l
dC9heDI1L2FmX2F4MjUuYwpAQEAgLTEwNjYsNyAtMTA2NSw3ICsxMDY2LDcgQEBAIHN0YXRp
YyBpbnQgYXgyNV9yZWxlYXNlKHN0cnVjdCBzb2NrZXQgKgogIAkJCWRlbF90aW1lcl9zeW5j
KCZheDI1LT50M3RpbWVyKTsKICAJCQlkZWxfdGltZXJfc3luYygmYXgyNS0+aWRsZXRpbWVy
KTsKICAJCX0KLSAJCW5ldGRldl9wdXQoYXgyNV9kZXYtPmRldiwgJmF4MjVfZGV2LT5kZXZf
dHJhY2tlcik7CiAtCQlkZXZfcHV0X3RyYWNrKGF4MjVfZGV2LT5kZXYsICZheDI1LT5kZXZf
dHJhY2tlcik7CisrCQluZXRkZXZfcHV0KGF4MjVfZGV2LT5kZXYsICZheDI1LT5kZXZfdHJh
Y2tlcik7CiAgCQlheDI1X2Rldl9wdXQoYXgyNV9kZXYpOwogIAl9CiAgCkBAQCAtMTE0Nyw3
IC0xMTQ2LDcgKzExNDcsNyBAQEAgc3RhdGljIGludCBheDI1X2JpbmQoc3RydWN0IHNvY2tl
dCAqc29jCiAgCiAgCWlmIChheDI1X2RldikgewogIAkJYXgyNV9maWxsaW5fY2IoYXgyNSwg
YXgyNV9kZXYpOwotIAkJbmV0ZGV2X2hvbGQoYXgyNV9kZXYtPmRldiwgJmF4MjVfZGV2LT5k
ZXZfdHJhY2tlciwgR0ZQX0FUT01JQyk7CiAtCQlkZXZfaG9sZF90cmFjayhheDI1X2Rldi0+
ZGV2LCAmYXgyNS0+ZGV2X3RyYWNrZXIsIEdGUF9BVE9NSUMpOworKwkJbmV0ZGV2X2hvbGQo
YXgyNV9kZXYtPmRldiwgJmF4MjUtPmRldl90cmFja2VyLCBHRlBfQVRPTUlDKTsKICAJfQog
IAogIGRvbmU6Cg==

--------------cpt0pvXLjin79DJZvHPiCtD7--
