Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CED11BA96
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbfLKRqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:46:19 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44835 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730370AbfLKRqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:46:19 -0500
Received: by mail-pl1-f194.google.com with SMTP id bh2so1688303plb.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pH/MeUG6U+PeUxo9WVjeAv7eJhTh2CljY/V4Bq5aQrg=;
        b=kYMXVcJ2MmQZdtM9JZaPTil1JZheXrYs23mYC69S6zmXRcHSfpZsJPt6rEL9vttNtn
         dEe4qklWZzLYeP/P4Cz76chLn01UBoS9rm/8Wo0nhHEmPF9kI8b56CnYIj4V+y6dpGXy
         8Xupa0nGeyIIqQjbl2IE+5pVLMrA7d/YIRxyUfoQL9trGcLKAgW12BAX/rW3JU7GPOhI
         VASDTUw4jpb4ld4zjrIforLTO0jNts2hpL51iEmjS50Y4Rz81/NiOghTj/lUWc2f8y/9
         mUtXLN+6HVDIn5JAcKPzXPjmxtjR+r49EDs6MZrQmg+ZCE0mb7+kra4gc5CAjZxdzVK3
         xHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pH/MeUG6U+PeUxo9WVjeAv7eJhTh2CljY/V4Bq5aQrg=;
        b=Fo83tAvd7ncVGg2OQCrMRNrdy8SejaMbzKHvV4KQrgHCAqtCjgVRiwuJbDovGqLP+n
         EAdC+wk7moTykhTxQIBXRr0YSe7CkWAbMsIsIIPue5h6FlrVvHRo9YVE35J8h1DnEHYK
         90BNd4AkzcfUvaQTRVZJMMV1PBu6lFTmn+0hXInA6k74wAaEfOGU/Ott0jkRFmOrfG3A
         nk/uESnY7ODV8FAAx5dIP4l3pEmNPyxdeGd5cG0nLCLJX1hPnJ5mzF1Mh4k8hKpP4muX
         IPurHUr34eg9HpD/sCzEnxdCnvKxwhUaLRvvHgmpyzBPGB6mFOeOGofXM1aEPw3Lpblj
         mkXA==
X-Gm-Message-State: APjAAAX4c2Vh114TPwHo96VsIL5zBASqaZ0wdIVwNuCqseElsgggGQTG
        LGkOWRegsDRD/OrhccNnqPLSSg==
X-Google-Smtp-Source: APXvYqwME9tYryxKSlnBP/bHZxeWLRFSR9tVq3Iri7kK2Qq3DliCuRtE83dE03NyiazxAsu/4P2i8w==
X-Received: by 2002:a17:90a:ba08:: with SMTP id s8mr4651030pjr.69.1576086378371;
        Wed, 11 Dec 2019 09:46:18 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 16sm3788242pfh.182.2019.12.11.09.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 09:46:18 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:46:15 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/5] ethtool netlink interface, preliminary
 part
Message-ID: <20191211094615.79cb56bc@cakuba.netronome.com>
In-Reply-To: <cover.1576057593.git.mkubecek@suse.cz>
References: <cover.1576057593.git.mkubecek@suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 10:58:09 +0100 (CET), Michal Kubecek wrote:
> As Jakub Kicinski suggested in ethtool netlink v7 discussion, this
> submission consists only of preliminary patches which raised no objections;
> first four patches already have Acked-by or Reviewed-by.
> 
> - patch 1 exposes permanent hardware address (as shown by "ethtool -P")
>   via rtnetlink
> - patch 2 is renames existing netlink helper to a better name
> - patch 3 and 4 reorganize existing ethtool code (no functional change)
> - patch 5 makes the table of link mode names available as an ethtool string
>   set (will be needed for the netlink interface) 

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
