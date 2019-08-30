Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECECCA3CC3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 19:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfH3REX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 13:04:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39804 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfH3REW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 13:04:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so7686373wra.6
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 10:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PqIaqpCxKMujfMgHULmv8CpSRzh39am9ZhQQcuBJRDQ=;
        b=qiigz2k++B8pXH7bXGlzbyK8waTKzp1l/1XeCgtqTeQmAnDFSoCm0RyrxB7dm4mu78
         VkJgdUpvxIm+sK3i5TpSvNoWg+RFnWUoB/MLdrmEN3ehO5c3qk137xLxEmDIjThLaV+W
         oU36ZpILsubLn6S5Ogk/4WBqTMVkCZqcGGBE8JztCq2Tbzv4b1O+8C/HUvpw+Hawp61K
         ECCrR2S7To/2ZhoU1lWvvHlSNsXyOAuvcwq8Brb+Ij7TUoCV9S75IXGB10tJA362cF+p
         SFfa0xuIgRLHLxiNE2zLiucD0Gxh+YSKO37jP1i9iiSIPFLOYGIOyltAcEtcZCF9hf24
         c25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PqIaqpCxKMujfMgHULmv8CpSRzh39am9ZhQQcuBJRDQ=;
        b=IDhowpqcSMlbaFnoeeGTtV2/t2v7OSGGuEfaKDphslJEXQBdXBU8oHyKhSpKIJCdmx
         MOx6hHBYFBYlGAwphNzwSy8Y/A4sQ1WGF5jxURzFRE7YXivx29xelcYSyXSaVeI+CYj4
         e7VZ5ucsbXEMumw2WKYjzyThZ+H3A1X16J2fxxXUhpZ4o/6a6G0cBnpskiED7EG3NAQg
         J8TAPqnMmjEolIiK7xsHlv+bq6IE9rYM7qRfTHwZf7MP5hHwbB8eZAVGDgUbl0VUHE6+
         +MV0UpHYd8tG8ivIwZHHsZjPE6W1MUz0tsh3SCFOcMYtIOjVzcfLkvOv+9++XJ42XA6G
         k7gw==
X-Gm-Message-State: APjAAAV0Y7MJuXlgP+TeJIaSgg4hvp91urfptLlxa6L4WFtvRUjA8m6J
        Zs1KocJ6hM6iRdDhSNDg9cCWhw==
X-Google-Smtp-Source: APXvYqzmXc0/BsE6U6ZqsUqmM3+xqc0PQQPLGtthXGRfTO6L+vLdwVN72IHI2sMUPo/xFaSkcFPxBg==
X-Received: by 2002:a5d:634c:: with SMTP id b12mr11135984wrw.127.1567184660191;
        Fri, 30 Aug 2019 10:04:20 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id m23sm9287872wml.41.2019.08.30.10.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 10:04:19 -0700 (PDT)
Date:   Fri, 30 Aug 2019 19:04:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190830170419.GS2312@nanopsycho>
References: <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
 <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
 <20190829052620.GK29594@unicorn.suse.cz>
 <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
 <9ec43634-d2e9-b976-1936-5b7ddc587b76@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ec43634-d2e9-b976-1936-5b7ddc587b76@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 30, 2019 at 04:47:41PM CEST, dsahern@gmail.com wrote:
>On 8/30/19 8:35 AM, Roopa Prabhu wrote:
>> On Wed, Aug 28, 2019 at 10:26 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>>>
>>> On Wed, Aug 28, 2019 at 09:36:41PM -0700, Roopa Prabhu wrote:
>>>>
>>>> yes,  correct. I mentioned that because I was wondering if we can
>>>> think along the same lines for this API.
>>>> eg
>>>> (a) RTM_NEWLINK always replaces the list attribute
>>>> (b) RTM_SETLINK with NLM_F_APPEND always appends to the list attribute
>>>> (c) RTM_DELLINK with NLM_F_APPEND updates the list attribute
>>>>
>>>> (It could be NLM_F_UPDATE if NLM_F_APPEND sounds weird in the del
>>>> case. I have not looked at the full dellink path if it will work
>>>> neatly..its been a busy day )
>>>
>>> AFAICS rtnl_dellink() calls nlmsg_parse_deprecated() so that even
>>> current code would ignore any future attribute in RTM_DELLINK message
>>> (any kernel before the strict validation was introduced definitely will)
>>> and it does not seem to check NLM_F_APPEND or NLM_F_UPDATE either. So
>>> unless I missed something, such message would result in deleting the
>>> network device (if possible) with any kernel not implementing the
>>> feature.
>> 
>> ok, ack. yes today it does. I was hinting if that can be changed to
>> support list update with a flag like the RTM_DELLINK AF_BRIDGE does
>> for vlan list del.
>> 
>> so to summarize, i think we have discussed the following options to
>> update a netlink list attribute so far:
>> (a) encode an optional attribute/flag in the list attribute in
>> RTM_SETLINK to indicate if it is a add or del
>
>The ALT_IFNAME attribute could also be a struct that has both the string
>and a flag.

Not a struct, please :/

>
>> (b) Use a flag in RTM_SETLINK and RTM_DELINK to indicate add/del
>> (close to bridge vlan add/del)
>> (c) introduce a separate generic msg type to add/del to a list
>> attribute (IIUC this does need a separate msg type per subsystem or
>> netlink API)
>> 
>
