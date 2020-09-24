Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E33277B3C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 23:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgIXVtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 17:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXVtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 17:49:18 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BBDC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 14:49:18 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id k13so254897oor.2
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 14:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RP2IODyoWEZaW6uD2rsdm6T44SasAUtHoGm+JzMioOA=;
        b=fHwPL8RcVtE0o7aRztwAB0f7zSCjoOdQV9InxWR1/TabYMekTOKbxf5/a87l232p5c
         pRBAwePEPYvH/MB6ej+2huEN1U914xqMU5vCoaGJUV/VGXRl1QSC7w5pYoBzFCpEgBCk
         tnca6u6i/j/52SC1L6/ir4GDasYMX/SXF0mXF1pLlgR9PKw5BVTu20D6uRdwKjZ6/7j5
         MASI1NuCUjax/I56rZI8vLWOqlqymKL3Pv3IWmscMtk9RH9yXwBGmbv2Mv591FHVvcNg
         ie+ISdT0Kiebajj71hhc6RPgAj5GB+zrntpHmQlONS4Hb8zUpF14TEgUVi0xFQC72w7S
         AT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RP2IODyoWEZaW6uD2rsdm6T44SasAUtHoGm+JzMioOA=;
        b=kSdzXfvF6sqwxUm4OMst4bCjrvgHTA+0baKrxDodXhTlSXOyK6X5Ures3js/vNXb0x
         BiEKz8pOqxVL3lwqXtrhXWrVl2ScfzDPOIbiS1nrd5i4sfdrOQpV7eXdCHmXhG3vUShF
         Iru1WS76UfGeKVZOWsBpTz7nbIoe65gZD9f0Gltwwx2Tj0TpJr5DsF/Fz7eT2rowGcI/
         1miuIW5BCgX8SERHCWRiT//otodMbVV88Y4c1+x+cUoRn+36VFeIwQqh79Mek5U1I/D3
         BGTP4V/H/oqHJRfo3Hi9SR3nNoSVXsjmwSjUPeCnIkn2fSo3CsJChomEkCwLW6UasSJ9
         pBjw==
X-Gm-Message-State: AOAM532BGy9MdtF3hAP436I4u3TVy4kBN6qNHcIhQLXOCfiyxtejF+WW
        w4EV6VWTizsGXFHuzUwIdTcS1S/KbHwFNQ==
X-Google-Smtp-Source: ABdhPJyqPH/QEeZSOVWOfB7W1uOjt6aZE0m8eGs009rOHBw6I0Qdr8oHgrClSxzAmoeFDEA8tfeoZQ==
X-Received: by 2002:a4a:af45:: with SMTP id x5mr910143oon.86.1600984157622;
        Thu, 24 Sep 2020 14:49:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f921:c3fe:6d94:b608])
        by smtp.googlemail.com with ESMTPSA id j24sm144347otn.64.2020.09.24.14.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 14:49:16 -0700 (PDT)
Subject: Re: RTNETLINK answers: Permission denied
To:     "Brian J. Murrell" <brian@interlinx.bc.ca>, netdev@vger.kernel.org
References: <fe60df0562f7822027f253527aef2187afdfe583.camel@interlinx.bc.ca>
 <a4b94cd7c1e3231ba8ea03e2e2b4a19c08033947.camel@interlinx.bc.ca>
 <5accdc00-3106-4670-d6f1-7118cae5ef9e@gmail.com>
 <9fade563b86195869cba0ab9652c0a9e2ee8e2d3.camel@interlinx.bc.ca>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <19ff6d8a-e3a8-4bd1-a360-697e1ba81afd@gmail.com>
Date:   Thu, 24 Sep 2020 15:49:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9fade563b86195869cba0ab9652c0a9e2ee8e2d3.camel@interlinx.bc.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 10:26 AM, Brian J. Murrell wrote:
> On Thu, 2020-09-24 at 10:15 -0600, David Ahern wrote:
>>
>> check your routes for a prohibit entry:
> 
> I don't have any prohibit entries
> 

perf record -e fib6:* -g --  ip route get 2001:4860:4860::8844
perf script

It's a config problem somewhere.
