Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554DB11C1C6
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLLBCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:02:40 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:37874 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfLLBCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:02:40 -0500
Received: by mail-qv1-f67.google.com with SMTP id t7so278944qve.4
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=bDu6UlocVr8yC7RA+vB1bpLyWumODdkZotQceKQnYYs=;
        b=PoAXSiR2m6vRgvmrW+eo5ZjFm9n+6JKutN/xPdn5nri69rqF2gXfNVdSKp8TSmP0KG
         JnbNf1p1O1h8zpGmbGqEvPJmfpXvzyVS9DJ0UEr5VJueIHMa4RGgilrOEJLk69h+acuO
         LzvHDaHEVqlECvwxqZdEB8eW1PNjcJUVFKwL41E3a15548vgzTjXmj8ex78fGMjckvSe
         6pe8yBrm4fxDLiv9Fmr6iPPvvzk2gcB95t/WJqlaF6zHFQZ0wFPO6jXVpAxPKEpociLW
         PerRrj3HU0IoR9tvgfXATdMgzVOBlNuroTITvomGkzRmZrNqubBwfrbJlLyC1PZtvvxj
         tjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=bDu6UlocVr8yC7RA+vB1bpLyWumODdkZotQceKQnYYs=;
        b=JbCxj/P/su2ylfGZm4bt3xS1Og7qr3n6L13jjHMk/utYAv8uyjMATbTDvJqGZSyy/Z
         Gd1gauGgZZDLdpBrok/Ha8L8cajW4UcbRENkhxNyU1Kgz/zfbTbzoMJHhfUSdWZXrH/m
         pg+t/HL5KvTGzxmioCOZBkxb+ZZ0pCj1InQJi0tNJdj4qEZZk0BbgdUs4a+DVY3v//T+
         wWUBqjl6tUEYAcuedVy5pjM0oTs28fMTILbe6tkCeBPB3pH8qcNcYT1xSGudoji1LqY8
         GeyjR5VcPW2PrK3ifHBE/YzoDOPrSupN2XfXGRUm4RU3q8RTnLCKoXfqDWP8fO7ZKs/E
         NYtA==
X-Gm-Message-State: APjAAAUkH3q7fomgbtuZ7FN1g/NgyvSQHmpF91q31wHEwDIgyi4guW7L
        HiCmlGY6C+nFX8929wCEnBA=
X-Google-Smtp-Source: APXvYqy86vHP9w+iedPQNxW8573lsPDMclA+vgOa5vTcd21lpc/CQqoLWQu539HK1d+6DJG7JbGd1w==
X-Received: by 2002:ad4:4949:: with SMTP id o9mr5675617qvy.189.1576112559109;
        Wed, 11 Dec 2019 17:02:39 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 201sm1258360qkf.10.2019.12.11.17.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 17:02:38 -0800 (PST)
Date:   Wed, 11 Dec 2019 20:02:37 -0500
Message-ID: <20191211200237.GB1661911@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     nikolay@cumulusnetworks.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
In-Reply-To: <20191211.141658.433012532951670675.davem@davemloft.net>
References: <20191211134133.GB1587652@t480s.localdomain>
 <20191211.120120.991784482938734303.davem@davemloft.net>
 <20191211164754.GB1616641@t480s.localdomain>
 <20191211.141658.433012532951670675.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, 11 Dec 2019 14:16:58 -0800 (PST), David Miller <davem@davemloft.net> wrote:
> > To be more precise, what I don't get is that when
> > I move the BRIDGE_XSTATS_STP definition *after* BRIDGE_XSTATS_PAD, the STP
> > xstats don't show up anymore in iproute2.
> 
> Because you ahve to recompile iproute2 so that it uses the corrected value
> in the kernel header, did you do that?

Meh you were correct, my rebuild didn't pick up the header change :-/

I also moved the STP xstats copy below the mcast xstats copy to be consistent
with the order. I'll respin right away.


Thanks,

	Vivien
