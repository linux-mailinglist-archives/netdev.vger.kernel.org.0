Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D0A40214F
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 00:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240889AbhIFWei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 18:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbhIFWeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 18:34:37 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D4EC061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 15:33:32 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id x10-20020a056830408a00b004f26cead745so10404836ott.10
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 15:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vIzeEE1ePgpyBPlhVu71FqTJ1tZomSrQP3uHsMOsN20=;
        b=ZfSz5qFqZAAHxsHtuI/kg65U4/D0y5kR7vjHWk+Qk6EgTYUCDG1/yu37lr+XfPOym1
         O1iI9nTLIcK4IMwJJsUdqTQ+K3UW6nsMTAPHmzAmqcZO7tgftI4vhJqAm5LuAoo00evy
         35PX3wN6pyArz7Dgch2yB71YNVK8dOopGxEplT6AzziTBkHT88ifBxzu8iwvSHynpEy/
         Q4bBujBJYSnK+AUnLztLe8ifOc4uJ6arqbOHxNznWEQDaDMbDT1v0zJgR+WIqQ5ofYar
         R70m4zkfDqhqAevgoco03eTEt23hEpl+aJu1H/dhdviJOlO6XtovQn2JeOGh0u4H1AR0
         KGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vIzeEE1ePgpyBPlhVu71FqTJ1tZomSrQP3uHsMOsN20=;
        b=PyI1xfvXyOlg9l1ea/hYX5bfAwATMXvsQYmZWWLCJkVO6jQGYNq+6jnVlAFtUlHawE
         NobdviKGj/N7JSuiOvGiOj2y6vlIn7TTKCvwTU4TrTFzsIJ6rm9xQKo2S8MJT2L8HEqT
         O2yg71qv4SJfvOJpiE5qNCTBl1qDwwNok7EJ7zOamGl07xEMh4tjQu6VOK76MQADkCFp
         wfzRkPgmcvj1ypfUEg75W31FZoLXGt1wpQ/aLNO9EnxW4FHImXym7au7n2LNCaPROTnv
         eYVGrDA5bqE6XuGJGEWBJtwwNGSquVKiP7//t57eHWwTr4DFAEUNu2mnk1Ym9IbCPcWA
         lRkQ==
X-Gm-Message-State: AOAM5305Aou+29tRD0pkUbJbnFasp4MydM0hnDxjKLUkhD+C8fG1OQ6m
        0HX+NVwY6mwbwchWMP4GxAM=
X-Google-Smtp-Source: ABdhPJzxp2vfqmIXFiAa8uGTNwG/Rto+A3EOc//WQRqvX5PIncwmSUI++PC64nrJjSNTd/ZXexWLnA==
X-Received: by 2002:a05:6830:1395:: with SMTP id d21mr12521133otq.166.1630967611441;
        Mon, 06 Sep 2021 15:33:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id w23sm1766597oih.4.2021.09.06.15.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 15:33:31 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/4] Cleanup of ip scripts
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
References: <20210901204701.19646-1-sthemmin@microsoft.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <496129af-ea16-b059-f7ab-9f9f72431d3f@gmail.com>
Date:   Mon, 6 Sep 2021 16:33:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901204701.19646-1-sthemmin@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 2:46 PM, Stephen Hemminger wrote:
> Remove several old useless scripts and fix the routel script
> by rewriting it.
> 

applied to iproute2-next

