Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912AD293399
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgJTDVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729227AbgJTDVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 23:21:30 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F73C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 20:21:30 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id g7so492043ilr.12
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 20:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fxBet3/S4Fra7VEvI44Fid5pB+keqf7wtJ5PK6Pg1uE=;
        b=R35ryTAQVvuO6AsPY2ruf5tBmJpfqBN/7gcI8gR2u2Ob/FuNfmR6bA+BnFBhC/IFg3
         50AzWE3kP5/4JLlcLO5aqVP8FChkSSO6wkS5lN9SKVMoGmh8SiJ29uXWUOfPQHNW2FDh
         e0gRG47aodOTxUL4AaVzEjQs6NlylmRQr9s66VKatjFfPv2j7KcfK1RVBwBYWR7XOT9U
         nGufYNnycxzUb5MDb3Km8HZ7nNzRNyhoI6Sh6gXEG4HUmk+QTLyb9syEwJEAZ8EtW+Kj
         eaPhVPufO/HW4tmE3odCilO5MOl6VLgjtjBRlq9gT/pH8289jWm61FRYAkr8ylLHPwLc
         oeFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fxBet3/S4Fra7VEvI44Fid5pB+keqf7wtJ5PK6Pg1uE=;
        b=OxBIBFW18GorfHmvRImNBPIDzGhUhIXHQcbtMbVy42yk9hCerrrjnPOMGTWyeLGd1c
         rlzIEe/mMogO/D6ofuSE2kZqbemhVWp4IZ0AGIMLaXzm0ten62vGxMHlLGm0UQbgceBv
         tvMTzfipOuBYNymQRfzmu4exkzCZLn8CpPjfRVa48xIxEjpJtyDdOzsPG/4H1ZufcPs6
         52hbpdXq8TC5qdiYb9y1tSLmMgkIh61Lx064DnpaxxKxCBv0qnXiZ4akzLrVhzqQnJ5n
         ipduUD4o/bojMSn+UJfXowlYc9UPpBUCjTRNFuop57/XVrZ3GsL5OVZGIUX9WQ08Zpal
         dkJA==
X-Gm-Message-State: AOAM530a7N+2jUml8kiC0pzhAspVcPd5dW4DnOc+KDgJtOEzljilfXp4
        HKMZNQtIyOQf6URzBBir810=
X-Google-Smtp-Source: ABdhPJx3DbnB1L9Sa6H5xRQLRkYkbVqoAEB37D6PVRqjmYdjionwodNEgTV0rmDmU1mbHIGdNoXg7w==
X-Received: by 2002:a92:b006:: with SMTP id x6mr504068ilh.130.1603164089640;
        Mon, 19 Oct 2020 20:21:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id m66sm763549ill.69.2020.10.19.20.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 20:21:28 -0700 (PDT)
Subject: Re: [iproute2-next v3] devlink: display elapsed time during flash
 update
To:     Jakub Kicinski <kuba@kernel.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>
References: <20201014223104.3494850-1-jacob.e.keller@intel.com>
 <f510e3b5-b856-e1a0-3c2b-149b85f9588f@gmail.com>
 <a6814a14af5c45fbad329b9a4f59b4a8@intel.com>
 <20201019122040.2eaf4272@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e48b91b3-c085-9e39-57e9-1d21b3dd4e35@gmail.com>
Date:   Mon, 19 Oct 2020 21:21:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201019122040.2eaf4272@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 1:20 PM, Jakub Kicinski wrote:
> On Mon, 19 Oct 2020 19:05:34 +0000 Keller, Jacob E wrote:
>>> The DEVLINK attributes are ridiculously long --
>>> DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT is 40 characters -- which
>>> forces really long code lines or oddly wrapped lines. Going forward
>>> please consider abbreviations on name components to reduce their lengths.  
>>
>> This is probably a larger discussion, since basically every devlink attribute name is long.
>>
>> Jiri, Jakub, any thoughts on this? I'd like to see whatever abbreviation scheme we use be consistent.
> 
> As David said - let's keep an eye on this going forward. We already 
> pushed back with Moshe's live reload work.
> 
> If you really want to make things better for this particular name
> you could probably drop the word _STATUS from it.
> 

and typical strategies - like dropping vowels.

DEVLINK_ATTR_ is the established prefix so every attribute starts at 13
characters. In this case dropping STATUS and shortening TIMEOUT so it
becomes DEVLINK_ATTR_FLASH_UPDATE_TMOUT does not overly harm the
readability yet drops the char count to 31. Still long but is an example
of what can be done.
