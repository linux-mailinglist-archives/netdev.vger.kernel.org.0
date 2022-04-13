Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BA14FF451
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiDMKCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiDMKCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:02:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EAE222AE;
        Wed, 13 Apr 2022 02:59:56 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p8so1533289pfh.8;
        Wed, 13 Apr 2022 02:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:references:from
         :in-reply-to:content-transfer-encoding;
        bh=YBthZ0eze8nVpk54x8pCct5mZl/8y/i9wt+wRTM/fgQ=;
        b=oN5SqkhBwdo06EArq/0Dqkx/iqN5CvwVwoaX2Rm+nVhtvubf0pOmOz2K7rU2qxmii5
         kjAnBTBMdy0PQrfToaKNQ80sE9d1ItLu3/eq1825AyUAm1fNjDmMXCcsiGD3p7jKcTEx
         M4uBmR6FSOJImLjl33S8iAT7fMOXhLAo7kh1CpB+0xpoj99yojrCmeo4VU3OYoWLh+ul
         34kPxh+gdaoi5oncVAajWbiCHuYYIEOYE/Ti5kELguDwKY5lmN6MJ9S5hCCrChWOMC59
         p2up5CzznttKka5LBZZrHUqddiKJUAZmTbXS+UH52usM/N0ySEhRyUJHdyTwWSXcgNZe
         Lb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=YBthZ0eze8nVpk54x8pCct5mZl/8y/i9wt+wRTM/fgQ=;
        b=0AYYD1F0Szm3j6lmy2rOOfGA+fEBniy1wUp4p3eHCy7KCAhSaUUq6KCjcDJCiAN7Ew
         qJ3J3/6Dyk8Em6Ih35YokKNO6D+Y4jM/MY9yMWh2dkERnjjOK7RZ0rnIB1xM7ilJ4dWx
         xFd+o+fBXCEjMxiCZ8pNk3D3WSr4UphcAzA1iwYbpNTtuvHjNzHUQf62L2w0/7r15/Lc
         4wWtKNoHcfC2iUg139jlPog2IH6ioBGlivVrVXZTDAHLdlQif6i/fWDPJrESbk6aRzZR
         PmW+c5TiEuiORCSLGVayxtEftYJjn57U0mm+p3DQNEATD84djSc8rgelzCOgm4bpreJA
         DB+w==
X-Gm-Message-State: AOAM531gnTRq7GkFQNiEvcj/QBk7GSBtnpat8FWy5FDtbj4FY4DqI9Cb
        LhAt8dkY97ILnONyeVtgzVw=
X-Google-Smtp-Source: ABdhPJxvyqF7/nKsbzyRtw8lGkoIYK+P06NBwmfWkj/8gF3B/olHVZWDOLAWyIO/2CAqZUFHTqYuuw==
X-Received: by 2002:a63:f201:0:b0:399:2b10:3433 with SMTP id v1-20020a63f201000000b003992b103433mr33414733pgh.285.1649843995476;
        Wed, 13 Apr 2022 02:59:55 -0700 (PDT)
Received: from [172.25.58.87] ([203.246.171.161])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78090000000b0050583cb0adbsm17651597pff.196.2022.04.13.02.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 02:59:54 -0700 (PDT)
Message-ID: <805b4f95-5351-b342-7177-6a3df979be17@gmail.com>
Date:   Wed, 13 Apr 2022 18:59:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [EXT] [PATCH net-next v4 0/3] net: atlantic: Add XDP support
To:     Igor Russkikh <irusskikh@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        bpf@vger.kernel.org
References: <20220408181714.15354-1-ap420073@gmail.com>
 <dac72406-2743-ce1a-a0d7-4078e5d222be@marvell.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <dac72406-2743-ce1a-a0d7-4078e5d222be@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022. 4. 13. 오후 4:52에 Igor Russkikh 이(가) 쓴 글:

Hi Igor,

Thank you so much for your review!

 >
 >
 >> v4:
 >>   - Fix compile warning
 >>
 >> v3:
 >>   - Change wrong PPS performance result 40% -> 80% in single
 >>     core(Intel i3-12100)
 >>   - Separate aq_nic_map_xdp() from aq_nic_map_skb()
 >>   - Drop multi buffer packets if single buffer XDP is attached
 >>   - Disable LRO when single buffer XDP is attached
 >>   - Use xdp_get_{frame/buff}_len()
 >
 > Hi Taehee, thanks for taking care of that!
 >
 > Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
 >
 > A small notice about the selection of 3K packet size for XDP.
 > Its a kind of compromise I think, because with common 1.4K MTU we'll 
get wasted
 > 2K bytes minimum per packet.
 >
 > I was thinking it would be possible to reuse the existing page 
flipping technique
 > together with higher page_order, to keep default 2K fragment size.
 > E.g.
 > ( 256(xdp_head)+2K(pkt frag) ) x 3 (flips) = ~7K
 >
 > Meaning we can allocate 8K (page_order=1) pages, and fit three xdp 
packets into each, wasting only 1K per three packets.
 >
 > But its just kind of an idea for future optimization.
 >

Yes, I fully agree with your idea.
When I developed an initial version of this patchset, I simply tried 
that idea.
I expected to reduce CPU utilization(not for memory optimization), but 
there is no difference because page_ref_{inc/dec}() cost is too high.
So, if we tried to switch from MEM_TYPE_PAGE_ORDER0 to 
MEM_TYPE_PAGE_SHARED, I think we should use a littie bit different 
flipping strategy like ixgbe.
If so, we would achieve memory optimization and CPU optimization.

Thanks a lot,
Taehee Yoo

 > Regards,
 >    Igor
