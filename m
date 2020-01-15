Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1028513C371
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgAONn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:43:58 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40267 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgAONn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 08:43:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so15788798wrn.7
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 05:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+bIktTy8LlyrRqF8b/vertBAS9MUpHVmFOpWz9W0d8=;
        b=Dt8krYgo53X0dW65XNW9a3kgE4MG1xKUtArBia8oi0PBnQkJnck/VnA1kGP1Fz7keq
         cp3ZZW7NHTAF6yDURTVkIR5KbsjtN3ThnBkr1wEbAUkFN5XtJjlDlI3F4AmNLKy2LzFR
         QXsFIp6/RstqgZ/VAkZ8/MUh9C76dNNE+rGUDhAgvIT8Buk4X8Awm4nx3ngjBgRKm+8n
         NIDDHfBuop4H2Sp57BnKQkNGZTf6aAiONAy+e/PaWxF0041G914INXb9GnozENzbbhNw
         i/DbpXcBoZKTljTYh/P6rF95A56DP2WJtt0nNzSNSMKhVbYGV2kDc+X7yckIcFTM3su+
         WtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=P+bIktTy8LlyrRqF8b/vertBAS9MUpHVmFOpWz9W0d8=;
        b=dswPCvM/fYcJGnZSzR2DYS7SZChJL//6/fcmiPPWu8nk2MX34tHfzHw3T9a02saAhI
         eR6pIbNZh5QTSv8Ar3Wsn2rq+zUXttPBAO0huUvJdZHWdVSbRJmvaa9ztOlCvQ8HE7Nd
         Z1u8poQyrl17u/UKHiBoaL6b14+cpKlttz1ZTUG9SYEehofZp/GXqYTYLmRN3XejnKQ2
         Kms2/Ycv8t9NKaZgC/afGJw4MXnQJchEmXU+VuQ3wSXfGMiuUmpD7XXaPpk6gIzQzeEh
         TloNLvojVZ2nIGg45MyQ+ccfeByLUY5ivULv/2a6GMplrGrkMGyzDogB1JJ9FwEf71YP
         7UVQ==
X-Gm-Message-State: APjAAAVJP5yMGdbWvgX4+7/I8VznL6gckNPPL0v6au+wmHrKLn9MbKru
        clEGEFU9C3aTmgW/luoc/32dBK66ZbI=
X-Google-Smtp-Source: APXvYqzW4zLTzGyosGPT0LeSOocuZuGf8uC0ynKnNf8nFR9ubL+2w6fO+HSl/UKFrz8yvoQKWWxwBQ==
X-Received: by 2002:a5d:5704:: with SMTP id a4mr31240190wrv.198.1579095835534;
        Wed, 15 Jan 2020 05:43:55 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:d497:1e4d:f822:7486? ([2a01:e0a:410:bb00:d497:1e4d:f822:7486])
        by smtp.gmail.com with ESMTPSA id i11sm25287148wrs.10.2020.01.15.05.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 05:43:54 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 2/2] netns: constify exported functions
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <cover.1579040200.git.gnault@redhat.com>
 <bc4093c61a90c8c900b43fb35e57233da86f5500.1579040200.git.gnault@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <e3009d2a-949a-96b6-f5f9-1ff03a9ea929@6wind.com>
Date:   Wed, 15 Jan 2020 14:43:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bc4093c61a90c8c900b43fb35e57233da86f5500.1579040200.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/01/2020 à 23:25, Guillaume Nault a écrit :
> Mark function parameters as 'const' where possible.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
