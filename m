Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B321B2EAA5E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbhAEMDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbhAEMDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:03:38 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181FEC061574;
        Tue,  5 Jan 2021 04:02:58 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 4so16256942plk.5;
        Tue, 05 Jan 2021 04:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7sOeq1igRILZ3qkNgIHGHcqhKNb2sI9PRb1QCDOORNQ=;
        b=rIE2bAGQhyd/DbcKpJ7JunAFtkVDOTykjRUNhyPFB7FCRwFRpdNchEY4pWEmLR1hI6
         AccU8b/Vw3OoXRjkb8ChFKjlcy3J80xaJGzkY7ADI2Xv/zFvLBf/OPV7o0h9nJW92a/g
         U5Lz2AwmpU/uSrkjy4O73nTFD1cfyWraoos4jwLSwCYerXm3PXuHYq7cmwG7D8/8Qez2
         8BQXby6B/lD21sBLQ73WclonD0idpvoo8vzi8pIJ9jh/O9s9IQLxLyPwyVc6YSzkwf4u
         +9Rm1lRTS1QvED7wQOluIQx4ExYm3987VL/DbDAj9HgZ712LkBg/xv64S9nBEOC+CeBX
         /Q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7sOeq1igRILZ3qkNgIHGHcqhKNb2sI9PRb1QCDOORNQ=;
        b=E63aQXwR67u5NEXArux4nIPrmUcXSvIj4CN7v70LUe6Z5iddCFxYRoSW9XkxlnWtgR
         FTn20jATM5ZQ/DyFKpJohlgSVhGrOOOK8zgR7pd1nY5O3ABaHgqO6+qXQY3WuLQ28rBA
         rgj+sX8ri+BtRAJO0VHQqua6VNlXvTrCBRhdEzbi+DADBWOccQkKGSaPWUcKFzTlecN3
         x4jLFiiOlKIkfHjCBEeqt6yCHRZkhl/yKLagwlZSqKeCgGN3dopBQk7UYpj0malwQZ5X
         FT4hYOZ9077HM+ruz/UxMdHaG087iiQac4gqfNoikAgC2+J+fKOjz8T9emAevDpGxb2c
         GAZw==
X-Gm-Message-State: AOAM531G+3svj+Z0a+aOqm2X2D/VllVS1MPAIpqHWJbNGf97HVeDXi6o
        p5/2yGAo6V/tlz1WrIITM/TfR2P3AK7J2g==
X-Google-Smtp-Source: ABdhPJwuVzI9pIl1CAC8MAVP8OuT7EwqOLwKDOOZAFiwBG8RXG0G1IGGKfDiABJ291CRQimA95ogQg==
X-Received: by 2002:a17:90a:fd08:: with SMTP id cv8mr3663921pjb.29.1609848177451;
        Tue, 05 Jan 2021 04:02:57 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u126sm13917515pfu.113.2021.01.05.04.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 04:02:57 -0800 (PST)
Date:   Tue, 5 Jan 2021 20:02:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Yi Chen <yiche@redhat.com>
Cc:     Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv2 net] selftests: netfilter: Pass the family parameter to
 conntrack tool
Message-ID: <20210105120245.GB1421720@Leo-laptop-t470s>
References: <20210104110723.43564-1-yiche@redhat.com>
 <20210105094316.23683-1-yiche@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105094316.23683-1-yiche@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 05:43:16PM +0800, Yi Chen wrote:
> From: yiche <yiche@redhat.com>
> 
> Fixes: 619ae8e0697a6 ("selftests: netfilter: add test case for conntrack helper assignment")
> 
> Fix nft_conntrack_helper.sh fake fail:
> conntrack tool need "-f ipv6" parameter to show out ipv6 traffic items.
> sleep 1 second after background nc send packet, to make sure check
> is after this statement executed.

The Fixes tag should be above your signoff tag

Fixes: 619ae8e0697a6 ("selftests: netfilter: add test case for conntrack helper assignment")
> Signed-off-by: yiche <yiche@redhat.com>
> ---
>  .../selftests/netfilter/nft_conntrack_helper.sh      | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
> index edf0a48da6bf..bf6b9626c7dd 100755
> --- a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
> +++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
> @@ -94,7 +94,13 @@ check_for_helper()
>  	local message=$2
>  	local port=$3
>  
> -	ip netns exec ${netns} conntrack -L -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
> +	if echo $message |grep -q 'ipv6';then
> +		local family="ipv6"
> +	else
> +		local family="ipv4"
> +	fi
> +
> +	ip netns exec ${netns} conntrack -L -f $family -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
>  	if [ $? -ne 0 ] ; then
>  		echo "FAIL: ${netns} did not show attached helper $message" 1>&2
>  		ret=1
> @@ -111,8 +117,8 @@ test_helper()
>  
>  	sleep 3 | ip netns exec ${ns2} nc -w 2 -l -p $port > /dev/null &
>  
> -	sleep 1
>  	sleep 1 | ip netns exec ${ns1} nc -w 2 10.0.1.2 $port > /dev/null &
> +	sleep 1
>  
>  	check_for_helper "$ns1" "ip $msg" $port
>  	check_for_helper "$ns2" "ip $msg" $port
> @@ -128,8 +134,8 @@ test_helper()
>  
>  	sleep 3 | ip netns exec ${ns2} nc -w 2 -6 -l -p $port > /dev/null &
>  
> -	sleep 1
>  	sleep 1 | ip netns exec ${ns1} nc -w 2 -6 dead:1::2 $port > /dev/null &
> +	sleep 1
>  
>  	check_for_helper "$ns1" "ipv6 $msg" $port
>  	check_for_helper "$ns2" "ipv6 $msg" $port
> -- 
> 2.26.2
> 
