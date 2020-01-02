Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA5E12E8F6
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgABQxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:53:14 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46193 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbgABQxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:53:13 -0500
Received: by mail-pg1-f179.google.com with SMTP id z124so22118099pgb.13
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 08:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sS6FrVYGbVCXU+pQLC9vyfkAZT8PvRcphG1N23Bc4nU=;
        b=sH/qRybuGLENwEAxuz2RVbGSPUHo2VDjItwNnGR+nNFobiSqufr9I13n30F8U10wY8
         ZbJacv+tDRDMC9RCc8BihAaRAOzE6Xbr3murDG7hs1jFyoajUoc9+aZVF3fZdovnH+4J
         k8SuN6fCXfQyt6vOhXG5/vXneo+9PQhYinIAT27ZnzWJfNM6w0L2gYBOO9/3zBztGSbx
         QSqUzeHfypgSDtreip1l1F5zNpx4bzHcSlHle5va+HiSx8rkS8VU7V/f2HPYoCKo76fx
         M6EKivVuz8Sp7HPbyJvezZKNAHNO0TOJq1OhyQRXsIRE3J5PQs+WulMRKlYdoOxgjqij
         jycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sS6FrVYGbVCXU+pQLC9vyfkAZT8PvRcphG1N23Bc4nU=;
        b=BdHSRdrrD8Ig9q3/vuSuz5wdgDAnBtxhHQ+BnzH8gs28PDuSe2r6s4X9nwb2FkLSJC
         DaX1+kcMNdpBt/sqPsBbBUtF+bRJe/QEkyMz82DNxCEeNCxDKi+1zXzFouUg2oRqLEu7
         oxEnPi9uLrcK/axDf7fnGfk4S2dTomGoaxvz5AOK+3YxzGX13/SPhAv7aiDOwpfiZopP
         Z3iLEiBQzzSg7h05LopHVZETbGzRzeNW5uzh7j8xaopp5hVoDW7gkN1C6Z3b5tiiTh2R
         +zpHgaW3zHFTGmwYFws9FY6rPYaPqg2rMpyoInyUFRUBIXfOFx2jgTdZytmuA136M7A+
         V7OA==
X-Gm-Message-State: APjAAAVlj7bVpOruo5nXfd5T+DgBGR8SmWCzvk2oqGiUmQkv4BGVzvxa
        WJh6f3MIZ0zEyAUCiVHvG9evW4B+
X-Google-Smtp-Source: APXvYqzjAYmGzcm/lB4uRWD/fCmaSgEeaS+qdwdLAiqom/ChUri7wP2tLmdC+IONHWNgC67pNmivEQ==
X-Received: by 2002:a62:78c1:: with SMTP id t184mr87324171pfc.222.1577983993010;
        Thu, 02 Jan 2020 08:53:13 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b448:6aaa:b24c:65b2? ([2601:282:800:7a:b448:6aaa:b24c:65b2])
        by smtp.googlemail.com with ESMTPSA id d14sm69232795pfq.117.2020.01.02.08.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 08:53:12 -0800 (PST)
Subject: Re: IPv6 addresses stay tentative (Linux 5.4.6, 5.4.7)
To:     Nico Schottelius <nico.schottelius@ungleich.ch>,
        netdev@vger.kernel.org
References: <87mub7tbr3.fsf@ungleich.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cd988e58-5e75-5ba5-185b-fd0f2a2f84df@gmail.com>
Date:   Thu, 2 Jan 2020 09:53:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <87mub7tbr3.fsf@ungleich.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/1/20 4:30 PM, Nico Schottelius wrote:
> 
> https://roy.marples.name/archives/dhcpcd-discuss/0002774.html
> 
> p.s.: I am using accept_ra = 2, because forwarding is also enabled.
> 
> Hello,
> 
> it seems something in the kernel code changed in regard to setting IPv6
> addresses usable (i.e. dad done). Since 5.4.6 IPv6 addresses setup
> statically or via autoconf (router advertisements) seem so stay in
> "tentative" state forever.
> 
> I did not experience this behaviour in 5.3.13 (*) and it seems I am not
> the only one affected:
> 
> I turned dhcpcd off to test whether it happens without it and indeed the
> problem seems to be unrelated to dhcpcd.
> 
> Does anyone know about a recent change that may cause this behaviour?
> 
> Best regards,
> 
> Nico
> 
> (*) I cannot boot kernels 5.4.x < 5.4.6, as the wifi card does not show
> up with them.
> 

I do not see this behavior with vanilla 5.5.
