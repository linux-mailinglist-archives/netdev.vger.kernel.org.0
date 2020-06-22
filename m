Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1FB20386E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgFVNtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgFVNtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:49:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821C0C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 06:49:12 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b6so16740435wrs.11
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 06:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dCUfgqhsIBfYRt1nCaxuonUF0k6Z8yysP7m75v42F9I=;
        b=VaYyJ8tm1crnVTxJP23VCAFdl2rB6SLudeUXPjxoHI6OCOXcdwaJCDWLSJZHArO6Ax
         YNyWivT8g+L+MFUlLfzrN6gcs24J/m17a4ZoGkGHdtKXS1DtFhW/ikN/bFztag5/c3WN
         6nRiyBnsFEQ77mCXT2s/8hmCZTJt3jSisPIhd8XrMdl0LxM4L+D5QymvIgFvG9vE+MLu
         9ueOkhXah0OCjAGt0TEYPVcOftbKuoxeiTwSWL7e/pHUsvCIEtEfeDcAaK6RWZO0BD4d
         QJP0jtBxuResydMDDBvaLLd5ZTU4ZvYZjdTlR450bDP+BZcIfsx5HvbMUTrKXyehveiQ
         da0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dCUfgqhsIBfYRt1nCaxuonUF0k6Z8yysP7m75v42F9I=;
        b=LTWIbJ9Qfn06TyLoiDxBDkAGFcnCFzMiqxH8EWQKiQa5gc5XYVQ8Wg6wjbIgNyebdn
         q3yHvRQdaadpimIOp/JuY3Bhdm2zEBpnc6YU09m2dDtyUz5gN1dBZPIVAfntiO5IuPL3
         mXllmb0QkRosvSiz+/Tn5GPKYFF1OpvFbJK24XuG0o/pp0u++dtV9GjJO38gpv4+Wk3z
         iIbwYUD50N/UE79+LLCK/vqPIs99gW8GKLA/9XUWHseNf6qz/9p+OC+2wRqNhB7DJHfK
         oGbxZqrquE6PpeAUz3lEkU2+CcK7btTPetb6kVC6CgKJqPrwrPtiTA61uUSyu4ih1n+u
         TZGg==
X-Gm-Message-State: AOAM531yKdBFYte5qMleWGVprfRIJ+bQvS1keNatFYFmdgyEaJ++qVsF
        3RfcXTAMxxNOSeZi9assLwlIDm5lYys=
X-Google-Smtp-Source: ABdhPJwNjyHjFiMU6rlx4eRpL2JpBqXKH89iKpDiSmRIM0ExxLSZ/YSdmnlu4185ts8mgKxYkcJPDA==
X-Received: by 2002:a5d:4710:: with SMTP id y16mr19720805wrq.189.1592833750138;
        Mon, 22 Jun 2020 06:49:10 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:f963:90c2:d1cc:bba3? ([2a01:e0a:410:bb00:f963:90c2:d1cc:bba3])
        by smtp.gmail.com with ESMTPSA id c6sm17638595wma.15.2020.06.22.06.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 06:49:09 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] rtnetlink: add keepalived rtm_protocol
To:     Alexandre Cassen <acassen@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        nikolay@cumulusnetworks.com, idosch@mellanox.com,
        dsahern@gmail.com, vladbu@mellanox.com
References: <20200621153454.3325-1-acassen@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a3e81bc7-1915-bbe7-5b56-367617ecfc2e@6wind.com>
Date:   Mon, 22 Jun 2020 15:49:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200621153454.3325-1-acassen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/06/2020 à 17:34, Alexandre Cassen a écrit :
[snip]
> +#define RTPROT_GATED		8	/* Apparently, GateD */
> +#define RTPROT_RA		9	/* RDISC/ND router advertisements */
> +#define RTPROT_MRT		10	/* Merit MRT */
> +#define RTPROT_ZEBRA		11	/* Zebra */
> +#define RTPROT_BIRD		12	/* BIRD */
> +#define RTPROT_DNROUTED		13	/* DECnet routing daemon */
> +#define RTPROT_XORP		14	/* XORP */
> +#define RTPROT_NTK		15	/* Netsukuku */
> +#define RTPROT_DHCP		16      /* DHCP client */
nit: if you reident everything, you can fix spaces vs tabs between the number
and the comment. Starting from '16', it's spaces, it was one tab before.

> +#define RTPROT_MROUTED		17      /* Multicast daemon */
> +#define RTPROT_KEEPALIVED	18      /* Keepalived daemon */
> +#define RTPROT_BABEL		42      /* Babel daemon */
> +#define RTPROT_BGP		186     /* BGP Routes */
> +#define RTPROT_ISIS		187     /* ISIS Routes */
> +#define RTPROT_OSPF		188     /* OSPF Routes */
> +#define RTPROT_RIP		189     /* RIP Routes */
> +#define RTPROT_EIGRP		192     /* EIGRP Routes */
>  
>  /* rtm_scope
>  
> 
