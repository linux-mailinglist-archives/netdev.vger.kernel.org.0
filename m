Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753311E3137
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbgEZVaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388740AbgEZVad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:30:33 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0982C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 14:30:33 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id y9so551907qvs.4
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 14:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=L6obmAuBJ2DQncnSreVld3CzySl3cPainjgkmE8zbyY=;
        b=pcA6B1M2DaV5ulm8iEhff6eogaBiIeyE1I8Yp39EV9ETGPiHWPt9DQfXjlV85TntKn
         pzQ1vX1q4dBRi0N78lircqyNTyWov/j/4fPta6gpywUHHz3wvDGMYU/K/0b4fOtZ06d7
         NTxtBLxRQHoTSfSPqvDrAV5tWabxjP1t3SR9mvRo/pTJp+swi8QmsykakUtr8k3H8+N1
         D8QQEoHk2uAFtzCKL5rwpoASci/NMarybsK3NVE+MaCJskyKxeDnzWPEuX0+MrAruIkn
         MVlxW4CYypE5GAWea1yQOgE7yv2Td9nDpc3rLVNDhM9WrgSrwA84NICybpDT/H3+wKW6
         Q4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L6obmAuBJ2DQncnSreVld3CzySl3cPainjgkmE8zbyY=;
        b=nkS7cdqWwG7yRvhaUKDWO2Lq+Woa8I6ZOGXeu5RI9R0lsIrLPEbaGxnkZPEslVZ4+9
         kyCLjmV64smdGQy4Ml1pBmPFiSunnQGyN2cAq9X6vuC4KogNKIKooLWBhBSdKHazVfls
         HEAl9BXbYkyFfKUsK9gTXGrIOhl9SvmkgOx/bnO/MIl4tatf43v1CeIJ8The+zVimQPj
         y1Kxyvnc5zfjNwCPeRD2Z6my2n0VDdosKv4NtpamWfD+fIkcU4BlBxIWDKCHfVhF/5je
         hnDvbZwl/I0YN7Lh6OJxiFwwTYbjz7KDGdv38WWhN4k0r0KGTwPnKPFh2LcYE1SYVELK
         zqSQ==
X-Gm-Message-State: AOAM531ZRCiVKeinu8cH/kHm5F2Uo4h4WuQA6kUBRdRAzpQTwQknuVb/
        g7nOrJzgXfjSw7MEsK0f2PQ=
X-Google-Smtp-Source: ABdhPJxIGO8svpIJAkhtgT8jlcZP6ZR8lzqyD2kHSJVv2jf16r11L0/6sG4+AkgfwoZlkEfzax0a8g==
X-Received: by 2002:a05:6214:1491:: with SMTP id bn17mr22747662qvb.138.1590528632664;
        Tue, 26 May 2020 14:30:32 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id y28sm803081qtc.62.2020.05.26.14.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 14:30:32 -0700 (PDT)
Subject: Re: bpf-next/net-next: panic using bpf_xdp_adjust_head
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brouer@redhat.com" <brouer@redhat.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
 <52d793f86d36baac455630a03d76f09a388e549f.camel@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4c24cb6b-eced-051f-014b-410cd95d5cef@gmail.com>
Date:   Tue, 26 May 2020 15:30:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <52d793f86d36baac455630a03d76f09a388e549f.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 3:23 PM, Saeed Mahameed wrote:
> 
> looks like: xdp->data_meta has some invalid value.
> and i think its boundaries should be checked on 
> bpf_xdp_adjust_head() regardless of the issue that you are seeing.
> 
> Anyway I can't figure out the reason for this without extra digging
> since in mlx5 we do xdp_set_data_meta_invalid(); before passing the xdp
> buff to the bpf program, so it is not clear why would you hit the
> memove in bpf_xdp_adjust_head().
> 
>> [ 7270.033014]  bpf_xdp_adjust_head+0x68/0x80
>> [ 7270.037126]  bpf_prog_7d719f00afcf8e6c_xdp_l2fwd_prog+0x198/0xa10
>> [ 7270.043284]  mlx5e_xdp_handle+0x55/0x500 [mlx5_core]
>> [ 7270.048277]  mlx5e_skb_from_cqe_linear+0xf0/0x1b0 [mlx5_core]
>> [ 7270.054053]  mlx5e_handle_rx_cqe+0x64/0x140 [mlx5_core]
>> [ 7270.059297]  mlx5e_poll_rx_cq+0x8c8/0xa30 [mlx5_core]
>> [ 7270.064373]  mlx5e_napi_poll+0xdc/0x6a0 [mlx5_core]
>> [ 7270.069260]  net_rx_action+0x13d/0x3d0
>> [ 7270.073020]  __do_softirq+0xdd/0x2d0
>>
>>
>> git bisect chased it to
>>   13209a8f7304 ("Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>>
> 
> Are you testing vanilla kernel ? 

yes - git bisect had no changes on top.

> 
> what does the xdp program do with the frame/xdp_buff other than
> bpf_xdp_adjust_head()/ i mean which other bpf helper is it calling ?
> 

nothing relevant. map lookup of a <mac,vlan> pair, map lookup of next
index, pop the vlan header, redirect to tap device:

   https://github.com/dsahern/bpf-progs/blob/master/ksrc/xdp_l2fwd.c

A program that I have been using for 5-6 months.
