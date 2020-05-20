Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2271DB793
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgETO6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETO6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 10:58:37 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E7BC061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 07:58:37 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w4so3208395oia.1
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 07:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K0LyoL+2AU2n4TQdOPFf+OzPcMFGocE8oRaCR1biBQo=;
        b=XL4rQhvdzmCjkXpugkBL3h8pImBlm6sUMBIZALBZRSJ0b/KsawmziCdSXHGQhHIMpn
         Py0ENFbwDqcRf9whNAAOCCiTQRFzK2l3UXVm96GKUAsYcjfRIFfaRWWBblAKyFHTOrpA
         24INFHOP/J74aQaHrfWnG1h7Y2p6tJpEdiqsdPGXtTYV2XJQsmHlUfdGUDw1TGYN7NSa
         JWhEyFjbsgYoe+DEj6lBsZBFl39vWYh98dTP52nfVcyqNYh6KXgxspUtCjf0ds/LzbLr
         gBctqYxuHvcMtCvaXr7isYyqaZcra7QXxL+1HwhemmkKL9X8nw5hcN0wOYBqS4/ubX8R
         XkFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K0LyoL+2AU2n4TQdOPFf+OzPcMFGocE8oRaCR1biBQo=;
        b=j/SzJMfIc44AAEKX4UhDDAIDZ1JhCWdplq7TTYWl36jEbr3x/gywtxRHH+WUZ5eQsN
         D11j4vNaS8zGKCgBPT/Lp1PxK2agW674ujyveFOivCPaOVsUrDUCId+NK/TcqhIe9jKU
         qemFnfscgiVk2+IZm11/bvmTq+VOPgiwnkOjv4X5e2TFDrMz9YkcbG0Pw5sxc4hOCfuP
         y5bJ25TBOIcOQhVvOeH1jEZJ16Mr+FmbVHjjvPj+dHzHqPISBbFhuVlCq2Qpxgy/bsHV
         BwhIRK22sa8qdUi2sdM6HwQcQCNh0GmA38R6N3oYqQbGiF2ATTF5ML3gZCqz5Fmd4sBX
         1wZw==
X-Gm-Message-State: AOAM530GQtiW9JIdXvQzZbSScSCFt3KhP5dqc2Nu8NWqPQqZJ1IxV05q
        IHKEiuHYzOo+1n7HteN4/Ho=
X-Google-Smtp-Source: ABdhPJyjlQ684Ky1ixytrRBeIs83XJCWz2Ifwlac1LuiFWG9oIrI2EoXgzU/z8nzynpnMIvEs1QaVg==
X-Received: by 2002:aca:cf12:: with SMTP id f18mr3270288oig.117.1589986716635;
        Wed, 20 May 2020 07:58:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d5aa:9958:3110:547b? ([2601:282:803:7700:d5aa:9958:3110:547b])
        by smtp.googlemail.com with ESMTPSA id j25sm831359oot.7.2020.05.20.07.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 07:58:36 -0700 (PDT)
Subject: Re: [PATCH net-next v2 5/5] selftests: net: add fdb nexthop tests
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
References: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
 <1589949214-14711-6-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <16c3de2b-2792-603d-4b3b-aa016a5f7538@gmail.com>
Date:   Wed, 20 May 2020 08:58:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589949214-14711-6-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 10:33 PM, Roopa Prabhu wrote:
> +ipv6_fdb_grp_fcnal()
> +{
> +	local rc
> +
> +	echo
> +	echo "IPv6 fdb groups functional"
> +	echo "--------------------------"
> +
> +	check_nexthop_fdb_support
> +	if [ $? -eq $ksft_skip ]; then
> +		return $ksft_skip
> +	fi
> +
> +	# create group with multiple nexthops
> +	run_cmd "$IP nexthop add id 61 via 2001:db8:91::2 fdb"
> +	run_cmd "$IP nexthop add id 62 via 2001:db8:91::3 fdb"
> +	run_cmd "$IP nexthop add id 102 group 61/62 fdb"
> +	check_nexthop "id 102" "id 102 group 61/62 fdb"
> +	log_test $? 0 "Fdb Nexthop group with multiple nexthops"
> +
> +	## get nexthop group
> +	run_cmd "$IP nexthop get id 102"
> +	check_nexthop "id 102" "id 102 group 61/62 fdb"
> +	log_test $? 0 "Get Fdb nexthop group by id"
> +
> +	# fdb nexthop group can only contain fdb nexthops
> +	run_cmd "$IP nexthop add id 63 via 2001:db8:91::4"
> +	run_cmd "$IP nexthop add id 64 via 2001:db8:91::5"
> +	run_cmd "$IP nexthop add id 103 group 63/64 fdb"
> +	log_test $? 2 "Fdb Nexthop group with non-fdb nexthops"
> +
> +	# Non fdb nexthop group can not contain fdb nexthops
> +	run_cmd "$IP nexthop add id 65 via 2001:db8:91::5 fdb"
> +	run_cmd "$IP nexthop add id 66 via 2001:db8:91::6 fdb"
> +	run_cmd "$IP nexthop add id 104 group 65/66"
> +	log_test $? 2 "Non-Fdb Nexthop group with non nexthops"

Typo "non nexthops" should be "fdb nexthops"

...

> +
> +ipv4_fdb_grp_fcnal()
> +{
> +	local rc
> +
> +	echo
> +	echo "IPv4 fdb groups functional"
> +	echo "--------------------------"
> +
> +	check_nexthop_fdb_support
> +	if [ $? -eq $ksft_skip ]; then
> +		return $ksft_skip
> +	fi
> +
> +	# create group with multiple nexthops
> +	run_cmd "$IP nexthop add id 12 via 172.16.1.2 fdb"
> +	run_cmd "$IP nexthop add id 13 via 172.16.1.3 fdb"
> +	run_cmd "$IP nexthop add id 102 group 12/13 fdb"
> +	check_nexthop "id 102" "id 102 group 12/13 fdb"
> +	log_test $? 0 "Fdb Nexthop group with multiple nexthops"
> +
> +	# get nexthop group
> +	run_cmd "$IP nexthop get id 102"
> +	check_nexthop "id 102" "id 102 group 12/13 fdb"
> +	log_test $? 0 "Get Fdb nexthop group by id"
> +
> +	# fdb nexthop group can only contain fdb nexthops
> +	run_cmd "$IP nexthop add id 14 via 172.16.1.2"
> +	run_cmd "$IP nexthop add id 15 via 172.16.1.3"
> +	run_cmd "$IP nexthop add id 103 group 14/15 fdb"
> +	log_test $? 2 "Fdb Nexthop group with non-fdb nexthops"
> +
> +	# Non fdb nexthop group can not contain fdb nexthops
> +	run_cmd "$IP nexthop add id 16 via 172.16.1.2 fdb"
> +	run_cmd "$IP nexthop add id 17 via 172.16.1.3 fdb"
> +	run_cmd "$IP nexthop add id 104 group 14/15"
> +	log_test $? 2 "Non-Fdb Nexthop group with non nexthops"

same here

Reviewed-by: David Ahern <dsahern@gmail.com>

