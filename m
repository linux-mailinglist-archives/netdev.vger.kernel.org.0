Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8A22706C6
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgIRURS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgIRURN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:17:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C37EC0613CE;
        Fri, 18 Sep 2020 13:17:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m15so3558034pls.8;
        Fri, 18 Sep 2020 13:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WZFf6ltXN0q6i6KfdkHs41/4zFJI2xjfS0NImoIhVB8=;
        b=fk3vLF2VSSpAeTi8FDW6tR1CzQJ0c3ULllbkERTtXNmHGHs93EwRcrNWjL0PTYVrma
         ZpSVBQy5ejTY50kUPt3TKByJ19uzC1YMDEynRRvnDRu4nYyGKYDA82x2UOHskkL9CqIE
         eRPDRqL38gkpcp8Kh0pKBrjO2smmYy4mEDhupuy1Z5EtVshN3bimkesTLKhsUMuw8s6J
         h4230k7Sy+FPLrtEeTe6vxZw/o7us4/UQ8m3V3/3GqqN6V3v2JqSJ+HjT2A8uqJM5ZK0
         +TBkfedRMaAadi4wpV+YJJwxRfWHKbuyEWZgoBs+X9O7Ws4Xx1SRmLjmQf3RUMy62AGD
         7D/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WZFf6ltXN0q6i6KfdkHs41/4zFJI2xjfS0NImoIhVB8=;
        b=MgPpPupiIzmhYUTzV11opiwr7bhrm/mWYgIsVX77xiqORLpEKbfxcm9bhvDfT8ygm3
         GoyLnQxBnyCizobJTAMjLS4O+1bR8KQS9qybdoaMa6Gg/1OOXWVtygw963zYaF/zWB4p
         r07Bbi2v5O+hJnHZUOSuiRQJLSb7++lh5uNtQMd+lA0r+5EnHaij1DxUy5BB362upCuq
         GPUxubNI7rLj9/iG7LB3QYKXSUvKijvia2EhPG1wj4HZjBt3uHeXWpOb9wsr7JulJlQF
         xCEnhun2x+uaJSh9vEbaK8aU7mS9+1QU9gJfYVE30YjlRMj2cw6Q6hvCBnngV4Gnp1GN
         Lu9Q==
X-Gm-Message-State: AOAM532VXiIwVQyhbykeXYbq10fPNJRDYjH2+95oZI4XWgAOg8ibbwXo
        sv+vPknNYIVoT0qud4czPodL4XcpZe3rdQ==
X-Google-Smtp-Source: ABdhPJw/GVkj9zbCNxU04b7IYQ3kf0A3z194OFufFFNA8+nzS50hme0yBDpwF7LI3apoN/bLJ/YZ+Q==
X-Received: by 2002:a17:902:d888:b029:d0:cb2d:f274 with SMTP id b8-20020a170902d888b02900d0cb2df274mr34481802plz.13.1600460232794;
        Fri, 18 Sep 2020 13:17:12 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 1sm4600803pfx.126.2020.09.18.13.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:17:11 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] net: phy: dp83822: Update the fiber
 advertisement for speed
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200918191453.13914-1-dmurphy@ti.com>
 <20200918191453.13914-4-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0af1f797-ce97-2111-cff6-15d9deef3b62@gmail.com>
Date:   Fri, 18 Sep 2020 13:17:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918191453.13914-4-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2020 12:14 PM, Dan Murphy wrote:
> Update the fiber advertisement for speed and duplex modes with the
> 100base-FX full and half linkmode entries.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
