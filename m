Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D368A42E166
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhJNShG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhJNShG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:37:06 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EF4C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:35:01 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id k3so4545666ilu.2
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FwUeMoPWL9inNO+LURXxh7KICLo2YBfVK8NCY8LIn4k=;
        b=QcOAj2KqZG0WtqX7TSaLY+QPA5IlMFMlBBEhjaud1tvF4a8x/TQTdwwziAQrKVJWnD
         /5i+D9gCFhoMlvkizoc7iYdaR407zHUrT3wZ8NyTP+f1lS8CfmZ7UcMcLHsd5OAkRw5T
         g5yzZGZSrcd4ir9F0+vIKPed30GUPBNCjVJlfNjjrxPgknD9LJGSFX3gUSBaOtO/olAW
         CEKEX7d9ZI+1WQi7BrB5xaMN5AUdNB0ibjtxKPmXeeS8XM+XJLc3Fq0VpE6rsfYx7zOd
         DqV4K0UXrKx2m+feDbagpisrsl2m0+JZ9ABC4VNhqG/786FO8lkMXKAhb7yujAnfPEGU
         19Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FwUeMoPWL9inNO+LURXxh7KICLo2YBfVK8NCY8LIn4k=;
        b=CqIieyuC1nHJbED9ONlj1wdkcsztRXJwNX+Rs0k3Xm+9W8KP722Xxc1c5VBhIKLJfe
         gnfORiINT9IxQXgwI9qvGuq/WtGn29eHuYNehCWRAfG7HnKU8Ot3SDC6KNZGSkSfQdtg
         klohYAmf9grNXNAuWG45GlZnTrLFEZTLkN7g5stzHCdc+yXyTiJeowuzMWcbvZjnn2JG
         oW5abW+9BiNUQ0Z5apEJ6jZK0ENvYN3jV/8NTBnhCcf4zaIppNmHD3PcqNgERRSw9MBY
         OZUba0LoSPSKIdIHxUMF0+NgB2+LnET3BS1zJ5EVF0SJNr0+xXyllgOgG9CZ5k03DDg2
         ANgA==
X-Gm-Message-State: AOAM533gzG7nrs6puebe4VWrKC1rQUE167Ya6WLOAT+dTMg484S1AWKA
        h/5bpwahJNy8IZ84kPTTx3P50DgRLwavdw==
X-Google-Smtp-Source: ABdhPJxzjkdn2XZ4mWip6AtjKaQbVAhHPobDxHDoTUJdocZZCe3z4f+GTE540pdgqUidUjIrt2NjmQ==
X-Received: by 2002:a05:6e02:1a05:: with SMTP id s5mr445958ild.303.1634236500524;
        Thu, 14 Oct 2021 11:35:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id e14sm1501162ioe.37.2021.10.14.11.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 11:35:00 -0700 (PDT)
Subject: Re: [PATCH 3/4] doc: networking: document arp_evict_nocarrier
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
References: <20211013222710.4162634-1-prestwoj@gmail.com>
 <20211013222710.4162634-3-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ab4e882-3778-6711-7c43-c1eebdb340c0@gmail.com>
Date:   Thu, 14 Oct 2021 12:34:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013222710.4162634-3-prestwoj@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 4:27 PM, James Prestwood wrote:
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c2ecc9894fd0..174d9d3ee5c2 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1565,6 +1565,15 @@ arp_accept - BOOLEAN
>  	gratuitous arp frame, the arp table will be updated regardless
>  	if this setting is on or off.
>  
> +arp_evict_nocarrier - BOOLEAN
> +	Clears the ARP cache on NOCARRIER events. This option is important for
> +	wireless devices where the ARP cache should not be cleared when roaming
> +	between access points on the same network. In most cases this should
> +	remain as the default (1).
> +
> +	- 1 - (default): Clear the ARP cache on NOCARRIER events
> +	- 0 - Do not clear ARP cache on NOCARRIER events
> +
>  mcast_solicit - INTEGER
>  	The maximum number of multicast probes in INCOMPLETE state,
>  	when the associated hardware address is unknown.  Defaults
> 

documentation can be added to the patch that adds the new sysctl
