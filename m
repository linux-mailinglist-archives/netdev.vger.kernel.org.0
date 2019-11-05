Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1AAEF2FD
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfKEBrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:47:36 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:42626 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKEBrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 20:47:36 -0500
Received: by mail-io1-f66.google.com with SMTP id k1so20789017iom.9
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 17:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hHtkn9iBfxYDv8+s6cOm3WxyoIgn5EHXF2oXGfFnHiA=;
        b=JXs/F3JC441MrGJbfg648VueOC65QHK+dv+bDNlT7+3hHZD/9mhzxWvMdxCqVRLT98
         qs7Pt2w80q2n6C/OAuKnUX2tbmLsnUyGqL40xV2lRF2ObkjHt4jujOkg+Chs4XsNdhFh
         pmTeYDWbfqrsRs8UzY9M8UpNuxvXnC2KWDzBpPZImRJsCtqLpVOcntI8Wu7fZ2XtSVeY
         lQH8duVGd/VGsy7/y0fDDf/SdnPjZ8z1bDJyXVV2xZEIoLON/8UJU0bUqcnlXP/7owne
         Ko4isrQEgwZ9ooXrYvv8RwNPaCH1OifD6Ny3f1n/ZcCWnxTUzzr86L2Z7VF+71TH8wT0
         Hm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hHtkn9iBfxYDv8+s6cOm3WxyoIgn5EHXF2oXGfFnHiA=;
        b=GMB9dXSIM+O6+543rShQ4BW+deJ0xKPcxWUBOVOkzVbME7PbAZhTSZkxawNwerK0jw
         Ne0CCQadm4cGWaRpCLjjTOV8AdUJF3eBl0lAvjHOVj30yzm0EaohzMt45QQ96sEz/PPM
         7CcGYPkeQLPbGGBB9S0NdHJKMwwIKPyOT/vbOJKRMbFXJ9do4KwbGlqp69VUNjzVNnKa
         VqeQCjP7iq9rNcwxZ0Xudr224KPsnHPlZBTuPqzizBUXR3gC7+l/1WVaTVmr7QcAZTEY
         T29gpVaWePy15Eux0ACpHct49JK94e6LYLEMYedfIM8ZW/aRw+Kvs/u4X6DdVKaTjJ2k
         YnNw==
X-Gm-Message-State: APjAAAW/ZngDnO/I1R7N6EFqJq4JTUz1RdgECjt5ii/CNGSl9PXajHJW
        eGA6+pJKkfePHeEy+iSJ3eI=
X-Google-Smtp-Source: APXvYqyPhjo5TxF7FJI41OQoFJesEAerb6FdsTLAIuqgqNmdzwVcrlGIn2qqxqkIik05hsSEGlrJNg==
X-Received: by 2002:a02:3309:: with SMTP id c9mr6191410jae.52.1572918455329;
        Mon, 04 Nov 2019 17:47:35 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:344b:1ced:6760:e08a])
        by smtp.googlemail.com with ESMTPSA id i26sm1791588iol.84.2019.11.04.17.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 17:47:34 -0800 (PST)
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Cc:     "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
 <20191031172330.58c8631a@cakuba.netronome.com>
 <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
 <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
 <20191101172102.2fc29010@cakuba.netronome.com>
 <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
Date:   Mon, 4 Nov 2019 18:47:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 6:38 PM, Saeed Mahameed wrote:
> On Fri, 2019-11-01 at 17:21 -0700, Jakub Kicinski wrote:
>> On Fri, 1 Nov 2019 21:28:22 +0000, Saeed Mahameed wrote:
>>> Jakub, since Ariel is still working on his upstream mailing list
>>> skills
>>> :), i would like to emphasis and summarize his point in text style
>>> ;-)
>>> the way we like it.
>>
>> Thanks :)
>>
>>> Bottom line, we tried to push this feature a couple of years ago,
>>> and
>>> due to some internal issues this submission ignored for a while,
>>> now as
>>> the legacy sriov customers are moving towards upstream, which is
>>> for me
>>> a great progress I think this feature worth the shot, also as Ariel
>>> pointed out, VF vlan filter is really a gap that should be closed.
>>>
>>> For all other features it is true that the user must consider
>>> moving to
>>> witchdev mode or find a another community for support.
>>>
>>> Our policy is still strong regarding obsoleting legacy mode and
>>> pushing
>>> all new feature to switchdev mode, but looking at the facts here  I
>>> do
>>> think there is a point here and ROI to close this gap in legacy
>>> mode.
>>>
>>> I hope this all make sense. 
>>
>> I understand and sympathize, you know full well the benefits of
>> working
>> upstream-first...
>>
>> I won't reiterate the entire response from my previous email, but the
>> bottom line for me is that we haven't added a single legacy VF NDO
>> since 2016, I was hoping we never will add more and I was trying to
>> stop anyone who tried.
>>
> 
> The NDO is not the problem here, we can perfectly extend the current
> set_vf_vlan_ndo to achieve the same goal with minimal or even NO kernel
> changes, but first you have to look at this from my angel, i have been
> doing lots of research and there are many points for why this should be
> added to legacy mode:
> 
> 1) Switchdev mode can't replace legacy mode with a press of a button,
> many missing pieces.
> 
> 2) Upstream Legacy SRIOV is incomplete since it goes together with
> flexible vf vlan configuration, most of mlx5 legacy sriov users are
> using customized kernels and external drivers, since upstream is
> lacking this one basic vlan filtering feature, and many users decline
> switching to upstream kernel due to this missing features.
> 
> 3) Many other vendors have this feature in customized drivers/kernels,
> and many vendors/drivers don't even support switchdev mode (mlx4 for
> example), we can't just tell the users of such device we are not
> supporting basic sriov legacy mode features in upstream kernel.
> 
> 4) the motivation for this is to slowly move sriov users to upstream
> and eventually to switchdev mode.

If the legacy freeze started in 2016 and we are at the end of 2019, what
is the migration path?


> 
> Now if the only remaining problem is the uAPI, we can minimize kernel
> impact or even make no kernel changes at all, only ip route2 and
> drivers, by reusing the current set_vf_vlan_ndo.

And this caught my eye as well -- iproute2 does not need the baggage either.

Is there any reason this continued support for legacy sriov can not be
done out of tree?
