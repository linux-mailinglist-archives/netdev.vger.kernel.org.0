Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C92B2653
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 21:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388709AbfIMT4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 15:56:23 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46166 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730868AbfIMT4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 15:56:19 -0400
Received: by mail-lj1-f193.google.com with SMTP id e17so28198058ljf.13
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 12:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YangW0nZxTvuxMasR2T71zvAAP15OctV2hgPwvy27lg=;
        b=Lv802009QJLjWjD4UFEK/0Dz70rSsQfJEfZlJop0qI82z5JcfLHl/2r2yyVgEryl7W
         1V7VB3t+6OehDmsN2DQE6ni7NaHcNp2Qjk+v7bOHqiHHSz/ZfSd5aH8FGktHFz/WpMz/
         D8RTy+RrxlShPKtX937BcbB6hfALtCl/w/SIvP1D5hP+Ix7kQz7pUK9Ag6Bd/qsGEfY5
         KhFEStm+Ybxo1UKqlwTX0KMQD9eMED1Y042cfErh2l0YgwbTnPYwD9nVFRq3Gzh+TfHO
         fqaWvWl9PsK0qoDo6vcQ6e0OPQ13DFgLWXPo9HATYldmlKn3Y8H/flKflvJiDhZuxMkB
         e/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=YangW0nZxTvuxMasR2T71zvAAP15OctV2hgPwvy27lg=;
        b=IO9AAyunbgMao5nW64Hi2ea8WsnYmnrQeLdxUcYifArGt4aSmOjqmLzCoC6iGlZeHe
         K4wEOYCLXPSkcvR3zv+D+C1k0ZL1ksUaskm9WsYZ+J7ZZJSHIE1mDMUQL+en27vUtPD6
         aGobw7if4Pte9ujWFEl3bnAwFwmDSDoYs0moOUQpayjFlSe7ty4tTvgMr1zO7E+lT8Ij
         icOIYqS5W595N7tPP/E3tNNMxcB+x+COCKZl9x2nP6yUieU9syUPQzAHvuuNtQbEhDTy
         MfC0YiceTOsUyfJQzYbQmqHrXjMEs37s1F+iaCNx20AQ59CbFpRLx1BgRqtjK/DAhI2o
         8AJA==
X-Gm-Message-State: APjAAAXfbRp6gjFHZ/ixIzioqSgv5gs/RY1VC8/wFrwQFf9aOeA7gP2k
        kgmJPhIXnZGQb40oKtB+KrxpkA==
X-Google-Smtp-Source: APXvYqxU70mxnPTmi2ptT3akvixZSFIEhcR1gb+O4j9tliEriL3aAlVfx0PwNFAE3sW28jupZdNinA==
X-Received: by 2002:a2e:7801:: with SMTP id t1mr16881585ljc.140.1568404576977;
        Fri, 13 Sep 2019 12:56:16 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id p8sm6581687ljn.93.2019.09.13.12.56.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Sep 2019 12:56:16 -0700 (PDT)
Date:   Fri, 13 Sep 2019 22:56:14 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 01/11] samples: bpf: makefile: fix HDR_PROBE
 "echo"
Message-ID: <20190913195612.GA26724@khorivan>
Mail-Followup-To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-2-ivan.khoronzhuk@linaro.org>
 <55803f7e-a971-d71a-fcc2-76ae1cf813bf@cogentembedded.com>
 <20190910145359.GD3053@khorivan>
 <4251fe86-ccc7-f1ce-e954-2d488d2a95a9@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4251fe86-ccc7-f1ce-e954-2d488d2a95a9@cogentembedded.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 02:02:11PM +0300, Sergei Shtylyov wrote:
>On 10.09.2019 17:54, Ivan Khoronzhuk wrote:
>
>>>Hello!
>>>
>>>On 10.09.2019 13:38, Ivan Khoronzhuk wrote:
>>>
>>>>echo should be replaced on echo -e to handle \n correctly, but instead,
>>>
>>> s/on/with/?
>>s/echo/printf/ instead of s/echo/echo -e/
>
>   I only pointed that 'on' is incorrect there. You replace something 
>/with/ something other...
>
>>
>>printf looks better.
>>
>>>
>>>>replace it on printf as some systems can't handle echo -e.
>>>
>>>  Likewise?
>
>   Same grammatical mistake.
Oh, will correct it next v.


-- 
Regards,
Ivan Khoronzhuk
