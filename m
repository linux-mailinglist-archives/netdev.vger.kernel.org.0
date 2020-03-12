Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BC1182977
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388068AbgCLHED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:04:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37162 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387993AbgCLHEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 03:04:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id 6so5966543wre.4
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 00:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zUfLuDxQ18AGvXZWvEqlbgVafG/zyl6TVdpWtVs7Ujw=;
        b=RCnDBiOOKAEyRZbAdFHpDpGVTz+9U7vq9voW4r4wu7aT37v6Kv3YNFW2uva2ycnVwW
         /V7NwqFl3t/pumfHCZq4A/Ah2pW1OGPBzlwnNWBQzmKA+BoK0Ubo2K/oSxCe7INVQQ9I
         5wGmuKmmJL5g8HZu+xMuFL7qIfILvlAu+pZfC4vUforQ931OAWM3dKkqFlnpIAlZbPsv
         H7jSDG0fAyd0ssDZgF3oefW1emf5T8hqEeGrnTfqJKT3tL2i9jNPXitvLChq6WgXBy6c
         kQPXqTY1mdH1zs7I+lVa3LDHJu13EDuvmp3U6cP8urM56MGOMW0idhcmzCGxEQbxKZGE
         5w/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zUfLuDxQ18AGvXZWvEqlbgVafG/zyl6TVdpWtVs7Ujw=;
        b=RP5YXr82zAYXjpveuT7ez6tqeKKzX8jMXtuPVSzrKkSnwPYAyknXdANmPdfQSb3dS7
         6zJcnAM8E5ErQ9ZLq7lpTgV4d/g4YiPeiMPBk2w6jBbAAfJVDj4qoFhN6Bhwoyh40C87
         sTz70u0eZE50RRFuu9EM6Nqm6qmM8Lcp1I9rNoujlxJKYEmQYFqRoztxcNUpf+4ntCO+
         kRF2b8C1XZT/Tg8dcDXXdWQbYUJ0PYmARJDB1QhOFo9mIeVFqWddPok/hwayI8BjhNOt
         yiH+NOljatW9zxJE10fh0fhrUuv57g+u472r0GGT4Z73VlVVXBPj1/LEvnKPMrOJQWzr
         z3zA==
X-Gm-Message-State: ANhLgQ0D7rH/YvGfWRCfc+pE/42eZMh5cKl3xzV1EYjqlVfxnmCm8UVF
        Xt0qhotj6MVQetzyd2QNF4bmjQ==
X-Google-Smtp-Source: ADFU+vsI9+4nq7eOl7PYekwJdrSbFnO0ZAnSCN0v6b2iaDTnkBY+Vn0zHWq/ufwv8ql55gZcDQCm4Q==
X-Received: by 2002:a5d:6591:: with SMTP id q17mr8804034wru.22.1583996640776;
        Thu, 12 Mar 2020 00:04:00 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u8sm27333043wrn.69.2020.03.12.00.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 00:04:00 -0700 (PDT)
Date:   Thu, 12 Mar 2020 08:03:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: Re: [patch net-next 0/3] flow_offload: follow-ups to HW stats type
 patchset
Message-ID: <20200312070359.GA2221@nanopsycho.orion>
References: <20200310154909.3970-1-jiri@resnulli.us>
 <20200310120519.10bffbfe@kicinski-fedora-PC1C0HJN>
 <20200311071955.GA2258@nanopsycho.orion>
 <20200311133028.7327abb5@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311133028.7327abb5@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 11, 2020 at 09:30:28PM CET, kuba@kernel.org wrote:
>On Wed, 11 Mar 2020 08:19:55 +0100 Jiri Pirko wrote:
>> Tue, Mar 10, 2020 at 08:05:19PM CET, kuba@kernel.org wrote:
>> >On Tue, 10 Mar 2020 16:49:06 +0100 Jiri Pirko wrote:  
>> >> This patchset includes couple of patches in reaction to the discussions
>> >> to the original HW stats patchset. The first patch is a fix,
>> >> the other two patches are basically cosmetics.  
>> >
>> >Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>> >
>> >This problem already exists, but writing a patch for nfp I noticed that
>> >there is no way for this:
>> >
>> >	if (!flow_action_hw_stats_types_check(flow_action, extack,
>> >					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
>> >		return -EOPNOTSUPP;
>> >
>> >to fit on a line for either bit, which kind of sucks.  
>> 
>> Yeah, I was thinking about having flow_action_hw_stats_types_check as a
>> macro and then just simply have:
>> 
>> 	if (!flow_action_hw_stats_types_check(flow_action, extack, DELAYED))
>> 		return -EOPNOTSUPP;
>> 
>> WDYT?
>
>I'd rather have the 80+ lines than not be able to grep for it :(
>
>What's wrong with flow_action_stats_ok()? Also perhaps, flow_act 
>as a prefix?

Well nothing, just that we'd loose consistency. Everything is
"flow_action_*" and also, the name you suggest might indicate that you
are checking sw stats. :/

