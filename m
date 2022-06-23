Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB38E55878E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 20:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbiFWS37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 14:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbiFWS3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 14:29:47 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDC681722
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 10:31:35 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id n14so1874716ilt.10
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 10:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bUBknSEGsBk7wGnr9MVOGW8YA4bz/PMoNr2Uq79MhTg=;
        b=d/Px6J27RdJ2MDRMRpRyol0NPvhIGIayOi8+xg9C3IqKntTuJo6SnaeSbFGssF9N0R
         zxVs1eO0kkbErzHm1gynKfjWKmAUa4EyBfPggBLhIQ+NsgCW+GLAu5h4igbuiEo9yci+
         SnXum3ftCNShquPrB+2nufO/RER1QdQhsrOd77hwBkkC/BKexdk3nW9wTctE4ZX8zsYx
         ib6LG8SbuI5rQ8UUschUE/dvrM2y3lI6s0A5NtCFdhcaHu1zW5Hbqt9o5gEXbDibwz2D
         yPwlHe6Rmrb6DlU0dWvUFr9d9im3pB35GXEQLotBXdeBpUcLaH9Q4OjoN2CG1isFdqej
         eIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bUBknSEGsBk7wGnr9MVOGW8YA4bz/PMoNr2Uq79MhTg=;
        b=RK4GIS1pjM4jNPUtIViyYf/LZRD74PnZT0/nTU8puFT69UDNtVKAlxY5ltLge/nyFk
         OYDxPNNjN3uNN/qmhfOzIi23KpNeTay7Joh5q6vY2HTCfmDp7VkM/dkxXDU52DWBqMk0
         ql3SIp4eJbYlLa7J942mHQVhijCvD71IfwkRALf7n07iFCL4fzcq+cbzoCL9AqukyvGT
         22X9TvjNy5XvMud6HgTqNHqhxidTwahlsLRL1t7aoigu/oWX4Vy+dnUs9ESW4VP1IKZq
         LSCDAfmqQ4qPMd7nAJyK1fwsCiIbHLTGN6wNVrvJ96ioJj+9BxzICbET2syfDgQG/Fi6
         /kaA==
X-Gm-Message-State: AJIora/PZxUJ59Z6iay9KWTNNpqeZ1qc+pPcZtR5yLmXS8E2oxOLRqXg
        TFdAnzUSCPCOVLyrHXkYNvjP8vQ+OYpchw==
X-Google-Smtp-Source: AGRyM1ulvaDG03IbR7RQlznSKiHk706qnzopRG/TbM9QOHmDyzcqdIBIPcTybeWzIqJkM14bwYBbJQ==
X-Received: by 2002:a92:ca4d:0:b0:2d3:dce1:1ee1 with SMTP id q13-20020a92ca4d000000b002d3dce11ee1mr5745902ilo.301.1656005495172;
        Thu, 23 Jun 2022 10:31:35 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:a54b:f51d:f163:ba49? ([2601:282:800:dc80:a54b:f51d:f163:ba49])
        by smtp.googlemail.com with ESMTPSA id u18-20020a92ccd2000000b002d8d813892csm82469ilq.8.2022.06.23.10.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 10:31:34 -0700 (PDT)
Message-ID: <da0875aa-6829-c396-0577-2e400c1041c7@gmail.com>
Date:   Thu, 23 Jun 2022 11:31:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ismael Luceno <iluceno@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220615171113.7d93af3e@pirotess>
 <20220615090044.54229e73@kernel.org> <20220616171016.56d4ec9c@pirotess>
 <20220616171612.66638e54@kernel.org> <20220617150110.6366d5bf@pirotess>
 <20220622131218.1ed6f531@pirotess> <20220622165547.71846773@kernel.org>
 <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
 <20220623090352.69bf416c@kernel.org>
 <bd76637b-0404-12e3-37b6-4bdedd625965@gmail.com>
 <20220623093609.1b104859@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220623093609.1b104859@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/22 10:36 AM, Jakub Kicinski wrote:
> On Thu, 23 Jun 2022 10:17:17 -0600 David Ahern wrote:
>>> Yup, the question for me is what's the risk / benefit of sending 
>>> the empty message vs putting the _DUMP_INTR on the next family.
>>> I'm leaning towards putting it on the next family and treating 
>>> the entire dump as interrupted, do you reckon that's suboptimal?  
>>
>> I think it is going to be misleading; the INTR flag needs to be set on
>> the dump that is affected.
> 
> Right, it's a bit of a philosophical discussion but dump is delineated
> but NLMSG_DONE. PF_UNSPEC dump is a single dump, not a group of multiple
> independent per-family dumps. If we think of a nlmsg as a representation
> of an object having an empty one is awkward. What if someone does a dump
> to just count objects? Too speculative?
> 
> I guess one can argue either way, no empty messages is a weaker promise
> and hopefully lower risk, hence my preference. Do you feel strongly for
> the message? Do we flip a coin? :)

I do not; history suggests it is a toss up.

> 
>> All of the dumps should be checking the consistency at the end of the
>> dump - regardless of any remaining entries on a particular round (e.g.,
>> I mentioned this what the nexthop dump does). Worst case then is DONE
>> and INTR are set on the same message with no data, but it tells
>> explicitly the set of data affected.
> 
> Okay, perhaps we should put a WARN_ON_ONCE(seq && seq != prev_seq)
> in rtnl_dump_all() then, to catch those who get it wrong.

with '!(nlh->msg_flags & INTR)' to catch seq numbers not matching and
the message was not flagged?
