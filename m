Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505C4918DE
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfHRSbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:31:19 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33046 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRSbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:31:19 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so16123309iog.0
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 11:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qKUUZZhaQYcpnzCf80vhc4QECZBbft1N1JW9EKKRjKA=;
        b=IrMXEuiGHIBhDGsohwiaSDOlGgV8Dtf5X33VKQO7sEFdX8VmDKF5bSUzrgMKomS4sc
         ToCxnHLPWOmA1L4ggzg8d7sz+1l6g0S7ktTx0owQ/cOgZp/4U4+bVtJ9La7hg4NjhQQf
         Y9ZHKH0zgqOwOKVvSxGGQdQWr+XDeqKARguwdIt6A5sqin3yIMKyetTOuyPywh16Xd+L
         H/KN+YjuEavX0Nd0Q3SP4ogHGJ5pBq5jNJAAhnFAzOhoYynN1VnUMhyaEA79b+etHMcp
         kry1RlwtCmIBhXGu4OdZybpB3mnLI04on9L2tth8gSbhbyVSSm4DGx5MJzz20G8h0km1
         CKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qKUUZZhaQYcpnzCf80vhc4QECZBbft1N1JW9EKKRjKA=;
        b=f2WhUKQDUwGOEhGNjxy7ECS1wC7Ki5I9xgshF8uhDh6qOPAiU8/FlwHVwa5THQubnq
         IA5UETcshAYSuoXiZGBQTHk8qJyW7mciY5GCye1lVF+xFJy2J8tgjvXiA7QWiLnUPsvD
         22S9I+13G2i7l3IpbjdtEg43ZfdstmyE3Ey5QYBBcgFJJWYQ1NLFtfvZHHx1A8Zyn2PA
         WhpvIYMTGVOLzlCr/Tpv94ayADlyXzf5xn/avDeqZFNozsuS5h8hUaes1zwLX17E7slg
         YjysGZ77Et4ZDwOsUXzxjTIGNhTTGNaoNzgQj2oYa/j4mlQtgSL425Qwr/QwIbXKVgnK
         EqEA==
X-Gm-Message-State: APjAAAXEl0rZa4xzoMcPxDQRAA7cwwaxabD2cwDjX2gajnYzAmtA8Em8
        JSFXU6k9d1BbHll+vhZRfFmGR8dk
X-Google-Smtp-Source: APXvYqyiAnllvB9TpSZ4tQmVhvUlH5HZ02k994zKn0c1S42pp39ZuflPk2aj2nLewKaCNXL377lQOg==
X-Received: by 2002:a5d:9643:: with SMTP id d3mr23015834ios.227.1566153078053;
        Sun, 18 Aug 2019 11:31:18 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:2087:5b7b:5c6b:2ceb? ([2601:282:800:fd80:2087:5b7b:5c6b:2ceb])
        by smtp.googlemail.com with ESMTPSA id c13sm14350125iok.84.2019.08.18.11.31.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 11:31:16 -0700 (PDT)
Subject: Re: [PATCH 2/2] ip nexthop: Allow flush|list operations to specify a
 specific protocol
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org
References: <20190810001843.32068-3-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f92b9fbc-3d12-45fa-9e3d-d5841871a6d2@gmail.com>
Date:   Sun, 18 Aug 2019 12:31:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190810001843.32068-3-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 6:18 PM, Donald Sharp wrote:
> In the case where we have a large number of nexthops from a specific
> protocol, allow the flush and list operations to take a protocol
> to limit the commands scopes.
> 
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
> ---
>  ip/ipnexthop.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 

Donald: This looks correct to me. Before applying I want to add test
cases to tools/testing/selftests/net/fib_nexthops.sh in the kernel repo
to just to run through different options. Hopefully, I can do that this
week.

