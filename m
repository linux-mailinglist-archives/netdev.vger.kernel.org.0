Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB09302C51
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbhAYUNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732184AbhAYUNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 15:13:33 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3D7C061786
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 12:12:44 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id r189so16125779oih.4
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 12:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NJMyRXwG7dU/eZI60Ebtl9+9Ag/0iqRFPyVfiSAZVDo=;
        b=t/WA2Kwns/T25aGI635YlZ43iM3UrMuybatfBMhrmId+N6uGEvdE7DrtkZQNf9sz59
         m6pZSXYIzJWlNbsH+hjbBJGE8H7g4+7M8hvy1z7wHTitjeDqvGtkuOIRk+FErGYqsfOH
         xaMJvLnyg3a271kKXC74vHtni2cU3HZ4l08SB6jkIvnYqU0r8DeVxM4DMaDdOs8zGB84
         goKLsrvvSlVBQKcoAbRqQkvVK2NT5fkIYZYxiQDXWAHeqRgN8DYNbzdJcBjdAuzZ3pgz
         BDvkmie1uIOgq57AIzJh2ie43GRHzk85ND/6gbEMWG2zNZQ49D+mHAp3WLDv/vlsKWJy
         BP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NJMyRXwG7dU/eZI60Ebtl9+9Ag/0iqRFPyVfiSAZVDo=;
        b=lBtKbW2RN6tRg9E15VxaHvA8VaeC27xJlh+9IY/FBd8lGd+ZQfywgoLXI/HHJlMgI9
         dQ5AP5XVovQJU1AahuCssDirAI9ObubgbCgknovvfavLmSdDAXQmMPHB1ndHDHheQIGF
         c7CYpvaRT//4BuokgoiKMRIlLCq7taPg9+OcG9PjNZxNUC4xxKHXF9+Rvf+3xRirus6F
         w1YzgPAYvLMUqKEt/OMX1dJZvcO+ELEUtETMndmlvVw2Bz5/9/MDYqB6+j00LbPdFWDQ
         EsYRPZMrpHPoODuYILQ/xyvTxUdcNWeacpMjk8IBn5VM3dm/bZCN55S72Fc5OMCtjdzn
         Yflg==
X-Gm-Message-State: AOAM5335d/nQHGWrSILHrxBAko9kAEMWtkr2T/tZSvTn1FlV7uUS33ST
        9UyflQwQv+KReoegBxH4TDwiERJaZuY=
X-Google-Smtp-Source: ABdhPJzY0JzRq9BBLFB3iSYYjc5nfvLii5HYrBw3fcA1XYboND/UthocuOcEjUSu4Fs/JcmCQQGjvg==
X-Received: by 2002:a05:6808:902:: with SMTP id w2mr1163598oih.3.1611605563666;
        Mon, 25 Jan 2021 12:12:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:59b3:c1d3:7fbc:c577])
        by smtp.googlemail.com with ESMTPSA id s69sm3731732oih.38.2021.01.25.12.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 12:12:43 -0800 (PST)
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of
 ipv6_rpl_sr_hdr
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org,
        davem@davemloft.net, alex aring <alex.aring@gmail.com>
References: <20210121220044.22361-1-justin.iurman@uliege.be>
 <20210121220044.22361-2-justin.iurman@uliege.be>
 <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be>
 <fd7957e7-ab5c-d2c2-9338-76879563460e@gmail.com>
 <20210125113231.3fac0e10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bf77978e-c204-bf98-6b1b-965d6ebd9bbc@gmail.com>
Date:   Mon, 25 Jan 2021 13:12:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125113231.3fac0e10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 12:32 PM, Jakub Kicinski wrote:
>>>>> diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
>>>>> index 1dccb55cf8c6..708adddf9f13 100644
>>>>> --- a/include/uapi/linux/rpl.h
>>>>> +++ b/include/uapi/linux/rpl.h
>>>>> @@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
>>>>>  		pad:4,
>>>>>  		reserved1:16;
>>>>>  #elif defined(__BIG_ENDIAN_BITFIELD)
>>>>> -	__u32	reserved:20,
>>>>> +	__u32	cmpri:4,
>>>>> +		cmpre:4,
>>>>>  		pad:4,
>>>>> -		cmpri:4,
>>>>> -		cmpre:4;
>>>>> +		reserved:20;
>>>>>  #else
>>>>>  #error  "Please fix <asm/byteorder.h>"
>>>>>  #endif  
>>
>> cross-checking with other headers - tcp and vxlan-gpe - this patch looks
>> correct.
> 
> What are you cross-checking?
> 

https://tools.ietf.org/html/draft-ietf-nvo3-vxlan-gpe-10, Section 3.1
header definition and vxlanhdr_gpe in include/net/vxlan.h. The
__BIG_ENDIAN_BITFIELD part follows the definition in the spec.

Similarly for the TCP header - RFC header definition and tcphdr in
include/uapi/linux/tcp.h. TCP header shows doff + res1 order which is
comparable to cmpri + cpmre in this header as both sets are 4-bits and
start a word.
