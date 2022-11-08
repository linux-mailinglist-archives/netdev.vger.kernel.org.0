Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4E462181F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiKHPYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiKHPYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:24:18 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104585985F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:24:12 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id 63so11692136iov.8
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 07:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9V4MOml3HEn6m2v+/yUNYxxeo76fdDC/XiEaDx0ovUE=;
        b=JkTYsItJW1ku0d8tBnRV7LqDfDdeZrk5IGatBfwZd7i4HM+8uMbZ6RRJi1ptDxDcN0
         bcy2/ximjcPe68SI9nch1+A4aL2IFECoXnfyCRNWizY29gd5Nnw/PvILZy1f1Zrq7vo2
         El1T9mBUJcwjQrtCfGV+5r2bJG9VeXVIa+9UAnZMcAnQNzS3JGZ3JlVPctbxCbjg9DEO
         FDm6ntf8fWtzU3wvVwG/YakgYO/E4BvFQedZ9Xd9Vo4R2K6FLwCdLZUGPxS2Gco930k8
         UIBi1z72Ht5WwTh+xO4kajnTJZWdfcuPH5+8xDLGKEOMSZt26HOj5gL1r/U2Q+YT0wYx
         8J8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9V4MOml3HEn6m2v+/yUNYxxeo76fdDC/XiEaDx0ovUE=;
        b=PAiKoZa85b9fSQFmgP2MwgwATjK0ZjbA1EqRIEq4vt1myi3RPSw8zfTCsFO3c2BYy8
         7vYK1KOV3txbhGhOI+XhSUIacteuDX6nd5OJfBhzFHrn5x5iJqAf2WowO/f7ONhTT7Ez
         xTiKzYwcavOrDeOgnONLK0YxVeG8icBZuLxqGfV9FqyEcQppg8yvxMfx6u1WK+JojTeU
         mdHkrYO2sfvXjnTshkdxVF2+qkJscEe9VRLmAbYzvZdJltZhv9XfGTLTv7BdeKrwmfJl
         aQ+h42ZApJCESh9wZutmq67U+/yYVQDUsczZryNY0H0uDuTdvYzOnf1wxgguzlPMHV7A
         zQzg==
X-Gm-Message-State: ACrzQf2F0JPaJdEc5+yi3CsPhKXz3kaHvlk2k+ytli/aBOdq0/4oO/dc
        wg+ijfPv7MVQRJfbOabdPw9+IzxLK9A=
X-Google-Smtp-Source: AMsMyM54YpqMqwo1dyjhnea0R4j2c0JVzTfZcSGzyGFqkTu7/brvBMKpIlqZQs13AydqVrQ5MSBvrA==
X-Received: by 2002:a02:a08d:0:b0:374:ad42:31ec with SMTP id g13-20020a02a08d000000b00374ad4231ecmr32921595jah.8.1667921051944;
        Tue, 08 Nov 2022 07:24:11 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:a10c:23e5:6dc3:8e07? ([2601:282:800:dc80:a10c:23e5:6dc3:8e07])
        by smtp.googlemail.com with ESMTPSA id v13-20020a92c6cd000000b00300bcda1de6sm3946109ilm.35.2022.11.08.07.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 07:24:10 -0800 (PST)
Message-ID: <e0c4cb98-54bf-b4f4-de05-dd90e3a0db98@gmail.com>
Date:   Tue, 8 Nov 2022 08:24:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCHv2 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, Liang Li <liali@redhat.com>
References: <20221108070035.177036-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221108070035.177036-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/22 12:00 AM, Hangbin Liu wrote:
> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
> transport header to be set first. But there is no rule to ask driver set
> transport header before netif_receive_skb() and bond_handle_frame(). So
> we will not able to get correct icmp6hdr on some drivers.
> 
> Fix this by checking the skb length manually and getting icmp6 header based
> on the IPv6 header offset.
> 
> Reported-by: Liang Li <liali@redhat.com>
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
> ---
>  drivers/net/bonding/bond_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


