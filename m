Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C079DB64A
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438966AbfJQSgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:36:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33263 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438924AbfJQSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:36:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so3520070wrs.0;
        Thu, 17 Oct 2019 11:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L/172PFesHWuvzNopt4c4XlSQQptfEWlNlsUsPCP8v8=;
        b=UHG/4bLFtFCzmfzkVGc2ImqhRoK5hPPugYe10a7h/AHV34r//c3q8LQl4Uj67cTlbN
         JoCk/UwGu+U8SRK2B1kbvqi4b1zjVtdw6qbWArTZsOG4XLgW34gTamVTiIoRw5JfAow7
         o/7y+KYslgzzN/Vs8xkqNYoxXo8S98QVbnQry/NnNc9kdsybo+1TqjbpWc0156S9NjE/
         QPp2znoHrt5f62rqIbsgH6NkXL6su3ENXfz9DmK8TQPazqy72sTIaisWe50NqX5JsEg6
         Hfd4PuerKUUD/Pf5A8rdUty3wYr1lW+daPacXsvGVJ3/aOUhHtCLAFGlp46QbmB+a3GN
         IFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L/172PFesHWuvzNopt4c4XlSQQptfEWlNlsUsPCP8v8=;
        b=HiYL7h45vzGsQQ3790sHprLwSnZM/+wG3N+7iJSNRrO+II9lFf/fWFd5wKAv0bOEvA
         zPQX+373akAhichskeG3maRRTGb92xUTkN0nrJyq2AyJJczih0YYN5SXY5/sUdWKhHei
         rMRthONEUu17OT8iXNUlW5Cznt9pt1ZENiiVFIRUt2sAQ6qRPFDF+f1hN6u+nNwpEyvX
         bxJ/3epNx1FNJ6RKimUy9vQTJvV9GsJGxsUt4HO3kSxOk9T/7Z3CEy6rj6FnmYeraOGO
         I/wmEK/oghptcEd6BDcwAsHwKh/HlF5oLKQfglP9HghVx9QK99HdU1ZxUl+R0nuDzepm
         R+aA==
X-Gm-Message-State: APjAAAWPEaylYRwu4IygTC1S+/BKDsDL21ATcUbm+I9+eLxIcOpLrswD
        fbjBZaLFA8HF8Bmkd69dj3qDTTDf
X-Google-Smtp-Source: APXvYqxnhdYQusvYfFeUZHFuap0s7BvTLgqmJZXqKtYnH7Ct6SqR++6A5hhIRnW3QcZVratWlK/KXQ==
X-Received: by 2002:adf:ee81:: with SMTP id b1mr3923610wro.58.1571337358592;
        Thu, 17 Oct 2019 11:35:58 -0700 (PDT)
Received: from [10.230.29.119] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a14sm2540026wmm.44.2019.10.17.11.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 11:35:57 -0700 (PDT)
Subject: Re: [PATCH v1 4/4] net: dsa: add support for Atheros AR9331 build-in
 switch
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Snook <chris.snook@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-5-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2ad26bdc-e099-ded6-1337-5793aba0958d@gmail.com>
Date:   Thu, 17 Oct 2019 11:35:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191014061549.3669-5-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2019 11:15 PM, Oleksij Rempel wrote:
> Provide basic support for Atheros AR9331 build-in switch. So far it
> works as port multiplexer without any hardware offloading support.

I glanced through the functional parts of the code, and it looks pretty
straight forward, since there is no offloading done so far, do you plan
on adding bridge offload eventually if nothing more?

When you submit v2, I would suggest splitting the tagger code from the
switch driver code, just to make them easier to review.

Thanks!
-- 
Florian
