Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2043020F45
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfEPTj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:39:29 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46422 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEPTj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:39:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id r18so2097033pls.13
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 12:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q3Sc2bYTOMX9x9F10NDJA8Z1DJ79L26F5cnWTqd039U=;
        b=puTeR5ZVNHLcPh8eoeCR08ggai6OKiG5UmKLDFeIfTkMkRIjaNo4PIl8X29VA4E+Ns
         8qs8bCeAhcwJwt/u/ovCQdXFN8sLsyuIyDCMcJ0BdC1cukFxRep7e8qGs0bm1pbCfVxc
         ixvbu03saUr6RqAmg7O1AYRVG2ppZRoaPuJZiD9vYF/98CFWTb0iT7CLMeTsD2EEbzRp
         cd+VUegJJ9rCrjrbPYm5Ilq7CJBQR9A8RRSPqzcCclGp4uW3ariMCjzUHmq9333Vo+bz
         1ZcIxT1c1EghMMP3mNwJidFGiHOQWYS4BK6FJHLxECwmyMQ0rmVNKJsksowFAMaimFdR
         l1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q3Sc2bYTOMX9x9F10NDJA8Z1DJ79L26F5cnWTqd039U=;
        b=AdkU+z6hFizeixKTlrOtKg1gRNC0BrIK2xnRAWA21i9mAcUF2KrYhlXJF+7+7BAUc8
         jmS+NIIo6wXk1H+DZldN7KwaHOwFdRjlughwxlUNo8YqLJNQolx83vBC9+TL5JaDFPB9
         ORiomIp0lKbkfH1+yQpYSgAdF90R054ILM4jnFgveLyhPWaXAsf/4Jny9qDcO7olcnXE
         7czezFfUWmsKsDYXIodeIAuqf10u7AinKa2pJsXkoNZ+1yanP1AUuQCeXjoDcTQg0NPP
         f5HY+fL/L2fUTHbGoQBrERAefUW3mk/dv1RNZ4kPqqe5SPUWKY159tCl81VPCMaBvQyT
         Lj3g==
X-Gm-Message-State: APjAAAXeJTE+AwVdGB3ljhuAS5JOzk4wmzsu/hI23/czoffYJoBgu3P+
        amBxKLekRTKppB2745dKHP0=
X-Google-Smtp-Source: APXvYqxBqeXUyq1teaFa4fkKWIbtPycOJ/8SYD+RwPaZw9KfckkCybp6FqgpqOzHetVbXGCCHJVtow==
X-Received: by 2002:a17:902:2d03:: with SMTP id o3mr16750459plb.309.1558035182134;
        Thu, 16 May 2019 12:33:02 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:4894])
        by smtp.gmail.com with ESMTPSA id x17sm7839076pgh.47.2019.05.16.12.33.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 12:33:01 -0700 (PDT)
Date:   Thu, 16 May 2019 12:32:59 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "vakul.garg@nxp.com" <vakul.garg@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net 3/3] Documentation: add TLS offload documentation
Message-ID: <20190516193257.2edzss37shzfrm6v@ast-mbp>
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
 <20190515204123.5955-4-jakub.kicinski@netronome.com>
 <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
 <20190516105652.36c81a1a@cakuba.netronome.com>
 <CAADnVQ+eFX8S2go=SeQ9kdP_3yGckHF-_Aevv7x+EbJQgsCgmw@mail.gmail.com>
 <20190516114203.6b8ca20b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516114203.6b8ca20b@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 11:42:03AM -0700, Jakub Kicinski wrote:
> On Thu, 16 May 2019 11:13:47 -0700, Alexei Starovoitov wrote:
> > On Thu, May 16, 2019 at 10:57 AM Jakub Kicinski wrote:
> > >
> > >   The preferred method of reporting the Layer 4 (TCP) checksum offload
> > >   for packets decrypted by the device is to update the checksum field
> > >   to the correct value for clear text and report CHECKSUM_UNNECESSARY
> > >   or CHECKSUM_COMPLETE computed over clear text. However, the exact
> > >   semantics of RX checksum offload when NIC performs data modification
> > >   are not clear and subject to change.  
> > 
> > when host is consuming the tcp stream I don't see the value of
> > tcp checksum on top tls.
> > In that sense CHECKSUM_UNNECESSARY is fine and no
> > need to update checksum field.
> > Even in case of sockmap and tcp stream redirect it is still fine.
> > Only the tcp payload being redirected to a different tcp socket
> > and the headers are gone.
> > So imo in all cases CHECKSUM_UNNECESSARY is fine
> > even without adjustment to checksum field.
> 
> No question that CHECKSUM_UNNECESSARY currently works.  
> But it's not "entirely" correct without the header fixup?
> Device modifies the data - it should fix up the checksum.

I think it's an interesting angle to discuss.
Though ktls in hw is done per packet many key fields of ip/tcp headers
are fully processed. socket is selected and payload is decrypted.
imo it is better to state that such headers have been 'consumed' by hw.
Where 'consumed' would mean that hw did what network layering suppose to do
and the stack should not look at them (because they can contain garbage).
(in that sense it's fine to keep csum unadjusted. imo it's ok to zero-out IP too)
Such decrypted skb is essentially a wrapper of payload plus
left-over headers passed to the stack.
I think it makes sense to clarify which headers have been consumed/processed.
Like: IP4/6+protocol+port+csum - processed, whereas
tcp bits, dscp, ecn are still valid and have to be processed by the stack.

> I was trying (unsuccessfully) to hint at the fact that it's okay 
> today to leave the checksum be, but at the same time if someone 
> is designing new HW or has the ability to fix this up in microcode
> I think the TCP csum should be fixed..

I don't think so. hw should work together with the stack
instead of being 'inline transparent decryption box'.
If hw decrypts stuff and adjusts csum it would imply that stack
will see completely valid headers. It would also imply that
the stack must check csum.
That doesn't seem right from trust point of view.

> 
> Maybe like this?
> 
>   The preferred method of reporting the Layer 4 (TCP) checksum offload
>   for packets decrypted by the device is to update the checksum field
>   to the correct value for clear text and report CHECKSUM_UNNECESSARY
>   or CHECKSUM_COMPLETE computed over clear text. 
> 
>   Some existing devices may report CHECKSUM_UNNECESSARY without fixing
>   the checksum field, which currently functions correctly but is not
>   in line with the exact semantics of RX checksum offload. Such devices
>   must make sure that RXCSUM offload is always enabled for TLS offloaded
>   flows.

I don't like it for the reasons above.

> > Obviously the hw/firmware should have checked tcp csum before doing decrypt.
> 
> Ah, that is definitely worth stating, will add!
