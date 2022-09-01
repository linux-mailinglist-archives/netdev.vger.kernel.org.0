Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514FB5A940C
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbiIAKPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiIAKPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:15:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EF44056D
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 03:15:05 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gb36so12767674ejc.10
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 03:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=epf+Q54XZk9zXGQT4gxazcQCwv6mPJH3vEMEJMYkLpQ=;
        b=svWAOc6qtTPFNYvoedLJ0EIDEBYH3VtuN1KYrRdz/3ux3M262vUBk9X9A7+PD/sRBo
         P8KzzDb3pp0d+okHiisztAe7LJelmTgk6//R4KBTId+WZpF9yvtrYQ+lUhNcK/S4BS6H
         HSkja6e/5Qw8GRVwqPB+r+8/xcBZqHyiN0P7SvWyPCIRG6rZziKGJMO/DmZVXHRyncPw
         zrTYtyGxxl2NSyXh0b5e8CaTHgnjK2Nc+0tWWdrL3WHo2jkgHXa/6GrxzJlHjdOo3z3b
         Oou0im51I/7GRaOj2tr9le0YMylGFAlZdp4pDT12DEdgp+9LvmLMbvaC0b5bXcA+beRa
         uqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=epf+Q54XZk9zXGQT4gxazcQCwv6mPJH3vEMEJMYkLpQ=;
        b=opVY4+NfvoYcO0a4oq/3t3QbemJhLQhDXpe+g6lXhduseCDlMf19YVMAJ4i5g/wr8/
         dq4yw0bBrOw7j09OS93lNcSPcUa2WkWCQ/9S9f0ne23mlGWfictZBkszq1xDBRvldJj8
         2OgLT0EhHBBr9i1j61z4tMenFjmPH+YsjUB9bZ8W3SW4o+S79B97iocT7ohDidaQfRz4
         7ummDVcDoqYdonuIvOVVMFI+pLll2FNWSOS2cxYro+IIxaOwnD3/68ps6lL8xnTC02nj
         VgnEfe73dPOaXjqLTAXiFZ50Vi/88UWcxviVybvK9qBhU2r3suGYkihNpg70TsBrnIZm
         qZdQ==
X-Gm-Message-State: ACgBeo0qYz8IKxl5t3tQw4cOT2SGxVvDROSns5FmR1xkVJrLtuxEAAnh
        7ZZz4DrjRFfZvyIiz2AzEcHtmQ==
X-Google-Smtp-Source: AA6agR74hR8VaeJjFAVTZB4MQZJXrrmv36R1guca2wRROCvCmMqo8rBjX09cx+YesnyaqkBZQPKS0g==
X-Received: by 2002:a17:906:38f:b0:742:1f68:7058 with SMTP id b15-20020a170906038f00b007421f687058mr9223162eja.743.1662027304180;
        Thu, 01 Sep 2022 03:15:04 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:d4bf:4e1a:6131:785b? ([2a02:578:8593:1200:d4bf:4e1a:6131:785b])
        by smtp.gmail.com with ESMTPSA id dy17-20020a05640231f100b0043cc66d7accsm1084568edb.36.2022.09.01.03.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 03:15:03 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------RMx9DqSYj6g7kmVmU6k70eT3"
Message-ID: <fe9280ff-50b3-805a-07ef-0227cbec13e8@tessares.net>
Date:   Thu, 1 Sep 2022 12:15:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] selftests: net: sort .gitignore file
Content-Language: en-GB
To:     Axel Rasmussen <axelrasmussen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220829184748.1535580-1-axelrasmussen@google.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220829184748.1535580-1-axelrasmussen@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------RMx9DqSYj6g7kmVmU6k70eT3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 29/08/2022 20:47, Axel Rasmussen wrote:
> This is the result of `sort tools/testing/selftests/net/.gitignore`, but
> preserving the comment at the top.

FYI, we got a small conflict (as expected by Jakub) when merging -net in
net-next in the MPTCP tree due to this patch applied in -net:

  5a3a59981027 ("selftests: net: sort .gitignore file")

and these ones from net-next:

  c35ecb95c448 ("selftests/net: Add test for timing a bind request to a
port with a populated bhash entry")
  1be9ac87a75a ("selftests/net: Add sk_bind_sendto_listen and
sk_connect_zero_addr")

The conflict has been resolved on our side[1] and the resolution we
suggest is attached to this email: new entries have been added in the
list respecting the alphabetical order.

I'm sharing this thinking it can help others but if it only creates
noise, please tell me! :-)

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/4151695b70b6
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------RMx9DqSYj6g7kmVmU6k70eT3
Content-Type: text/x-patch; charset=UTF-8;
 name="4151695b70b6889c0be046fc6b861f4fba2efff7.patch"
Content-Disposition: attachment;
 filename="4151695b70b6889c0be046fc6b861f4fba2efff7.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL25ldC8uZ2l0aWdub3JlCmluZGV4
IGJlYzVjZjk2OTg0YyxkZTdkNWNjMTVmODUuLjNkN2FkZWU3YTNlNgotLS0gYS90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9uZXQvLmdpdGlnbm9yZQorKysgYi90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9uZXQvLmdpdGlnbm9yZQpAQEAgLTEsNyAtMSwxNSArMSwxNiBAQEAKICAjIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKytiaW5kX2JoYXNoCisgY21z
Z19zZW5kZXIKKyBmaW5fYWNrX2xhdAorIGdybworIGh3dHN0YW1wX2NvbmZpZworIGlvYW02
X3BhcnNlcgorIGlwX2RlZnJhZwogIGlwc2VjCisgaXB2Nl9mbG93bGFiZWwKKyBpcHY2X2Zs
b3dsYWJlbF9tZ3IKICBtc2dfemVyb2NvcHkKLSBzb2NrZXQKKyBuZXR0ZXN0CiAgcHNvY2tf
ZmFub3V0CiAgcHNvY2tfc25kCiAgcHNvY2tfdHBhY2tldApAQEAgLTExLDM1IC0yMCwyMyAr
MjEsMjUgQEBAIHJldXNlcG9ydF9icAogIHJldXNlcG9ydF9icGZfY3B1CiAgcmV1c2Vwb3J0
X2JwZl9udW1hCiAgcmV1c2Vwb3J0X2R1YWxzdGFjawotIHJldXNlYWRkcl9jb25mbGljdAot
IHRjcF9tbWFwCi0gdWRwZ3NvCi0gdWRwZ3NvX2JlbmNoX3J4Ci0gdWRwZ3NvX2JlbmNoX3R4
Ci0gdGNwX2lucQotIHRscwotIHR4cmluZ19vdmVyd3JpdGUKLSBpcF9kZWZyYWcKLSBpcHY2
X2Zsb3dsYWJlbAotIGlwdjZfZmxvd2xhYmVsX21ncgotIHNvX3R4dGltZQotIHRjcF9mYXN0
b3Blbl9iYWNrdXBfa2V5Ci0gbmV0dGVzdAotIGZpbl9hY2tfbGF0Ci0gcmV1c2VhZGRyX3Bv
cnRzX2V4aGF1c3RlZAotIGh3dHN0YW1wX2NvbmZpZwogIHJ4dGltZXN0YW1wCi0gdGltZXN0
YW1waW5nCi0gdHh0aW1lc3RhbXAKKytza19iaW5kX3NlbmR0b19saXN0ZW4KKytza19jb25u
ZWN0X3plcm9fYWRkcgorIHNvY2tldAogIHNvX25ldG5zX2Nvb2tpZQorIHNvX3R4dGltZQor
IHN0cmVzc19yZXVzZXBvcnRfbGlzdGVuCisgdGFwCisgdGNwX2Zhc3RvcGVuX2JhY2t1cF9r
ZXkKKyB0Y3BfaW5xCisgdGNwX21tYXAKICB0ZXN0X3VuaXhfb29iCi0gZ3JvCi0gaW9hbTZf
cGFyc2VyCisgdGltZXN0YW1waW5nCisgdGxzCiAgdG9lcGxpdHoKICB0dW4KLSBjbXNnX3Nl
bmRlcgorIHR4cmluZ19vdmVyd3JpdGUKKyB0eHRpbWVzdGFtcAorIHVkcGdzbworIHVkcGdz
b19iZW5jaF9yeAorIHVkcGdzb19iZW5jaF90eAogIHVuaXhfY29ubmVjdAotIHRhcAotIGJp
bmRfYmhhc2gKLSBza19iaW5kX3NlbmR0b19saXN0ZW4KLSBza19jb25uZWN0X3plcm9fYWRk
cgo=

--------------RMx9DqSYj6g7kmVmU6k70eT3--
