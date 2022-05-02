Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD86516A2D
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 06:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357727AbiEBE74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 00:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346303AbiEBE7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 00:59:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F0D4ECC3
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 21:56:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so3229416pjv.4
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 21:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4dhb9v9kYy+OHPvVdqU5ZZAdvvgFWW/5Cv3E5ssA+8c=;
        b=pzUO4gbsdZE1aBj51RSWn1oZpb9jcQi4gYDBKuli2KTK1Cr5xpx/8S18g/g513qla9
         ahxniT1MAiYj8lrv3wZssMgyzAIoCT7DY65WHO6avfgZ+AayKxZDBZeDWO18Kq2a9+0b
         8jUBwi6JIokYxDJwMoKeJ5LfwP0yyH0pghGt+6h1mzDqLU5RZbqho/OfkNugfxI4r3vF
         Fu1+BAmBRcJVPUauHWwY7SrERgBY+BXXLovBnDIwWdUNEANH9x6MtRP5DTET+b1/Jehq
         dW+KNxr++2ichnFWIG24Nor1vz00Sb0QXEtQBxJ5Vw6PLqtfw5OrcXbBqJUxEXDatsBz
         o1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4dhb9v9kYy+OHPvVdqU5ZZAdvvgFWW/5Cv3E5ssA+8c=;
        b=aLTs0KP9MHSnvoXRnyAzzfY9bnasppFMye/i7/yJTH0JZvHS6y5dZrcb9c69QwuxSa
         RsN98OA2VccLTt0/Qq+QPcHlSIm1LojLACripty82VoNNzElq2SVskdXPYpxT8Laoocp
         73oDhZhPsHeVL4cELYFTBbSUCTj4vGewR+ssF37wbHuAiCUbh5a55WBU+Qz+aWmAo4u3
         uzczyyLL/5vyKHAofFMn5MXbAy0dqSHxzas1SC0OpTFpUosxse0T3LwDz+ghUwT0e/yi
         p08JEYTmceSB693OnBGTw+OMgtwXt8RLM3iWfRbLbPUh6qr+03Yt6JZv/zym+vCUBm5N
         o6qQ==
X-Gm-Message-State: AOAM533ZFP3ilCLnyNXS+K6iOimJ/NlvtcCKXk3ZLdANtIcyf+FYRm8k
        53J2QRcWkiiw5CqHwS0NtEY=
X-Google-Smtp-Source: ABdhPJz109yQKtEfeTts3fTceY70PoqJfM+N4drOwLxukdnUo9hIMFNta6R1k8eN9zRNAh1p238MHw==
X-Received: by 2002:a17:902:e545:b0:15e:5bf3:e4da with SMTP id n5-20020a170902e54500b0015e5bf3e4damr10248701plf.138.1651467378370;
        Sun, 01 May 2022 21:56:18 -0700 (PDT)
Received: from [172.16.0.2] ([8.45.42.186])
        by smtp.googlemail.com with ESMTPSA id t17-20020a62ea11000000b0050dc762816dsm3671076pfh.71.2022.05.01.21.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 21:56:17 -0700 (PDT)
Message-ID: <c64a4c79-03e3-9286-1b45-29d5dfaa0502@gmail.com>
Date:   Sun, 1 May 2022 21:56:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH iproute2-next 06/11] ipstats: Add a group "link"
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>, Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1650615982.git.petrm@nvidia.com>
 <c361fce0960093e31aabbc0b45bb0c870896339e.1650615982.git.petrm@nvidia.com>
 <Ym6ek66a6kMH3ZEu@shredder>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <Ym6ek66a6kMH3ZEu@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/22 8:52 AM, Ido Schimmel wrote:
> When I tested this on 5.15 / 5.16 everything was fine, but now I get:
> 
> $ ip stats show dev lo group link
> 1: lo: group link
> Error: attribute payload too short
> 

...

> 
> Note the difference in size of IFLA_STATS_LINK_64 which carries struct
> rtnl_link_stats64: 196 bytes vs. 204 bytes
> 
> The 8 byte difference is most likely from the addition of
> rx_otherhost_dropped at the end:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=794c24e9921f32ded4422833a990ccf11dc3c00e
> 
> I guess it worked for me because I didn't have this member in my copy of
> the uAPI file, but it's now in iproute2-next:
> 
> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bba95837524d09ee2f0efdf6350b83a985f4b2f8
> 
> I was under the impression that such a size increase in a uAPI struct is
> forbidden, which is why we usually avoid passing structs over netlink.

extending structs at the end is typically allowed. The ABI breakage is
when an entry is added in the middle.


> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	open_json_object("stats64");
>> +	print_stats64(stdout, stats, NULL, NULL);
>> +	close_json_object();
>> +	return 0;
>> +}

