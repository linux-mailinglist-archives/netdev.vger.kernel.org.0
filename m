Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8499C0981
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfI0QW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:22:58 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:43091 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfI0QW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:22:58 -0400
Received: by mail-lf1-f50.google.com with SMTP id u3so2350513lfl.10
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 09:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=72Xx/EPPWYiryTjo7oGMmMO60iIhf9Bs3K+zVKrMlYM=;
        b=K2fYHH5tHgERH2O9gXMlW6xBMHYpjgCDHzDJg63t1VY0HlKK7ffP/WSR1F6YNVYWk9
         /N3o8ZkQX/gr+uc4HXGLSTVlbfF/zttbKaEQFmOkwtEFm6zOA9OSww7k/X/qriVdp+TL
         FO69x5K0EF8nO1U/P/OVCJj5B67T2lAde2CWyFrW58MMoA2/kYaE6KKlB5GKRDZH+/Lq
         8TOYvh9ukt+2fCjcTF0U+HaXWLA4BL9eK1MG1s+On/3LODKLTxBQmK/5RkSda7b+zMnH
         LesoiLTEpBSN8Ys9Pf3Ip2pV4hOh3o6/WBHCNR4OUTgGbchs3Ef62e8KpYIY3Cmrd1bP
         aOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=72Xx/EPPWYiryTjo7oGMmMO60iIhf9Bs3K+zVKrMlYM=;
        b=GX012AxmirOUydNKhDbmz23G1MAqjeqE3jb4Jhr7ZgZH3ZnjVag47TdJxl74Y3BvWB
         8mOtRwjCfymu9gkC5V556d5uFbEsut7MyR+tZe6iDfyFu/V/ZEWoXG2upYljSbBPUrzC
         ql+CjJHH4z/Jgxno7unawRN0kbMrjFs7XpANro5RRqnp5xsY3B+QyTi8ITaXJ9wYjET+
         8kWFvP87sFnZYAKsON0iEUYVGu9AZZNYKlKwLRCknHNW8EJRBsQmy76BXOL5xOmgmUOQ
         cIH+qtJfWTkRiHrLDOAZMILdm/6ojm1fn0BLZ8wzHRDyGLemWfBEkT519kQOWRBGjeOy
         XbKA==
X-Gm-Message-State: APjAAAURLzx8rVRIPRbo3gOfV8YZl7DGrrZ9CRDs0OTp2drjJOD5quqx
        9PgXM7WOUMxbZNqzoZ+eITuvAA==
X-Google-Smtp-Source: APXvYqw/VwjjLJwOtnuav0hbuYBwMD28yqDNG67ORkmJSS8A7GzF3jq+LztNLzWWH7CqXVbB+VkQRw==
X-Received: by 2002:a19:c14a:: with SMTP id r71mr3349013lff.55.1569601374823;
        Fri, 27 Sep 2019 09:22:54 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:8df:57d9:464d:c6f1:f498:da95])
        by smtp.gmail.com with ESMTPSA id k16sm558137lje.56.2019.09.27.09.22.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:22:54 -0700 (PDT)
Subject: Re: [net-next v3 7/7] renesas: reject unsupported external timestamp
 flags
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-8-jacob.e.keller@intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <a08e6e28-bc98-a103-0577-a0bb45f950d5@cogentembedded.com>
Date:   Fri, 27 Sep 2019 19:22:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190926181109.4871-8-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/26/2019 09:11 PM, Jacob Keller wrote:

> Fix the renesas PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
> have interpreted them slightly differently.
> 
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

MBR, Sergei
