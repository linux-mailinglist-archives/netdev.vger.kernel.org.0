Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B421FFF7
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfEPHIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 03:08:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35893 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfEPHIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 03:08:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id s17so2070612wru.3
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 00:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2QFBfiR8VI/6EkQt+vuqBNOU1C/FdNF/sGlGiprXM9A=;
        b=YLeHLmyDO3khIOxhvjTk68vsZH0JaaSOZzt+GfRtjrN1TNZcudrRctMHXng4SS/I7c
         3ItI/rd0s3Eoi+kPhKrI2HrJrdrT90pCI/wmZLAFLGzYC6p+7yYigRrND97KiNcD39cq
         iIQPE8naS4uZ8NkUszg/ct3o8kx/QAvMPiGhM6Paz3kPfzxxi4vhv86gIgDwEi1to/vq
         YuvricyLSzuluVPsYEw0CWuRjqW+idqwg0N1SPL2SLFZlY98CvD02sD4V3pk0j4aKVDk
         ZaPKkk3EADEkefVkBJcuFyPP0qXK5+KMGAZaJVQX9ywfYRdFPDlT+yQtlOqU5QHNbiSL
         h7vw==
X-Gm-Message-State: APjAAAWD9cVtn5VMgKqMtHiOA17gPU2/Ihh42BC9vRG5y+LvHjr+0jXV
        9jPZn2hJ/BhQW0VDyZxxTPw8jg==
X-Google-Smtp-Source: APXvYqw/XTuFioPhzaxrGOO8i0SgiDZ+sf087TBN/7+xA54JWipsUns+nX80rrXU1SpsZxTYHNrcCg==
X-Received: by 2002:adf:8184:: with SMTP id 4mr30276940wra.27.1557990514979;
        Thu, 16 May 2019 00:08:34 -0700 (PDT)
Received: from [192.168.1.105] (bzq-79-181-17-143.red.bezeqint.net. [79.181.17.143])
        by smtp.gmail.com with ESMTPSA id s10sm3062588wrt.66.2019.05.16.00.08.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 00:08:34 -0700 (PDT)
Subject: Re: CFP: 4th RDMA Mini-Summit at LPC 2019
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yuval Shaia <yuval.shaia@oracle.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20190514122321.GH6425@mtr-leonro.mtl.com>
 <20190515153050.GB2356@lap1> <20190515163626.GO5225@mtr-leonro.mtl.com>
 <20190515181537.GA5720@lap1>
From:   Kamal Heib <kheib@redhat.com>
Message-ID: <df639315-e13c-9a20-caf5-a66b009a8aa1@redhat.com>
Date:   Thu, 16 May 2019 10:08:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515181537.GA5720@lap1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/19 9:15 PM, Yuval Shaia wrote:
> On Wed, May 15, 2019 at 07:36:26PM +0300, Leon Romanovsky wrote:
>> On Wed, May 15, 2019 at 06:30:51PM +0300, Yuval Shaia wrote:
>>> On Tue, May 14, 2019 at 03:23:21PM +0300, Leon Romanovsky wrote:
>>>> This is a call for proposals for the 4th RDMA mini-summit at the Linux
>>>> Plumbers Conference in Lisbon, Portugal, which will be happening on
>>>> September 9-11h, 2019.
>>>>
>>>> We are looking for topics with focus on active audience discussions
>>>> and problem solving. The preferable topic is up to 30 minutes with
>>>> 3-5 slides maximum.
>>>
>>> Abstract: Expand the virtio portfolio with RDMA
>>>
>>> Description:
>>> Data center backends use more and more RDMA or RoCE devices and more and
>>> more software runs in virtualized environment.
>>> There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
>>> Virtio is the optimal solution since is the de-facto para-virtualizaton
>>> technology and also because the Virtio specification allows Hardware
>>> Vendors to support Virtio protocol natively in order to achieve bare metal
>>> performance.
>>> This talk addresses challenges in defining the RDMA/RoCE Virtio
>>> Specification and a look forward on possible implementation techniques.
>>
>> Yuval,
>>
>> Who is going to implement it?
>>
>> Thanks
> 
> It is going to be an open source effort by an open source contributors.
> Probably as with qemu-pvrdma it would be me and Marcel and i have an
> unofficial approval from extra person that gave promise to join (can't say
> his name but since he is also on this list then he welcome to raise a
> hand).

That person is me.
Leon: Is Mellanox willing to join too?

> I also recall once someone from Mellanox wanted to join but not sure about
> his availability now.
> 
>>
>>>
>>>>
>>>> This year, the LPC will include netdev track too and it is
>>>> collocated with Kernel Summit, such timing makes an excellent
>>>> opportunity to drive cross-tree solutions.
>>>>
>>>> BTW, RDMA is not accepted yet as a track in LPC, but let's think
>>>> positive and start collect topics.
>>>>
>>>> Thanks
