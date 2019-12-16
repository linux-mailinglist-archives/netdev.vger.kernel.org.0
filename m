Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E8211FD26
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 04:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLPDKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 22:10:19 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33136 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfLPDKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 22:10:19 -0500
Received: by mail-io1-f68.google.com with SMTP id z8so3539493ioh.0
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 19:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qJ4yMM1U7B8VPXHSyOGiuEMZuJ2QhhNkENA5uEWq5nE=;
        b=QUpkl5WRO3n72cM89rUeUmzvCc+TIeMnZNT6GDUCcLKVFdDZ3ZE/1OPP9S8vdyZqK2
         rrLCRegc3awLX0BTtqoJ9BFKoCyD7uYLzPXANL2qLAPZr9CxiYXg2Mr7/ASIMLIyc6TL
         GuiSstp1sk4w6hC9WioCdc2qSBi+ls9m3DtqQxFS3Oi6uaFusiPzOkjRgIjaR5B2hXp3
         1L+GjrkWP98N/13WlGTYfUsti9oMhSrXOWm14Y+fqmfqHXN8GmVDUIAa0ujBs99OJqys
         1xa7ghR5ptu4I+M6NXgROhRZgAZs9kk6fWj3wdEjYm/AxPtyeHfVmVmPfAfdvlHPW7fL
         1uGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qJ4yMM1U7B8VPXHSyOGiuEMZuJ2QhhNkENA5uEWq5nE=;
        b=DHg25zDXcCem8P6mBCS6mD30qTXP/PDYO0xQOCLMC0vA0nqyLAiWb6464KqkR7zSfA
         5AeI9Z8UmrHuGQyo3EgbnLTfYfRJFOXBHAM5emdqKPLMpBAy5GlCjx+1C6ixaFVMRmKr
         pb+pKhX64YjUqOvcFFKqSuiMF8DjWpusZNe8WUzFv+1pWXL5TsL8241hegsytKVe0aCM
         GI+qTPFbrFH3/3DYxsiqhRu8Wm47QuBqQsur7VBtyJwEKvHbThYqZ9zkO3xzi5qOa1mL
         7cl7hBwNI/8gITWjj/lmve4TfxfziF+n73oAWkOXfY43Oy/czF/7mCZ9p9AUp45qN/PV
         vEog==
X-Gm-Message-State: APjAAAXxOa+RbjrQBeGcsURPTNgNfRS3dPdeyjf220XkFJagTehsNlk8
        07U6Wt5+xTE39bP+p7lDcFxUG2eCgSI=
X-Google-Smtp-Source: APXvYqzwYfMB2LTQ51vgQnS9jDktUZcPuHGnqxoPu5Dy6GMnxTuDZs+PV/lky2Z3YEDwM2HFCxcTlA==
X-Received: by 2002:a6b:b50b:: with SMTP id e11mr47800iof.223.1576465818115;
        Sun, 15 Dec 2019 19:10:18 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:6046:f5bd:4635:2d5b? ([2601:284:8202:10b0:6046:f5bd:4635:2d5b])
        by smtp.googlemail.com with ESMTPSA id c8sm909603ilh.58.2019.12.15.19.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 19:10:17 -0800 (PST)
Subject: Re: [PATCH net-next v2] bonding: move 802.3ad port state flags to
 uapi
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Roulin <aroulin@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stephen@networkplumber.org
References: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com>
 <20191214131809.1f606978@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1076ce41-2cd5-e1d9-9b9f-ddc01385d343@gmail.com>
Date:   Sun, 15 Dec 2019 20:10:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214131809.1f606978@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/19 2:18 PM, Jakub Kicinski wrote:
> On Wed, 11 Dec 2019 14:30:58 -0800, Andy Roulin wrote:
>> The bond slave actor/partner operating state is exported as
>> bitfield to userspace, which lacks a way to interpret it, e.g.,
>> iproute2 only prints the state as a number:
>>
>> ad_actor_oper_port_state 15
>>
>> For userspace to interpret the bitfield, the bitfield definitions
>> should be part of the uapi. The bitfield itself is defined in the
>> 802.3ad standard.
>>
>> This commit moves the 802.3ad bitfield definitions to uapi.
>>
>> Related iproute2 patches, soon to be posted upstream, use the new uapi
>> headers to pretty-print bond slave state, e.g., with ip -d link show
>>
>> ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
>>
>> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
>> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> Applied, I wonder if it wouldn't be better to rename those
> s/AD_/BOND_3AD_/ like the prefix the stats have. 
> But I guess it's unlikely user space has those exact defines 
> set to a different value so can't cause a clash..
> 

I think that would be a better namespace now that it is in the UAPI.
