Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C3531FC3
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfFAPTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 11:19:36 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39334 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfFAPTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 11:19:36 -0400
Received: by mail-ot1-f65.google.com with SMTP id k24so7047639otn.6;
        Sat, 01 Jun 2019 08:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DZ8EqvDyWqIwxw5uZ651sYBJbgvZFIAJoCrfZ/Kg7Zw=;
        b=RKmKfTKDV3iutmhvFK0woxtRH6yzeEaHjsVmyQmmyw2v07giiLuwhYhbp3nC5EGgzl
         gWoDbiHRlqBV9fWVmwLbOXiOQvDveID+y1ARlftv2J7y140cy8o6sYdeC8Cbx68MmW8J
         YY1YnJNXHAPf9zRMB4bcNKJ+lGKbE7jmgBEexvTcgDgoMPrVvHY9NOUscrkviNlVk91v
         r/GFI+LKSXXvUbZy5d+8sxVlhfxL4XQ1ffnlVEBvpTXOIc3ybLrMiXsLDnNr13fhFwRl
         Fq5xxmcnMEpEe3Ov03+TdfiVRK7MxDURbdjj7vG3T/2Q2Zw6WlUpA1+tyxbR4eg0riI4
         /s4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DZ8EqvDyWqIwxw5uZ651sYBJbgvZFIAJoCrfZ/Kg7Zw=;
        b=YQXNumHYoDN7hRAXlXbW4Mk3zvgQhuDU0OPaPpCWrBDf08TPL2aMrdy89pBWj2UIBc
         VAvhoLzMLLyrhsKq48F/t3+z+IGRnwbjJmD960eH9Fln5INXQ+myG5fjGGxNuYH731RD
         vMiwuTSd6x7jU36RQZU7XmGz4cR7hXceqpBzXDhxlCJpBxAh7UYRPEYp6jh7xns6F69h
         sgMVFnkxBpbIWmeg4Pac2loNdjpu1PfK18wCkuRmjvVLF5vc0jbLathZLtP7kKn0d60k
         bincLSON/2nAPRH4KDcayfIoW1troMVWRqvI0RGaNqzByrLGTWBDH7C9wKqW7ulNnZUX
         R7VQ==
X-Gm-Message-State: APjAAAUvzlkVFeXawSwgf3CKgypNiyts6OMgmTKUuThFZHAtEWK2t/3p
        z6wVRQWgZrkbp3gq3tY6IRp3vt8=
X-Google-Smtp-Source: APXvYqz87YY3UNw+GPNxnK8eKWjApCu8nRLf7NND4TafvxCLm5EqKiQNzc0fvFPNqVKaBy2rPjK2rw==
X-Received: by 2002:a9d:7312:: with SMTP id e18mr5711785otk.148.1559402375857;
        Sat, 01 Jun 2019 08:19:35 -0700 (PDT)
Received: from ubuntu (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id r14sm3125038otk.72.2019.06.01.08.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jun 2019 08:19:34 -0700 (PDT)
Date:   Sat, 1 Jun 2019 11:04:29 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190601150429.GA16560@ubuntu>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601002230.bo6dhdf3lhlkknqq@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 02:22:30AM +0200, Pablo Neira Ayuso wrote:
> > It is the same as the IPv6 one. The offset returned is the offset to the
> > specific option (target) or the byte beyond the options if the target
> > isn't specified (< 0).
> 
> Thanks for explaining. So you are using ipv6_find_hdr() as reference,
> but not sure this offset parameter is useful for this patchset since
> this is always set to zero, do you have plans to use this in a follow
> up patchset?

I developed this patchset to suit my employer needs and there is no plan
for a follow up patchset, however I think non-zero offset might be useful
in the future for tunneled packets.

> I mean, you make this check upfront from the _eval() path, ie.
> 
> static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
>                                  ...
> {
>         ...
> 
>         if (skb->protocol != htons(ETH_P_IP))
>                 goto err;

Got it.

Thanks.
