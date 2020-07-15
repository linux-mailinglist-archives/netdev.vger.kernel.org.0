Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2C4220CF3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730910AbgGOMbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgGOMbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:31:45 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DD5C061755;
        Wed, 15 Jul 2020 05:31:45 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id d4so3006988pgk.4;
        Wed, 15 Jul 2020 05:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EVdYeqKXqkfSiIHIdGhiNsRiFR/DiMIknNoE91P/+/Y=;
        b=NprICiB9/dfFM3Va2F1zMt5hDyoEeKkj1Hq7pEy9zCSaWvdfCM/r76B3JlQW3O3OWK
         kAo3MQrdB1ADlkVCSRSDMKW55STjsxqeNVc5B92YXGcj/pyqgPH2P6VvNIlWMUhEiN5+
         tzby3Uka3PownLoP/KRDndJtVXN8vht4o935Tv3OIQX5ba/4zxgJahG0r+LpY1CsU5og
         IN/o+MsxGipzLoX44cgO0BDiu/S3sD9jEI94b5ZHerjInM3wlXuuJyU4UnJf01F0usXE
         JeQ5H/ETfoDgEI+VpATGW/zJcxuMAzq1EH5LlYMPDPAtU/oDFlI4sqQq5CTLc3uG3J0Q
         rhrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EVdYeqKXqkfSiIHIdGhiNsRiFR/DiMIknNoE91P/+/Y=;
        b=j2e48gJqn54sK3dcBjZvpgxulCWdYzkYVGVoyq1r7ByJP+SwIFbpr65WGATrYoAe3c
         raiXLfeZv3faBr87ernYlJCvUXSm6k10v1Mxdnsmbd3HwjRaSXdcmg3gpHU+H5sZ6/x8
         dlm4NFM1yva4kOHfeir4LOPzVHeqKT8gxWc1fam48SoMmvKG8TE7QkMKgCZScegZu0Wg
         xpn6HNB1LzrG7Z90dYSy/laLTzsTqWLGLrQrRHnGduRkyr2gyErNM8ASJrV2trG/wD/m
         TRDip5AZQs7pYKRLUoUoMXChF2hcj5tqe+gllBP7Xeur41KeA8XAY8PkyZwrImVzLyrk
         WoiA==
X-Gm-Message-State: AOAM533YpfFIdVfOpnohJklZz87Wzs/P9iS6jt8h8MFvpkQSzFF441mr
        l9kM5wHLVVN98cWAUzhw7vY=
X-Google-Smtp-Source: ABdhPJxlGbetVv5TGncsu/rWFxN7GeZjGJ4z1Rw37Bg75ydvb84lnWZgFBeTglTnRR1OSPJre6c/XA==
X-Received: by 2002:aa7:948c:: with SMTP id z12mr8687650pfk.47.1594816303609;
        Wed, 15 Jul 2020 05:31:43 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t5sm2174519pgl.38.2020.07.15.05.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 05:31:42 -0700 (PDT)
Date:   Wed, 15 Jul 2020 20:31:32 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv7 bpf-next 0/3] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200715123132.GH2531@dhcp-12-153.nay.redhat.com>
References: <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200714063257.1694964-1-liuhangbin@gmail.com>
 <87imeqgtzy.fsf@toke.dk>
 <2941a6f5-8c6c-6338-2cea-f3d429a06133@gmail.com>
 <87ft9tg3vz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ft9tg3vz.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:53:20PM +0200, Toke Høiland-Jørgensen wrote:
> >David Ahern <dsahern@gmail.com> writes:
> >>> Version         | Test                                   | Native | Generic
> >>> 5.8 rc1         | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> >>> 5.8 rc1         | xdp_redirect_map       i40e->veth      |  12.7M |   1.6M
> >>> 5.8 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> >>> 5.8 rc1 + patch | xdp_redirect_map       i40e->veth      |  12.3M |   1.6M
> >>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   7.2M |   1.5M
> >>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->veth      |   8.5M |   1.3M
> >>> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.0M |  0.98M
> >>>
> >>> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
> >>> the arrays and do clone skb/xdpf. The native path is slower than generic
> >>> path as we send skbs by pktgen. So the result looks reasonable.
> >>>
> >>> Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
> >>> suggestions and help on implementation.
> >>>
> >>> [0] https://xdp-project.net/#Handling-multicast
> >>>
> >>> v7: Fix helper flag check
> >>>     Limit the *ex_map* to use DEVMAP_HASH only and update function
> >>>     dev_in_exclude_map() to get better performance.
> >> 
> >> Did it help? The performance numbers in the table above are the same as
> >> in v6...
> >> 
> >
> > If there is only 1 entry in the exclude map, then the numbers should be
> > about the same.
> 
> I would still expect the lack of the calls to devmap_get_next_key() to
> at least provide a small speedup, no? That the numbers are completely
> unchanged looks a bit suspicious...

As I replied to David, I didn't re-run the test as I thought there should
no much difference as the exclude map on has 1 entry.

There should be a small speedup compared with previous patch. But as the
test system re-installed and rebooted, there will be some jitter to the
test result. It would be a little hard to observe the improvement.

Thanks
Hangbin
