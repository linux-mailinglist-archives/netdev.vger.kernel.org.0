Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC10B260931
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgIHEHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgIHEHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:07:38 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A36EC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 21:07:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v196so9878133pfc.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 21:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p9eznaLrFq4dmlemslALMPdnj1dLmHrJBKdUTBfEbdU=;
        b=QBZcuuc74Tq8JZWbjNFK4XRRGMNxYc2Qx3gX3k8XlusdHd9wKvN1Jw8B3FX3zI4T5a
         qRriq9l9lMEyK/IouS5BeM2ktGCyBezudOmRpDVLzUrcmNCXi56CP0iqGH9VjYo2qbfe
         SayaYfQSNmh2BtD5uZJxI0BnRLgMWx/569MS6+LmYkz+jfL9s50ioiYzU8ipLg0NvFfj
         yEvk5JYUBdyj48qvGqzsdxE+oV5JSmB3mJNrPhg8oq9XKq5EKpdHMPjuj4P64FfjkEuQ
         +HDeSmeTSGMbHc+XnDgM3Vsg7Rq9QYMyKg3h0QBbQAtpD6ecGO5d31rbYSJK8PD26Ehh
         e1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p9eznaLrFq4dmlemslALMPdnj1dLmHrJBKdUTBfEbdU=;
        b=DLxXGBvaCXRor/bTMCyaaQaQcnUOandwEqyK1JPzla3wnuSdJhiht/IGD3Oq2jXqt3
         7Q9dh/HK3eXLZ4VPxjIXWZtaJ2zhS6sLFAZWhd8MoJFMLEwo6jmZhK3fBB/f/8c45NNl
         4rexZNVn9wN8GpCP/P4q4/Eo3i2WRq4xzxRrjmcoag1eRyidZCG84vbmxxqYW02EifRy
         Wo6XrH4r4Bi4pK0kq2m8jURz0B7r38ydRnqgwIpIZHZKp+DIPxo3jylF8QYITQvL5mX0
         KJ4XlmjXu3avCG4K9+fbrhYSHF1127nNalF5CCtIvbZ729vKDz86FvDPpQXlv1NpC4/k
         ppXA==
X-Gm-Message-State: AOAM533TjzmKahzfLtYZFfWNDwmDG8jtghW/oJkCvMwf9jqdrjrEVX8/
        lzi78A5y7btC/z0R1IIYkXwhjzZDJe4=
X-Google-Smtp-Source: ABdhPJySj6/+O9dXn0RlMBp2icZ7CG6q5kTGo5dqVDRCECWKu+rabHNSUl///wlWezSz+iUOuBrUNQ==
X-Received: by 2002:a62:4d41:: with SMTP id a62mr22969299pfb.234.1599538056769;
        Mon, 07 Sep 2020 21:07:36 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 131sm16532135pfy.5.2020.09.07.21.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 21:07:35 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
Date:   Mon, 7 Sep 2020 21:07:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907182910.1285496-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 11:29 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> drivers to always receive bridge VLANs"), DSA has historically been
> skipping VLAN switchdev operations when the bridge wasn't in
> vlan_filtering mode, but the reason why it was doing that has never been
> clear. So the configure_vlan_while_not_filtering option is there merely
> to preserve functionality for existing drivers. It isn't some behavior
> that drivers should opt into. Ideally, when all drivers leave this flag
> set, we can delete the dsa_port_skip_vlan_configuration() function.
> 
> New drivers always seem to omit setting this flag, for some reason. So
> let's reverse the logic: the DSA core sets it by default to true before
> the .setup() callback, and legacy drivers can turn it off. This way, new
> drivers get the new behavior by default, unless they explicitly set the
> flag to false, which is more obvious during review.
> 
> Remove the assignment from drivers which were setting it to true, and
> add the assignment to false for the drivers that didn't previously have
> it. This way, it should be easier to see how many we have left.
> 
> The following drivers: lan9303, mv88e6060 were skipped from setting this
> flag to false, because they didn't have any VLAN offload ops in the
> first place.
> 
> Also, print a message to the console every time a VLAN has been skipped.
> This is mildly annoying on purpose, so that (a) it is at least clear
> that VLANs are being skipped - the legacy behavior in itself is
> confusing - and (b) people have one more incentive to convert to the new
> behavior.
> 
> No behavior change except for the added prints is intended at this time.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

You should be able to make b53 and bcm_sf2 also use 
configure_vlan_while_not_filtering to true (or rather not specify it), 
give me until tomorrow to run various tests if you don't mind.
-- 
Florian
