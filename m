Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA4356C83B
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 11:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiGIJLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIJLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 05:11:53 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22F3545EE
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 02:11:51 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ez10so1277067ejc.13
        for <netdev@vger.kernel.org>; Sat, 09 Jul 2022 02:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=GwRPDPz0wAqQuQjReGGFUUa9OBEO/j7dclJ1wvnbWbw=;
        b=3Bk7y61bJci89ZJ+gdYXv/2I2Jd2H107ZgBpjScH3iI0MvbkdyNoFcIWlrEWTU+jHi
         sOyDWGsQZSVr58Nwhv30399lkGvsSY2T5wh3bw0vteP3vfYQMjy6qnrEzVxwz1BRbCGL
         FcMEaJFEI+vHHH4aOsmLrNqg8sDJY78xw6zBEucJoR7pVc+F9BqhoWS1G1DO4jI/ZEQi
         pbBy3ATNb5ZEbfNIp59CTRxcOYn2aUoprsExPnCOWiC4Y893cGlZrEf51ifyWB5U38rR
         lB3fhZ6uepYs9Wadql+/NECLavybhDnZAXCP1Ut9suIE9nn8LemPquOuiVYksMRcToGz
         1AEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=GwRPDPz0wAqQuQjReGGFUUa9OBEO/j7dclJ1wvnbWbw=;
        b=FOSqAjS5AHxd8A9rcbFyaayuAQN4xhH84ic4fHGAm/XBcGdbI/p4p1EtkkcfKfoszF
         SgRgVum0JCSjMF8GUf4+vOM+olsTLObEK5mfizxxToq9J3lHKc+PEAQ7hcDa4oi7iinN
         KUSiIYs3JEZonh3osMzjv4ItDgoV2KJGT+UkKKfG35FrA+hftttwGQZeDCX8Fhx/fmYB
         EUfilQosCTypsJ8PJ32KF+WejchmbB7MnlRGalMQOYUqy3xINQGKGF0zOPrGyJ09sief
         z2+0YVnm4foFCIVZg+QzfOzUN2mDYqzH5JcJtZNMw4OPNrBC0RReEiUcY5VKhyDoBK1M
         pv/w==
X-Gm-Message-State: AJIora8lnF5IVxetD4jYODkTUxl/+aHXX8pQhULiKFIHJKECu8Hlun3+
        8YyVH0FKkTVHqQobP/A89/3CXA==
X-Google-Smtp-Source: AGRyM1vI7m5nS7zEdVam2tmvN320LNjtUyI/YEZCStnztWbPDuR7Wt5qMJTystEcWIBSj3QF/E84fg==
X-Received: by 2002:a17:906:cc52:b0:72b:114e:c56c with SMTP id mm18-20020a170906cc5200b0072b114ec56cmr8008533ejb.144.1657357909909;
        Sat, 09 Jul 2022 02:11:49 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:e51f:3772:e05:89c3? ([2a02:578:8593:1200:e51f:3772:e05:89c3])
        by smtp.gmail.com with ESMTPSA id y26-20020a056402135a00b00435a742e350sm636472edw.75.2022.07.09.02.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jul 2022 02:11:49 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------3cL3LDjvU14fMcomcm3uA5J9"
Message-ID: <6dddf3f2-40c1-a08b-ec0e-c4feafcad118@tessares.net>
Date:   Sat, 9 Jul 2022 11:11:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net 09/12] net: Fix data-races around sysctl_mem.
Content-Language: en-GB
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220706234003.66760-1-kuniyu@amazon.com>
 <20220706234003.66760-10-kuniyu@amazon.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220706234003.66760-10-kuniyu@amazon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------3cL3LDjvU14fMcomcm3uA5J9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 07/07/2022 01:40, Kuniyuki Iwashima wrote:
> While reading .sysctl_mem, it can be changed concurrently.
> So, we need to add READ_ONCE() to avoid data-races.

FYI, we got a small conflict when merging -net in net-next in the MPTCP
tree due to this patch applied in -net:

  310731e2f161 ("net: Fix data-races around sysctl_mem.")

and this one from net-next:

  e70f3c701276 ("Revert "net: set SK_MEM_QUANTUM to 4096"")

The conflict has been resolved on our side[1] and the resolution we
suggest is attached to this email.

I'm sharing this thinking it can help others but if it only creates
noise, please tell me! :)

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/b01bda9d0fe6
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------3cL3LDjvU14fMcomcm3uA5J9
Content-Type: text/x-patch; charset=UTF-8; name="b01bda9d0fe6.patch"
Content-Disposition: attachment; filename="b01bda9d0fe6.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIGluY2x1ZGUvbmV0L3NvY2suaAppbmRleCAwZGQ0M2MzZGY0OWIsOWZhNTQ3
NjJlMDc3Li5mN2FkMWE3NzA1ZTkKLS0tIGEvaW5jbHVkZS9uZXQvc29jay5oCisrKyBiL2lu
Y2x1ZGUvbmV0L3NvY2suaApAQEAgLTE1NDEsMTAgLTE1MjEsMjIgKzE1NDEsMTAgQEBAIHZv
aWQgX19za19tZW1fcmVjbGFpbShzdHJ1Y3Qgc29jayAqc2ssIAogICNkZWZpbmUgU0tfTUVN
X1NFTkQJMAogICNkZWZpbmUgU0tfTUVNX1JFQ1YJMQogIAogLS8qIHN5c2N0bF9tZW0gdmFs
dWVzIGFyZSBpbiBwYWdlcywgd2UgY29udmVydCB0aGVtIGluIFNLX01FTV9RVUFOVFVNIHVu
aXRzICovCiArLyogc3lzY3RsX21lbSB2YWx1ZXMgYXJlIGluIHBhZ2VzICovCiAgc3RhdGlj
IGlubGluZSBsb25nIHNrX3Byb3RfbWVtX2xpbWl0cyhjb25zdCBzdHJ1Y3Qgc29jayAqc2ss
IGludCBpbmRleCkKICB7Ci0gCXJldHVybiBzay0+c2tfcHJvdC0+c3lzY3RsX21lbVtpbmRl
eF07CiAtCWxvbmcgdmFsID0gUkVBRF9PTkNFKHNrLT5za19wcm90LT5zeXNjdGxfbWVtW2lu
ZGV4XSk7CiAtCiAtI2lmIFBBR0VfU0laRSA+IFNLX01FTV9RVUFOVFVNCiAtCXZhbCA8PD0g
UEFHRV9TSElGVCAtIFNLX01FTV9RVUFOVFVNX1NISUZUOwogLSNlbGlmIFBBR0VfU0laRSA8
IFNLX01FTV9RVUFOVFVNCiAtCXZhbCA+Pj0gU0tfTUVNX1FVQU5UVU1fU0hJRlQgLSBQQUdF
X1NISUZUOwogLSNlbmRpZgogLQlyZXR1cm4gdmFsOworKwlyZXR1cm4gUkVBRF9PTkNFKHNr
LT5za19wcm90LT5zeXNjdGxfbWVtW2luZGV4XSk7CiAgfQogIAogIHN0YXRpYyBpbmxpbmUg
aW50IHNrX21lbV9wYWdlcyhpbnQgYW10KQo=

--------------3cL3LDjvU14fMcomcm3uA5J9--
