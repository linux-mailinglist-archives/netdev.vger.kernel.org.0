Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124A82A2E6B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgKBPhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgKBPhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:37:41 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9D4C0617A6;
        Mon,  2 Nov 2020 07:37:41 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id q1so13315827ilt.6;
        Mon, 02 Nov 2020 07:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vAr6f3rk2m6s3RlNrQL28+h//uL+fh6usGfj7i4rrbo=;
        b=PL7qiPJIhzxpx6wY9YM3nScn0rynwqM2CXOZgJDjoAf0OdtsiL3QsAlx8UyJVl3vm4
         7IMF7Iey0XN3NJKMj8BolYqaKlcn2diTTm0/w/eHTjo+5vEfXG1Y1S5Fj64q0sjkKIDs
         XWPt6ZF9ZxWOS6Lig6NL0bqvq9LP3UW7ftbd3moyca4Ne2E/DZ2m62eESAd5ljwE15E+
         wSvJZuYucBQSRhbPS2fvpPMESERZeRJ15HncS8q6hwcMliw3DwGPH46rxmk3cZf/elo8
         Aqn4vOb04hyLhxYOPIoOUtqR/ZWDmu7Gz6usVk8K54hH9k8TaNfov8D/78g5W4Srifxm
         yVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAr6f3rk2m6s3RlNrQL28+h//uL+fh6usGfj7i4rrbo=;
        b=HCJQG4RhpkYDwS7Mvy5XNybCUNzNIaDkA2mnGLpCCQ12VAZAYI60I4rwwHmp9LdiCb
         U3pCegkUAIlLxoBVfapFAlxs7GR+bMJWXLI2/7NjJ92LbBLIB50H/v7+OOY6rHhT1yW9
         5QPfamnl5bk4kSoakmX0O8aH/JMXMCXtWlabrs42k+pfBypbRsg9f6yrb9OSc5aWI/ht
         dxj/zNC9zJ7FCuGrsoa9sQwZPc/YLmIH6k1fD1w2/m/p8uNuEfl+/mP7n2b+Rb036gTX
         uVjqYaywKkLlVPgOmdQMbW6ddgxhxuhtFxkzsOXBFCLxfstaRwbYlLwqF/NgwU3NqsKF
         pv/Q==
X-Gm-Message-State: AOAM5334wChISHs1kLdLecUrkpnkuM9njVZL1MoIyhUlNPoPtfeASFHu
        JLp6GlzmxUj7AsnIhQ6nYBY=
X-Google-Smtp-Source: ABdhPJzJOxR064sEJLlVMTknEqP9P5lmLpEDnOUj5paEL27N2UYgryaabq5hJJMc/09pJqE24qr2YQ==
X-Received: by 2002:a92:a808:: with SMTP id o8mr10093763ilh.35.1604331460938;
        Mon, 02 Nov 2020 07:37:40 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id m9sm8208917ioc.15.2020.11.02.07.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 07:37:40 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 1/5] configure: add check_libbpf() for
 later libbpf support
To:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-2-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <78c5df29-bf06-0b60-d914-bdab3d65b198@gmail.com>
Date:   Mon, 2 Nov 2020 08:37:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201029151146.3810859-2-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 9:11 AM, Hangbin Liu wrote:
> This patch adds a check to see if we support libbpf. By default the
> system libbpf will be used, but static linking against a custom libbpf
> version can be achieved by passing LIBBPF_DIR to configure. FORCE_LIBBPF
> can be set to force configure to abort if no suitable libbpf is found,
> which is useful for automatic packaging that wants to enforce the
> dependency.
> 

Add an option to force libbpf off and use of the legacy code. i.e, yes
it is installed, but don't use it.

configure script really needs a usage to dump options like disabling libbpf.
