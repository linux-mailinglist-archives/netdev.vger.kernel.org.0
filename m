Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4031B538F
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbfIQRE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:04:27 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44063 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730669AbfIQRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 13:04:27 -0400
Received: by mail-pl1-f194.google.com with SMTP id k24so961012pll.11
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 10:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eanHY5Y79pgIFXwzxP/gAKsWmLBvXzaYiWTipf08VNQ=;
        b=BpSMLhaKdzVGH13Sb4R9NfcSkSsv7ldAqou9AhjCh0f0+qtlyB0ivd7D+qEffNNDTy
         md8O6MhB5RChU4YBg2IlWEdVjxGXjjBwGIEAY61kzK4pm4g8IEA4PkNr3pdTd809249m
         nLmNW71SFBqLElBqumq+E12amWQbpgjoP1DxzHzjVl6zru9TQV8h0mujRwb6znEykw5N
         bL0RikH5xcWNYbZVIL5xgxY9Xrx/GFrNcWLldiXCvOyYanf/+MpPteAPQg4KaOpbYBEI
         QQU8Q/lsQv9B2lnhsLWpXkEdBD3g0AYO8ZqIm6gAg+BU5wgaa0i45UvGX1KWeSgiU5Wg
         ysPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eanHY5Y79pgIFXwzxP/gAKsWmLBvXzaYiWTipf08VNQ=;
        b=gxAhX8uRqTWnIObVy/j2j5YYIW26ld0PqR9C5QMkqZ5EEqxo57gJu/wRBDhsFrqZHx
         88KvLG6e+q7dqaY8uZ9bmf5oz6b0Pu/M63PJj4AVDZuFuNPN/c7QfI4bKeuw6Ne9RDRs
         TuU9FY5uPeE72ymVIDu5hJPtsBUO5EtfEYquXbbeiwK1PSkW2vm2KvQTrbB1imiXt3/M
         CCE5yxLSgOeHde56YeBfTj26nb9h4BPwPPzL1QrOu9e8ZUp42ymGSXEwMj7WpGIImdtu
         gnZKSdGnbNzVDYZq9qe3/9zmRkkQHoIj63i0eCSOdmcwE24QJF4ebsVJWuPWI/o9h6w5
         oSIw==
X-Gm-Message-State: APjAAAXYU1NYJ5hsphm49dbsw2efoW96rr+ctfGk6S32qNCByn+FO31l
        dGe+bRvRlbSrPHXC60CFrdE=
X-Google-Smtp-Source: APXvYqx9yni2A5YIt0nR17agdF5oZ1JhC4d/GZupOpNuXLQNMI1oobGjuoBKkLl0U69Vocl/MtK9jA==
X-Received: by 2002:a17:902:7c15:: with SMTP id x21mr4612739pll.181.1568739866714;
        Tue, 17 Sep 2019 10:04:26 -0700 (PDT)
Received: from [172.27.227.235] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 8sm10573417pjt.14.2019.09.17.10.04.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:04:26 -0700 (PDT)
Subject: Re: [PATCH] selftests: Add test cases for `ip nexthop flush proto XX`
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org,
        dsahern@kernel.org
References: <20190916122650.24124-1-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a02207e3-99b7-2803-e93d-7943b755769d@gmail.com>
Date:   Tue, 17 Sep 2019 11:04:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190916122650.24124-1-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/19 6:26 AM, Donald Sharp wrote:
> Add some test cases to allow the fib_nexthops.sh test code
> to test the flushing of nexthops based upon the proto passed
> in upon creation of the nexthop group.
> 
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


