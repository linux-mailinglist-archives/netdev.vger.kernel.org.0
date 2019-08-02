Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6337EB00
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 06:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbfHBELo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 00:11:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34865 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbfHBELo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 00:11:44 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so35317045pfn.2
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 21:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iB5actqJBF0XYLipqgUdF4JESGkAWzDjAES2u185b9U=;
        b=E58kFXe1d0wz16nzGPWnS2M1d184S4K3ILVywoFb81ul1wVW2jPLRH3zKZKrsymNkl
         0jfV1Bm2dNvi7aGMVDXnr8GUh3kS3PaJLPbZvY7EmJKL/OkebRwYhQq/7uY6HRRa1XtT
         FM4Sw0lf+PfYUHN9lQdYZ2bbmfwsBq7UdjHiZqQ0JiSX9984BPiONulMvhAddf3BgUgD
         xAASoILN0O7GOZhhoUNHAL4S7ckNMhmM9iXy8GAzOsp2LHc4yVb3aCl1Ff90Ak+7wuzG
         R4epR+4k5pjd7p1CGtV48O/Wh4HhxOmvPV3ska06tAbxXnN4h8mLeW1w6/Xh+iD3bB+4
         NCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iB5actqJBF0XYLipqgUdF4JESGkAWzDjAES2u185b9U=;
        b=fCAaGgBEqw00/RfaCC7hlXAXXdGQ+POfbFqcfbb5fm1fZEM6xT4h3go2N6r9lO8nkm
         A55UXfKY1Km6dFHxLzQd6TpdWcV1MgmIfif+M79Dx5xYOX03T/Zqyxz9DWMV97zGI6FV
         fZV2ShbTCJuv37Tjg+PFtEsiXgk29HgtulaDEoyq9c2YHZE3PbDPuKhuLMIlOC0cPAkG
         zKLT2vJ+u4MEnYIpzQq20ePuZNGOTIHxabFaL4caFIp/9/uOfRckv6xcdZ9K83JoB8g/
         r05LaPJbD9Xde+DhpAoPKXLOM5OucW5B62j5aOjipYRy5E1NSPo8hgISVE9oZiLOV98s
         BK7w==
X-Gm-Message-State: APjAAAWIZ0dgLcE/m4XpctnVTpcQR0L80QPoAFtyGSi1G0vsZPlyB44P
        Wmb2dScanhzHgDBeHIzbIQ736ijP
X-Google-Smtp-Source: APXvYqygyuhcUDIabzCTirVPKFSQz4paXjncF69u4Hwn51Ql5Skq4sAOj/fUzierbxRZ3E6CEq+dvA==
X-Received: by 2002:aa7:8b10:: with SMTP id f16mr58172959pfd.44.1564719103588;
        Thu, 01 Aug 2019 21:11:43 -0700 (PDT)
Received: from [172.27.227.205] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j1sm100390100pgl.12.2019.08.01.21.11.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 21:11:42 -0700 (PDT)
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190801185648.27653-1-dsahern@kernel.org>
 <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7b95042e-e586-2ca2-2a26-f5aea5a8184b@gmail.com>
Date:   Thu, 1 Aug 2019 22:11:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 6:19 PM, Alexei Starovoitov wrote:
> Do you really need 'sleep 1' everywhere?
> It makes them so slow to run...
> What happens if you just remove it ? Tests will fail? Why?

yes, the sleep 1 is needed. A server process is getting launched into
the background. It's status is not relevant; the client's is the key.
The server needs time to initialize. And, yes I tried forking and it
gets hung up with bash and capturing the output for verbose mode.
