Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4572BA7D08
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfIDHuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:50:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38852 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDHuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:50:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id l11so11272701wrx.5
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 00:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/eA4w6OEFkRIuZKq+fuDzyhmilRXQTLn6E3KMUXe9WU=;
        b=QSsceI72b6M+fPbkY7yGQngvWJNUW/nc6y11HikfQkD/mMKqLXK0JktR8yOOFEz38A
         pxAnFwBCY88jM1OvvHDIbFA/GViwLz8rnyy56JsGvdq0P2RWTKsG1louOiaG0Vi3vFs3
         XQJ4bdUFFn70dmBRhCFq2SIDXQqI2nOkwO2OHDEB5jsyjJx6m7zUDBfbfEjX95KU1NyK
         Jv0g7W5VP9gQA7jsQX6jQG7tv1Hk7fv6KqSW4f16CiLFQkrv1EWskDTBefn/OsNRqzkg
         J1seHx3f9Li0uUSedX+nmZ1VBXTUqlhp20edb+AXB2DYuAFx56+0avh/J+8mNShrbyop
         nxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/eA4w6OEFkRIuZKq+fuDzyhmilRXQTLn6E3KMUXe9WU=;
        b=l2htNNA8I9IXPsvXD0F7XKh1HLiBmTI+i2jXD7Fq1qxCVPkYmISFTm1Lr98hHc4MlW
         2Fa5rC7XNKrHzSMlX0NQ0hf8X2BmJ7z1K/T6dNIk02d2EMp5QdNurS3UsKpn6S/DwwYM
         11JmHavg/8ZzV88V1AXHCSzqq1n0vS9LIflV7cTrowYicX/EhlUNgEaZQKBLiJPTXmi+
         i94QId8TP9EmcVFIXq4Sk7p+85uW+p+94/fLZYKoUKmBJVYB6L/0mcpmUGKTLPNj0rpK
         leMF4icWKXlRSQ77lgtb4yM8rfrsvGpuX/AH7OMv8+DKiq7qExE5XR3ZXnb4dIy9wc1j
         wG9g==
X-Gm-Message-State: APjAAAWOfNT/b2AsshGTNhVjWS+RfNKxjWn4n/QLk5qQMqtK967AzKVl
        zmr1I2LfBof7Smqi4w+zwqQ=
X-Google-Smtp-Source: APXvYqzWxjYGsCeYNHZhCWNlIZyXFq64zhp+8BilYHU/9XeLVHVnVjRd2LS702fJHneNpd49iB7rrg==
X-Received: by 2002:adf:f505:: with SMTP id q5mr30025437wro.242.1567583417539;
        Wed, 04 Sep 2019 00:50:17 -0700 (PDT)
Received: from [192.168.8.147] (83.173.185.81.rev.sfr.net. [81.185.173.83])
        by smtp.gmail.com with ESMTPSA id o129sm2310387wmb.41.2019.09.04.00.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 00:50:16 -0700 (PDT)
Subject: Re: [PATCHv2 net-next] ipmr: remove cache_resolve_queue_len
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
 <20190904033408.13988-1-liuhangbin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <aa759647-953e-23b5-32e2-b0b7373e07e4@gmail.com>
Date:   Wed, 4 Sep 2019 09:50:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904033408.13988-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/4/19 5:34 AM, Hangbin Liu wrote:
> This is a re-post of previous patch wrote by David Miller[1].
> 
> Phil Karn reported[2] that on busy networks with lots of unresolved
> multicast routing entries, the creation of new multicast group routes
> can be extremely slow and unreliable.
> 
> The reason is we hard-coded multicast route entries with unresolved source
> addresses(cache_resolve_queue_len) to 10. If some multicast route never
> resolves and the unresolved source addresses increased, there will
> be no ability to create new multicast route cache.
> 
> To resolve this issue, we need either add a sysctl entry to make the
> cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
> directly, as we already have the socket receive queue limits of mrouted
> socket, pointed by David.
> 
> From my side, I'd perfer to remove the cache_resolve_queue_len instead
> of creating two more(IPv4 and IPv6 version) sysctl entry.

> +static int queue_count(struct mr_table *mrt)
> +{
> +	struct list_head *pos;
> +	int count = 0;
> +
> +	spin_lock_bh(&mfc_unres_lock);
> +	list_for_each(pos, &mrt->mfc_unres_queue)
> +		count++;
> +	spin_unlock_bh(&mfc_unres_lock);
> +
> +	return count;
> +}

I guess that even if we remove a limit on the number of items, we probably should
keep the atomic counter (no code churn, patch much easier to review...)

Your patch could be a one liner really [1]

Eventually replacing this linear list with an RB-tree, so that we can be on the safe side.

[1]
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c07bc82cbbe96d53d05c1665b2f03faa055f1084..313470f6bb148326b4afbc00d265b6a1e40d93bd 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1134,8 +1134,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 
        if (!found) {
                /* Create a new entry if allowable */
-               if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
-                   (c = ipmr_cache_alloc_unres()) == NULL) {
+               c = ipmr_cache_alloc_unres();
+               if (!c) {
                        spin_unlock_bh(&mfc_unres_lock);
 
                        kfree_skb(skb);
