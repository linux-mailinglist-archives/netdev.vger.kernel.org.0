Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF14AE899
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbfIJKqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:46:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41089 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729173AbfIJKqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 06:46:53 -0400
Received: by mail-lj1-f195.google.com with SMTP id a4so15898351ljk.8
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 03:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uyraNbBmmkbMfViHOc096IVYSM7nk5xLDXtsUxDse+U=;
        b=n4LbfsiRDj8XVLb9CiZdNdzrhARpW7Rl4oaYD1tEqgxa3wpWgXGzvZ+qVVxnyCcZ6m
         9FDwTURZ65xoPFSQJ/lamFPxrqT0KOloQlnNqCsL4yalQZdM4obseh/QZYJ7LgzP7m/C
         h32gyH2XIKMNjClIJr+2NyDMddANiRK7CJZngqeeskrLe2gO5t+2myzPGdoZ+wULdtYH
         QwP6KqDvDx9EBHCt1HitGbHxPBPxB52NyODN0Dm5aipFdUGdA7jVbVISlP/vTJVjTRpK
         w+SQc50UrCDQwejCP+8SRUep7Sk1MzSbWEB4U5p+YMHfcqZmeZwPk4e0RwVOEgOxM5Za
         KP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uyraNbBmmkbMfViHOc096IVYSM7nk5xLDXtsUxDse+U=;
        b=g8Ix2VTmi86O7sWDPofqO1UvPOJqRHhCYA6JuKRlIVHa5wSXh02kvMRAj4dusa47JI
         4bOSJBDNkYxC/OTanGWjMDv3ad5isd5PcGWyX1fAYR8a6NYWa4LeDtatwin+9DKp4+6O
         E8Y17gk5gVC8GHptaZ3X7STOkDCxpuEJENAJSFmPy5CloUZ0dRwi+VYxEw2rSRVUW8hL
         EBczAfvUZ2iDDnS/OfyFfllYXVkakuBsmQBwbyfn4TBPGvg+gEl7zTSVOylsvATnsvWV
         4cjKlR3eF71lg3xwQQs30J00HQtj55HITCRpwOG6dFQO3maS8sjHvXf/dQmJL5deol52
         yhpA==
X-Gm-Message-State: APjAAAUgCPgs4C5JToPqUXawHmwtOuaHBOrQNLSRiChrFoojzSjXAppS
        ZmVyIH3xvkvlfn+Q1XP7jn91JA==
X-Google-Smtp-Source: APXvYqxjJDtoCEdJJkL0Ta4dVC6Djzpe6k7l3h7A8eeWy9gkyrOpk4MQDRVqXSOrO7dq60dtMtLmNg==
X-Received: by 2002:a2e:6c18:: with SMTP id h24mr4979333ljc.227.1568112411723;
        Tue, 10 Sep 2019 03:46:51 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:29f:2049:ec7c:4ff3:ee75:27b0? ([2a00:1fa0:29f:2049:ec7c:4ff3:ee75:27b0])
        by smtp.gmail.com with ESMTPSA id e29sm3664764ljb.105.2019.09.10.03.46.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 03:46:50 -0700 (PDT)
Subject: Re: [PATCH bpf-next 01/11] samples: bpf: makefile: fix HDR_PROBE
 "echo"
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-2-ivan.khoronzhuk@linaro.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <55803f7e-a971-d71a-fcc2-76ae1cf813bf@cogentembedded.com>
Date:   Tue, 10 Sep 2019 13:46:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190910103830.20794-2-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10.09.2019 13:38, Ivan Khoronzhuk wrote:

> echo should be replaced on echo -e to handle \n correctly, but instead,

   s/on/with/?

> replace it on printf as some systems can't handle echo -e.

    Likewise?

> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
[...]

MBR, Sergei

