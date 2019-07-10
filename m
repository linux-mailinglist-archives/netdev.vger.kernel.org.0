Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9AA6417E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 08:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfGJGlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 02:41:45 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35267 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfGJGlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 02:41:45 -0400
Received: by mail-ed1-f66.google.com with SMTP id w20so1078677edd.2
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 23:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UJPEbie5oNZBcOSKPtKnnrz7yS8rIzreKvwLVXVVa6c=;
        b=A7sS4W4Bgu4Dhf9IQy0KQ78RrwHJ99nvrPyjom2k233GsV+JP6SM4E5Dy/h/Zxkw4P
         v8GKyAN4A1ClnTLWyrflD2xcyRuPn4qZ5OwfTvCbS+PRRnmZQfBJykfmviOA/dwJhrK0
         afqhSt1wV80uAbVC6Qz4ST9Jns2EZnHhOnq5anJoiLxABJfrOUNKjpEOWlg4PAeSrRsA
         RkoOBJ95mNF/xKxB9OOHGX9EozW8weJlH95iAV5ASJBglD7+WoMsXwwUwYS7aPsAKVT6
         0Y7VmtQcLUAMw4PEqxSxSO/Te289/A6zqojMpDLOkOGOB2rsm9+IvTmvyQQ3kE6MiyzL
         YOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UJPEbie5oNZBcOSKPtKnnrz7yS8rIzreKvwLVXVVa6c=;
        b=s1YHPt0/CxZUfFY6dwNjoFFecet8XjVwZxk4mpp3CsOYpK4HfAiCwXX9mMLRF6Hr3Q
         zAWlbEGGPoNvT4BbPFTTuy4Sg59sIp4vynaR1iWWYgrWrvU+S4EPv1SK2qoz7+hvBXO4
         fM7tEjWITvMITdYOqaXO4pSzwTHO7WpZF8jBRd/s2cR2OzDMu3qzfvpNMr6QCUCQ8cgn
         OygJVRYqa7YEDgOi46MHSO8C6PAnukVKS368Be+eMMr8kS4PcmXfZNxRjpYTJAIhrVcS
         Q3E1no1IWJISdhll2HUfFoL20srwO38jl5tiakLzYbRBxkARBhIDFBEZo1JE4DEIfxX5
         oStQ==
X-Gm-Message-State: APjAAAVsTO2AJ40KjlKdnG17fcIrxWJoAvn/yZjk5tbkt+H74OJ3Vled
        tzKtAdCCQAuD60vK6YwtWsr++w==
X-Google-Smtp-Source: APXvYqzd0iY3JrZ4pKvs07gSy492ruaDoUfGwSpgk55VavnuiN71EtBmzIDVqbcuxwh+D4xuoEYkdg==
X-Received: by 2002:a50:9646:: with SMTP id y64mr29888047eda.111.1562740903886;
        Tue, 09 Jul 2019 23:41:43 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p26sm1032351wrp.58.2019.07.09.23.41.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 23:41:43 -0700 (PDT)
Date:   Wed, 10 Jul 2019 08:41:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com, parav@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Message-ID: <20190710064143.GB2282@nanopsycho>
References: <20190708224012.0280846c@cakuba.netronome.com>
 <20190709061711.GH2282@nanopsycho.orion>
 <20190709112058.7ffe61d3@cakuba.netronome.com>
 <20190709.120336.1987683013901804676.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709.120336.1987683013901804676.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 09, 2019 at 09:03:36PM CEST, davem@davemloft.net wrote:
>From: Jakub Kicinski <jakub.kicinski@netronome.com>
>Date: Tue, 9 Jul 2019 11:20:58 -0700
>
>> On Tue, 9 Jul 2019 08:17:11 +0200, Jiri Pirko wrote:
>>> >But I'll leave it to Jiri and Dave to decide if its worth a respin :)
>>> >Functionally I think this is okay.
>>> 
>>> I'm happy with the set as it is right now. 
>> 
>> To be clear, I am happy enough as well. Hence the review tag.
>
>Series applied, thanks everyone.
>
>>> Anyway, if you want your concerns to be addresses, you should write
>>> them to the appropriate code. This list is hard to follow.
>> 
>> Sorry, I was trying to be concise.
>
>Jiri et al., if Jakub put forth the time and effort to make the list
>and give you feedback you can put forth the effort to go through the
>list and address his feedback with follow-up patches.  You cannot
>dictate how people give feedback to your changes, thank you.

I don't want to do such thing. I'm just saying it's much easier to
follow the comments when they are provided by the actual code. That's it.
It's the usual way.
