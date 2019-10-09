Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A88D0560
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfJIB55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:57:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40245 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfJIB54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:57:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id x127so538563pfb.7
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 18:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=C32zwu+KlgxFi1/oGn1adCo4dLqtSAkZ67Mif/GjQJ8=;
        b=jsL27nLwDY7xk9vFODOfzr3qJth2nSS22W80YXyOn8UapCvHSIDPhoFi2MrxijMu0Z
         rjT9J5XR6pJE0rQDbejaSdU0fEg1t7z0NILS7DLBIrmF9V6QuZN9nWbGF/li3FBQWTTC
         FuMnMl4sVRnTIFZmPRG2nXGNQ0VJHB4f248jRoHnAbCasUUJmtYv9UuU34L02kxrGepy
         SEB6T90WKtzaqKO9Kee4DL91C1BSftdZvskR86NWsDhnyLb0fMsMb7HOAJ+N+iBDuxtr
         oH1GZ+uVcEKt8qfU9lq7fV0bUH1cZs9QBHPeCdQdWjKWleccn5L1O/q3nPjYkrhkHpYw
         WxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=C32zwu+KlgxFi1/oGn1adCo4dLqtSAkZ67Mif/GjQJ8=;
        b=el65/F2OVkRDGOW8cXo2I8NMuwiw1AdZ4S7gZCp5n2RP5hEoXZNR+PfXUXBwgRfQJd
         NZ5QA89Bp0MO5a3PL2da0RUnDLZZ0LDv9xKtHbD/mHE2W2C8wXdH9DVeHr1lCDKN5J6B
         yXxTKBf/OskqeAe6paqsyosuG14MCX35aE2I8+QN5aybz9WGb51mIxQYxZJpowgz3P04
         f75DP6+gimANOrAt4YSIMKXFoXTwa4UAV3XhlELmWTcTMj6iLiKa4XOvDqmaYlxMeH/z
         8UvoLpSzDg3WVd+l81ljRu3ZVo2Afd/97MlPxo0L0Hf6QY/73EiMzTCkMXpEpaCS2ha6
         tuOw==
X-Gm-Message-State: APjAAAVMStcdUcyoCh//8Qx/gTbZDJJ3/WOBVdoVgWFY3EPttKHKaSHu
        SW5o6PqaG06bpaf8KRNMzoP2n/FpAhY=
X-Google-Smtp-Source: APXvYqzxt5qvn69Z7aCDb8VWD7DHauHPh8MwbOTIBbIlWJ/u0BastXyaSbIVODpKVvwwjb3wkhnylg==
X-Received: by 2002:a62:5c07:: with SMTP id q7mr1100573pfb.159.1570586274491;
        Tue, 08 Oct 2019 18:57:54 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id m102sm378217pje.5.2019.10.08.18.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 18:57:53 -0700 (PDT)
Date:   Tue, 8 Oct 2019 18:57:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Christopher KOBAYASHI <chris@disavowed.jp>
Cc:     netdev@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] net/appletalk: restore success case for
 atalk_proc_init()
Message-ID: <20191008185741.10afd266@cakuba.netronome.com>
In-Reply-To: <20191009012630.GA106292@basementcat>
References: <20191009012630.GA106292@basementcat>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 10:26:30 +0900, Christopher KOBAYASHI wrote:
> Commit e2bcd8b0ce6ee3410665765db0d44dd8b7e3b348 to
> net/appletalk/atalk_proc.c removed the success case, rendering
> appletalk.ko inoperable.  This one-liner restores correct operation.
> 
> Signed-off-by: Christopher KOBAYASHI <chris@disavowed.jp>

Thank you, the code looks correct!

Could you improve the commit message a little bit?
Could you add a Fixes tag and use the standard way of quoting commits?

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

Once done could you send the patch again indicating this is the second
revision in the subject?

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#the-canonical-patch-format

> diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
> index 550c6ca007cc..9c1241292d1d 100644
> --- a/net/appletalk/atalk_proc.c
> +++ b/net/appletalk/atalk_proc.c
> @@ -229,6 +229,8 @@ int __init atalk_proc_init(void)
>  				     sizeof(struct aarp_iter_state), NULL))
>  		goto out;
>  
> +	return 0;
> +
>  out:
>  	remove_proc_subtree("atalk", init_net.proc_net);
>  	return -ENOMEM;

