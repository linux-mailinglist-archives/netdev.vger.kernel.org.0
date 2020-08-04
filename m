Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCB923B5E7
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 09:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgHDHmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 03:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgHDHmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 03:42:11 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A8BC06174A;
        Tue,  4 Aug 2020 00:42:10 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id f7so36447538wrw.1;
        Tue, 04 Aug 2020 00:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oCXgLsgWbZCbyr3KPP51MnphTqhD3dbi1xLbjo5qgUw=;
        b=pPBk/pq765sG+BX2ASJVVDKk3hdht1AvcAhGySAHN5qiPg3ZIBcbxpIYB+PzpFwkp7
         XfXDeA6Io4RxHXDRE7SDx2jcJnsdS+0W64eVBTudh8NsVnAj86kffUvPTaB7oL7FL/iY
         YiTqM9VGVRWhppFju3BPI+jtEmiMvl6DCCFrbFNFBJA0o/oW3vhcKX3i9JGmIrrwjwfl
         LUI7Uv2jq/FOkllQGoUZa66Aw9X9YNua6Npv8l5cqOC6QveDgz5ai2BuzOU1IfQ4ZAXG
         BkMR3TC5P/iqJXsR8lDpXUEFm3topseHo4/qNeIcjCo30wD207pqaFcviHzwCtvgL+f+
         5XqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oCXgLsgWbZCbyr3KPP51MnphTqhD3dbi1xLbjo5qgUw=;
        b=AhJR65H6j9j4M3tyrG3cb4eh1Fj3vnBCVltvUjAojz9isQdp2jn6DE+BlEu42qEwHz
         qhLTguCPx+I5oXAVBqB/k5/N+6hb2B8oFYe4F1tOZkoFbvnJ1y6kx86IyrBkkzMoVi5g
         ef7EQUmBUWgZrf89aEgNWesL86ede0+HNl3HRJ9eYscCc19mZKghTI2WK1z084guxd91
         V3tDH6Vvup0rM0p0B9QFRsYrNnQnINc1+1rcQdURYrWeekrDj0Aq18Q85+H89ImdKa/J
         svpAVSVZOeesYLUjRkRvZ7/iBefGqADaMqocxDNFWkRcWr6Oh4cPDDnJ+khvZ5SIuerC
         NqZw==
X-Gm-Message-State: AOAM530VDA3Gl14OaOyBlTIeshKbf9Oh5Ieqszh6CUZAZL+IdbWm68H1
        XHa5Q2PsR5/Bg6e/zp7ClFc=
X-Google-Smtp-Source: ABdhPJxBVh6kS4sYJbaFdvCZlDfGQsTPSi7bhe7SM+TPnA1jxSlmGcmB9HNCP3wZpUj5HCOFu649IA==
X-Received: by 2002:adf:ba05:: with SMTP id o5mr884422wrg.7.1596526929473;
        Tue, 04 Aug 2020 00:42:09 -0700 (PDT)
Received: from [10.55.3.148] ([173.38.220.44])
        by smtp.gmail.com with ESMTPSA id l1sm30748857wrb.12.2020.08.04.00.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 00:42:08 -0700 (PDT)
Subject: Re: [net-next v2] seg6: using DSCP of inner IPv4 packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20200803181417.1320-1-ahabdels@gmail.com>
 <20200803124817.5068e06d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <01738166-f784-09f3-2286-150442ffa237@gmail.com>
Date:   Tue, 4 Aug 2020 09:42:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200803124817.5068e06d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem was the declaration of tos.
Fixed and new patch is sent.

On 03/08/2020 21:48, Jakub Kicinski wrote:
> On Mon,  3 Aug 2020 18:14:17 +0000 Ahmed Abdelsalam wrote:
>> This patch allows copying the DSCP from inner IPv4 header to the
>> outer IPv6 header, when doing SRv6 Encapsulation.
>>
>> This allows forwarding packet across the SRv6 fabric based on their
>> original traffic class.
>>
>> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
> 
> Please make sure it builds cleanly with W=1 C=1:
> 
> net/ipv6/seg6_iptunnel.c:131:21: warning: incorrect type in assignment (different base types)
> net/ipv6/seg6_iptunnel.c:131:21:    expected restricted __be32 [usertype] tos
> net/ipv6/seg6_iptunnel.c:131:21:    got unsigned char
> net/ipv6/seg6_iptunnel.c:133:21: warning: incorrect type in assignment (different base types)
> net/ipv6/seg6_iptunnel.c:133:21:    expected restricted __be32 [usertype] tos
> net/ipv6/seg6_iptunnel.c:133:21:    got unsigned char [usertype] tos
> net/ipv6/seg6_iptunnel.c:144:27: warning: incorrect type in argument 2 (different base types)
> net/ipv6/seg6_iptunnel.c:144:27:    expected unsigned int tclass
> net/ipv6/seg6_iptunnel.c:144:27:    got restricted __be32 [usertype] tos
> 
